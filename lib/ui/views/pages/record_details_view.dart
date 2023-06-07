import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/models/user_detail.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordDetailView extends StatefulWidget {
  RecordDetailView(
      {super.key,
      required this.record,
      required this.user,
      required this.isProfile});
  final RecordDetail record;
  final UserDetail user;
  final bool isProfile;

  @override
  State<RecordDetailView> createState() => _RecordDetailViewState();
}

class _RecordDetailViewState extends State<RecordDetailView> {
  final PageController _imageController = PageController();

  String _adresString = "";
  int _selectedPic = 0;

  @override
  void initState() {
    super.initState();

    _getAddressFromLatLng(
        widget.record.location!.latitude, widget.record.location!.longitude);
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _adresString =
            'Adres : ${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.record.images!.first,
            child: Stack(
              children: [
                Container(
                  height: context.dynamicHeight(30),
                  child: PageView(
                    controller: _imageController,
                    onPageChanged: (value) {
                      setState(() {
                        _selectedPic = value;
                      });
                    },
                    children: widget.record.images!
                        .map((e) => Image.network(
                              e,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: Row(
                    children: [
                      Spacer(),
                      ...widget.record.images!
                          .map((e) => widget.record.images!.indexOf(e) ==
                                  _selectedPic
                              ? Padding(
                                  padding: context.paddingLowOnly(right: true),
                                  child: Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                            color: context
                                                .colorScheme.onSecondary),
                                        color: context.colorScheme.primary),
                                  ),
                                )
                              : Padding(
                                  padding: context.paddingLowOnly(right: true),
                                  child: Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                            color: context
                                                .colorScheme.onSecondary),
                                        color:
                                            context.colorScheme.onBackground),
                                  ),
                                ))
                          .toList(),
                      Spacer(),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
                padding: context.paddingMediumOnly(right: true, left: true),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: context.paddingMediumOnly(top: true),
                        child: Text(
                          widget.record.title ?? "",
                          style: context.textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: context.paddingNormalOnly(top: true),
                        child: Text(
                          widget.record.description ?? "",
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                      Padding(
                        padding:
                            context.paddingNormalOnly(top: true, bottom: true),
                        child: Text(
                          "Fiyat : ${widget.record.price} ₺",
                          maxLines: 2,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: context.themeData.cardColor,
                            borderRadius: context.radiusLow),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: context.themeData.cardColor,
                                      borderRadius: context.radiusLow),
                                  child: FlutterMap(
                                    options: MapOptions(
                                        center: LatLng(
                                            widget.record.location!.latitude,
                                            widget.record.location!.longitude),
                                        zoom: 12,
                                        slideOnBoundaries: false,
                                        interactiveFlags: InteractiveFlag.none),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.location_on,
                                    color: context.colorScheme.primary,
                                    size: 42,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: context.paddingLowAll,
                              child: Text(_adresString),
                            ),
                          ],
                        ),
                      ),
                      widget.isProfile
                          ? SizedBox.shrink()
                          : Padding(
                              padding: context.paddingMediumAll,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: context.dynamicWidth(5),
                                    backgroundImage: NetworkImage(
                                        widget.user.photoURL ?? ""),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    widget.user.name ?? "",
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                      widget.isProfile
                          ? SizedBox.shrink()
                          : Padding(
                              padding: context.paddingHighOnly(bottom: true),
                              child: MyFilledButton(
                                  onTap: (() {
                                    launchUrl(Uri.parse(
                                        'tel:${widget.user.phoneNumber}'));
                                  }),
                                  label: "İletişime Geç"),
                            )
                    ],
                  ),
                )),
          )
        ],
      )),
    );
  }
}
