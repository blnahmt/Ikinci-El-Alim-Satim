import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/database/firebase_storage.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/enums/category_enum.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/helpers/image_picker.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/buttons/go_back_button.dart';
import 'package:ikinci_el/ui/widgets/buttons/simple_button.dart';
import 'package:ikinci_el/ui/widgets/inputs/normal_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../widgets/inputs/price_input.dart';

class AddNewRecordView extends StatefulWidget {
  const AddNewRecordView({super.key});

  @override
  State<AddNewRecordView> createState() => _AddNewRecordViewState();
}

class _AddNewRecordViewState extends State<AddNewRecordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<File?> images = [null, null, null, null];

  Categories _categoryValue = Categories.araba;
  final MapController _mapController = MapController();
  LatLng _pos = LatLng(41.2060, 28.9648);
  String _adresString = "Seçili Değil";

  bool _isLoading = false;
  changeIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    changeIsLoading();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position tempPos = await Geolocator.getCurrentPosition();

    await _getAddressFromLatLng(tempPos.latitude, tempPos.longitude);
    setState((() {
      _pos = LatLng(tempPos.latitude, tempPos.longitude);
      _mapController.move(_pos, _mapController.zoom);
    }));
    changeIsLoading();
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
      appBar: AppBar(
        leading: GoBackButton(),
        iconTheme: context.themeData.iconTheme,
        title: Text("İlan Yayınla"),
      ),
      body: SingleChildScrollView(
        padding: context.paddingNormalAll,
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Ürün Bilgisi"),
            const SizedBox(height: 16),
            NormalInput(controller: _titleController, label: "Ürün Başlığı"),
            const SizedBox(height: 8),
            NormalInput(
              controller: _descriptionController,
              label: "Ürün Bilgisi",
              line: 4,
            ),
            const SizedBox(height: 8),
            const Text("Resimler"),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildImageADD(context, 0),
                SizedBox(width: 8),
                buildImageADD(context, 1),
                SizedBox(width: 8),
                buildImageADD(context, 2),
                SizedBox(width: 8),
                buildImageADD(context, 3),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Kategori"),
            const SizedBox(height: 4),
            buildKategori(context),
            const SizedBox(height: 8),
            const Text("Konum Seç"),
            const SizedBox(height: 4),
            buildKonum(context),
            const SizedBox(height: 16),
            PriceInput(controller: _priceController, label: "Fiyat"),
            const SizedBox(height: 8),
            const SizedBox(height: 32),
            MyFilledButton(
                isLoading: _isLoading,
                onTap: () async {
                  changeIsLoading();
                  if (_formKey.currentState!.validate()) {
                    int imageCount = 0;
                    for (var element in images) {
                      if (element != null) {
                        imageCount++;
                      }
                    }
                    if (imageCount != 0) {
                      String newIid =
                          "ilan-${context.read<AuthProvider>().user?.uid}-${DateTime.now().toString().trim()}";

                      List<String> imagesLinks = [];

                      for (var element in images) {
                        if (element != null) {
                          String temp = await StorageManager().savePostImage(
                            element,
                            newIid,
                            images.indexOf(element).toString(),
                          );
                          imagesLinks.add(temp);
                        }
                      }

                      RecordDetail temp = RecordDetail()
                        ..title = _titleController.text
                        ..description = _descriptionController.text
                        ..category = _categoryValue
                        ..images = imagesLinks
                        ..uid = context.read<AuthProvider>().user?.uid
                        ..iid = newIid
                        ..location = GeoPoint(_pos.latitude, _pos.longitude)
                        ..price = int.parse(_priceController.text)
                        ..dateAdded = Timestamp.now();

                      await FirestoreManager().createNewRecord(temp);
                      NavigationService().back();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              "En az bir adet resim seçiniz !!",
                              style:
                                  context.themeData.textTheme.bodyLarge?.copyWith(color: AppColors.fieryRose),
                            ),
                            actions: [
                              MyFilledButton(
                                  onTap: (() => NavigationService().back()),
                                  label: "Kapat")
                            ],
                          );
                        },
                      );
                    }
                  }
                  changeIsLoading();
                },
                label: "İlanı Yayınla")
          ]),
        ),
      ),
    );
  }

  Expanded buildImageADD(BuildContext context, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: images[index] == null
            ? () async {
                File? temp = await ImagePickerManager().pickImage();
                for (var element in images) {
                  if (element == null) {
                    images[images.indexOf(element)] = temp;
                    break;
                  }
                }
                setState(() {});
              }
            : () {
                images[index] = null;
                for (var element in images) {
                  if (element == null) {
                    for (var i = images.indexOf(element) + 1;
                        i < images.length;
                        i++) {
                      if (images[i] != null) {
                        File temp = images[i]!;
                        images[i] = null;
                        images[images.indexOf(element)] = temp;
                      }
                    }
                  }
                }
                setState(() {});
              },
        child: Container(
          height: context.dynamicHeight(12),
          decoration: BoxDecoration(
            color: context.themeData.cardColor,
            border: Border.all(color: context.colorScheme.primary),
            borderRadius: context.radiusLow,
            image: images[index] == null
                ? null
                : DecorationImage(
                    image: FileImage(
                      images[index]!,
                    ),
                    fit: BoxFit.cover),
          ),
          child: images[index] == null
              ? Center(
                  child: Icon(Icons.add, color: context.colorScheme.primary))
              : Center(
                  child: Icon(Icons.delete_forever_rounded,
                      color: context.colorScheme.primary)),
        ),
      ),
    );
  }

  Container buildKategori(BuildContext context) {
    return Container(
      padding: context.paddingNormalHorizontal,
      decoration: BoxDecoration(
          color: context.themeData.cardColor, borderRadius: context.radiusLow),
      child: DropdownButton<String>(
          borderRadius: context.radiusLow,
          dropdownColor: context.themeData.cardColor,
          underline: const SizedBox.shrink(),
          value: _categoryValue.name,
          items: Categories.values
              .map((e) => DropdownMenuItem<String>(
                  value: e.name,
                  child: Row(
                    children: [
                      e.icon,
                      SizedBox(
                        width: 8,
                      ),
                      Text(e.label)
                    ],
                  )))
              .toList(),
          onChanged: ((value) {
            setState(() {
              _categoryValue = Categories.values.byName(value!);
            });
          })),
    );
  }

  Container buildKonum(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.themeData.cardColor, borderRadius: context.radiusLow),
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
                  mapController: _mapController,
                  options: MapOptions(
                    center: _pos,
                    zoom: 12,
                    onPointerUp: (event, point) {
                      setState(() {
                        _pos = point;
                      });
                      _getAddressFromLatLng(_pos.latitude, _pos.longitude);
                    },
                    onPositionChanged: (position, hasGesture) {},
                  ),
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
            padding: context.paddingLowOnly(top: true, right: true, left: true),
            child: Text(_adresString),
          ),
          Padding(
            padding: context.paddingLowAll,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                child: SimpleButton(
                  isLoading: _isLoading,
                  label: "Mevcut Konumu Seç",
                  onTap: () async {
                    await _determinePosition();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
