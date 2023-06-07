import 'package:flutter/material.dart';
import 'package:ikinci_el/core/cache/cache_manager.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/enums/category_enum.dart';
import 'package:ikinci_el/core/enums/sort_types_enum.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/mixins/dialog_mixin.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/models/user_detail.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:ikinci_el/ui/widgets/loading/loading.dart';
import 'package:provider/provider.dart';

import '../../widgets/buttons/simple_button.dart';
import '../../widgets/inputs/search_input.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with DialogMixin, SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<RecordDetail> records = [];
  List<RecordDetail> recordsSearched = [];
  bool isLoading = false;
  changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  String filtrele = "Sırala";

  setFiltrele(int value) {
    switch (value) {
      case 0:
        filtrele = "Son Eklenenler";
        break;
      case 1:
        filtrele = "Artan Fiyat";
        break;
      case 2:
        filtrele = "Azalan Fiyat";
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: Categories.values.length, vsync: this);
    int val = 0;
    String sort = CacheManager()
        .getString(PrefTagsString.recordSort, SortTypes.dateAdded.name);

    String order = CacheManager().getString(PrefTagsString.recordOrder, "DESC");

    if (sort != SortTypes.dateAdded.name) {
      val = order == "DESC" ? 1 : 2;
    }
    setFiltrele(val);

    initRecords(0);
  }

  Future<void> initRecords(int category) async {
    changeIsLoading();
    records = await FirestoreManager().getAllRecords(category);
    recordsSearched.clear();
    recordsSearched.addAll(records);
    changeIsLoading();
  }

  Future<void> searchRecords(String value) async {
    changeIsLoading();
    records.clear();
    records = recordsSearched.where(
      (element) {
        return element.title!.toLowerCase().contains(value.toLowerCase()) ||
            element.description!.toLowerCase().contains(value.toLowerCase());
      },
    ).toList();

    changeIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildGoProfileButton(context),
        centerTitle: true,
        iconTheme: context.themeData.iconTheme,
        title: SearchInput(
          controller: _searchController,
          label: 'Ara',
          onChanged: (value) => searchRecords(value),
        ),
        bottom: TabBar(
            onTap: (value) {
              _searchController.text = "";
              initRecords(value);
            },
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: context.colorScheme.onBackground,
            indicator: BoxDecoration(),
            tabs: Categories.values
                .map((e) => Container(
                      padding: context.paddingLowAll,
                      decoration:
                          Categories.values.indexOf(e) == _tabController.index
                              ? BoxDecoration(
                                  color: context.colorScheme.primary,
                                  border: Border.all(
                                    width: 1,
                                    color: context.colorScheme.primary,
                                  ),
                                  borderRadius: context.radiusLow)
                              : BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: context.colorScheme.primary,
                                  ),
                                  borderRadius: context.radiusLow),
                      child: Tab(
                        height: context.dynamicHeight(3),
                        child: Row(
                          children: [
                            e.icon,
                            const SizedBox(width: 8),
                            Text(e.label)
                          ],
                        ),
                      ),
                    ))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationService().to(routeName: Routes.addNewRecord);
        },
        label: Text(
          "Sat",
          style: context.textTheme.headlineSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: context.paddingMediumOnly(right: true),
            alignment: Alignment.centerRight,
            child: DropdownButton<int>(
              hint: Text(
                filtrele,
                style: context.themeData.textTheme.bodyLarge?.copyWith(color: AppColors.fieryRose),
              ),
              elevation: 0,
              borderRadius: context.radiusLow,
              dropdownColor: context.themeData.cardColor,
              items: const [
                DropdownMenuItem<int>(value: 0, child: Text("Son Eklenenler")),
                DropdownMenuItem<int>(value: 1, child: Text("Artan Fiyat")),
                DropdownMenuItem<int>(value: 2, child: Text("Azalan Fiyat"))
              ],
              onChanged: (value) {
                switch (value) {
                  case 0:
                    CacheManager().setString(
                        PrefTagsString.recordSort, SortTypes.dateAdded.name);
                    CacheManager()
                        .setString(PrefTagsString.recordOrder, "DESC");
                    break;
                  case 1:
                    CacheManager().setString(
                        PrefTagsString.recordSort, SortTypes.price.name);
                    CacheManager().setString(PrefTagsString.recordOrder, "ASC");
                    break;
                  case 2:
                    CacheManager().setString(
                        PrefTagsString.recordSort, SortTypes.price.name);
                    CacheManager()
                        .setString(PrefTagsString.recordOrder, "DESC");
                    break;
                  default:
                }
                setFiltrele(value ?? 0);
                _searchController.text = "";
                initRecords(_tabController.index);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => initRecords(_tabController.index),
              child: isLoading
                  ? Center(child: Loading())
                  : records.length == 0
                      ? Center(
                          child: Text(
                              "${Categories.values[_tabController.index].label} kategorisinde hiç ürün bulunamadı ..."),
                        )
                      : ListView.builder(
                          padding: context.paddingMediumAll,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            var record = records[index];
                            return RecordTileHome(record: record);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildGoProfileButton(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll,
      child: InkWell(
        onTap: (() {
          NavigationService().to(routeName: Routes.profile);
        }),
        child: context.watch<AuthProvider>().userDetail?.photoURL == null
            ? const CircleAvatar(
                backgroundImage: AssetImage("assets/images/defaultUser.png"),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(
                    context.watch<AuthProvider>().userDetail?.photoURL ?? ""),
              ),
      ),
    );
  }
}

class RecordTileHome extends StatefulWidget {
  const RecordTileHome({
    Key? key,
    required this.record,
  }) : super(key: key);

  final RecordDetail record;

  @override
  State<RecordTileHome> createState() => _RecordTileHomeState();
}

class _RecordTileHomeState extends State<RecordTileHome> {
  UserDetail? _user;
  bool isLoading = false;
  changeIsLoading() {
    setState(() {
      isLoading != isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    changeIsLoading();
    _user = await FirestoreManager().getUserDetail(widget.record.uid!);
    changeIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService().to(
            routeName: Routes.recordDetail,
            args: [widget.record, _user, false]);
      },
      child: Stack(
        children: [
          Container(
            margin: context.paddingNormalOnly(bottom: true),
            height: context.dynamicWidth(35),
            decoration: BoxDecoration(
              color: context.themeData.cardColor,
              borderRadius: context.radiusLow,
            ),
            child: Row(
              children: [
                Hero(
                  tag: widget.record.images!.first,
                  child: Container(
                    height: context.dynamicWidth(35),
                    width: context.dynamicWidth(35),
                    decoration: BoxDecoration(
                        borderRadius: context.radiusLow,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.record.images!.first,
                            ))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: context.paddingLowAll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _user == null
                            ? SizedBox.shrink()
                            : Row(
                                children: [
                                  CircleAvatar(
                                    radius: context.dynamicWidth(3),
                                    backgroundImage:
                                        NetworkImage(_user!.photoURL ?? ""),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(_user!.name ?? "")
                                ],
                              ),
                        Padding(
                          padding: context.paddingLowOnly(top: true),
                          child: Text(
                            widget.record.title ?? "title",
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: context.paddingLowOnly(top: true),
                            child: Text(
                              widget.record.description ?? "title",
                              style: context.primarytTextTheme.bodySmall,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              context.paddingLowOnly(right: true, left: true),
                          child: Text(
                            "${widget.record.price} ₺",
                            style: context.textTheme.bodyLarge,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 5,
              bottom: 10,
              child: FittedBox(
                  child: SimpleButton(
                      onTap: () {
                        NavigationService().to(
                            routeName: Routes.recordDetail,
                            args: [widget.record, _user]);
                      },
                      label: "İncele"))),
          Positioned(
              right: 5,
              top: 5,
              child: FittedBox(child: widget.record.category?.icon))
        ],
      ),
    );
  }
}
