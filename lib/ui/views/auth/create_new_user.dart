import 'dart:io';

import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:ikinci_el/core/database/firebase_storage.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/enums/app_images_enum.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/helpers/image_picker.dart';
import 'package:ikinci_el/core/models/user_detail.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/inputs/normal_input.dart';
import 'package:phonenumbers/phonenumbers.dart';
import 'package:provider/provider.dart';

class CreateNewUserView extends StatefulWidget {
  const CreateNewUserView({
    super.key,
  });

  @override
  State<CreateNewUserView> createState() => _CreateNewUserViewState();
}

class _CreateNewUserViewState extends State<CreateNewUserView> {
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final PhoneNumberEditingController _phoneController =
      PhoneNumberEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void pickFile() async {
    _image = await ImagePickerManager().pickImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await context.read<AuthProvider>().user?.delete();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: context.themeData.iconTheme,
          title: Text(
            "Create Profile",
            style: context.textTheme.headline6,
          ),
        ),
        body: SingleChildScrollView(
          padding: context.paddingHighAll,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.dynamicHeight(1),
                ),
                const Text("Profile Photo"),
                SizedBox(
                  height: context.dynamicHeight(2),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: context.dynamicWidth(15),
                      backgroundImage: _image == null
                          ? AssetImage(AppImages.defaultUserAssets.path)
                          : FileImage(
                              _image!,
                            ) as ImageProvider,
                    ),
                    TextButton.icon(
                      onPressed: pickFile,
                      icon: const Icon(Icons.add),
                      label: const Text("Select from gallery"),
                    )
                  ],
                ),
                Padding(
                  padding: context.paddingHighOnly(top: true),
                  child:
                      NormalInput(controller: _nameController, label: "İsim"),
                ),
                Padding(
                  padding: context.paddingHighOnly(top: true),
                  child: PhoneNumberField(
                    controller: _phoneController,
                    prefixBuilder: buildPhoneNumberPrefix,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: context.themeData.cardColor,
                        border: OutlineInputBorder(
                            borderRadius: context.radiusLow,
                            borderSide: BorderSide.none),
                        labelText: "Telefon Numarası",
                        labelStyle: context
                            .themeData.accentTextTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                ),
                Padding(
                  padding: context.paddingHighOnly(top: true),
                  child: FilledButton(
                      isLoading: isLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_phoneController.value != null) {
                            if (_phoneController.value!.isValid) {
                              changeIsLoading();
                              UserDetail? userDetail =
                                  context.read<AuthProvider>().userDetail;
                              userDetail?.uid =
                                  context.read<AuthProvider>().user?.uid;
                              userDetail?.name = _nameController.text;
                              userDetail?.phoneNumber =
                                  _phoneController.value?.formattedNumber;

                              String path = _image == null
                                  ? AppImages.defaultUserNet.path
                                  : await StorageManager().saveImage(
                                      _image!, userDetail?.uid ?? "");

                              userDetail?.photoURL = path;
                              await FirestoreManager()
                                  .updateUserDoc(userDetail!);
                              await context.read<AuthProvider>().updateUser();
                              changeIsLoading();
                              NavigationService()
                                  .clearAllTo(routeName: Routes.home);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Hatalı numara girdiniz !!",
                                      style: context
                                          .themeData.accentTextTheme.bodyLarge,
                                    ),
                                    actions: [
                                      FilledButton(
                                          onTap: (() =>
                                              NavigationService().back()),
                                          label: "Kapat")
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                    "Lütfen telefon numarası giriniz !!",
                                    style: context
                                        .themeData.accentTextTheme.bodyLarge,
                                  ),
                                  actions: [
                                    FilledButton(
                                        onTap: (() =>
                                            NavigationService().back()),
                                        label: "Kapat")
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      label: "Hesap oluştur"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? buildPhoneNumberPrefix(BuildContext context, Country? country) {
    return country != null
        ? Padding(
            padding: context.paddingLowOnly(right: true, left: true),
            child: Flag.fromString(country.code,
                width: context.dynamicWidth(4),
                height: context.dynamicWidth(1),
                fit: BoxFit.contain),
          )
        : null;
  }
}
