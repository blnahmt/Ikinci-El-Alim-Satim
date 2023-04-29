import 'package:flutter/material.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/buttons/go_back_button.dart';
import 'package:ikinci_el/ui/widgets/buttons/simple_button.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_detail.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/navigation/routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var uDetail = context.read<AuthProvider>().userDetail;
    return Scaffold(
      appBar: AppBar(
        leading: const GoBackButton(),
        iconTheme: context.themeData.iconTheme,
        title: const Text("Profilim"),
        actions: [
          IconButton(
              onPressed: () =>
                  NavigationService().to(routeName: Routes.settings),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: context.paddingNormalOnly(right: true, left: true),
            child: Padding(
              padding: context.paddingMediumAll,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: context.dynamicWidth(14),
                    backgroundImage: NetworkImage(uDetail?.photoURL ?? ""),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Text(
                      uDetail?.name ?? "",
                      maxLines: 1,
                      style: context.textTheme.headlineSmall,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: context.paddingMediumAll,
            child: Text(
              "Ürünlerim",
              style: context.textTheme.bodyLarge,
            ),
          ),
          Expanded(child: const MyRecordListView())
        ],
      ),
    );
  }
}

class MyRecordListView extends StatefulWidget {
  const MyRecordListView({
    Key? key,
  }) : super(key: key);

  @override
  State<MyRecordListView> createState() => _MyRecordListViewState();
}

class _MyRecordListViewState extends State<MyRecordListView> {
  List<RecordDetail> records = [];
  late UserDetail? uDetail;
  bool isLoading = false;
  changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    uDetail = context.read<AuthProvider>().userDetail;
    initRecords();
  }

  Future<void> initRecords() async {
    changeIsLoading();
    records = await FirestoreManager().getUserRecords(uDetail!.uid!);
    changeIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: initRecords,
      child: ListView.builder(
        padding: context.paddingMediumAll,
        itemCount: records.length,
        itemBuilder: (context, index) {
          var record = records[index];
          return RecordTileProfile(
            record: record,
            user: uDetail!,
          );
        },
      ),
    );
  }
}

class RecordTileProfile extends StatelessWidget {
  const RecordTileProfile(
      {super.key, required this.record, required this.user});
  final RecordDetail record;
  final UserDetail user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService()
            .to(routeName: Routes.recordDetail, args: [record, user, true]);
      },
      child: Padding(
        padding: context.paddingMediumOnly(bottom: true),
        child: Stack(
          children: [
            Container(
              height: context.dynamicWidth(65),
              decoration: BoxDecoration(
                color: context.themeData.cardColor,
                borderRadius: context.radiusLow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: record.images!.first,
                    child: Container(
                      height: context.dynamicWidth(40),
                      decoration: BoxDecoration(
                          borderRadius: context.radiusLow,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                record.images!.first,
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
                          Padding(
                            padding: context.paddingLowOnly(top: true),
                            child: Text(
                              record.title ?? "title",
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: context.paddingLowOnly(top: true),
                              child: Text(
                                record.description ?? "title",
                                style: context.primarytTextTheme.bodySmall,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                context.paddingLowOnly(right: true, left: true),
                            child: Text(
                              "${record.price} ₺",
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
                bottom: 5,
                child: FittedBox(
                    child: SimpleButton(
                        onTap: () async {
                          await NavigationService()
                              .to(routeName: Routes.editRecord, args: record);
                        },
                        label: "Düzenle"))),
            Positioned(
                right: 5,
                bottom: 64,
                child: FittedBox(child: record.category?.icon))
          ],
        ),
      ),
    );
  }
}
