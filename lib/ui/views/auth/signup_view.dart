import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/enums/app_images_enum.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/inputs/password_input.dart';
import 'package:provider/provider.dart';

import '../../../core/database/firestore.dart';
import '../../../core/models/user_detail.dart';
import '../../widgets/inputs/email_input.dart';

class SignUPView extends StatefulWidget {
  const SignUPView({super.key});

  @override
  State<SignUPView> createState() => _SignUPViewState();
}

class _SignUPViewState extends State<SignUPView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: context.paddingHighAll,
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    "Kayıt Ol",
                    style: context.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: context.paddingHighOnly(top: true),
                    child: EmailInput(
                      controller: _emailController,
                    ),
                  ),
                  Padding(
                    padding: context.paddingHighOnly(top: true, bottom: true),
                    child: PasswordInput(
                      controller: _passwordController,
                    ),
                  ),
                  MyFilledButton(
                      isLoading: isLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          changeIsLoading();
                          User? user;

                          try {
                            user = await AuthManager().signUPWithEmail(
                              _emailController.text,
                              _passwordController.text,
                            );
                          } on FirebaseException catch (e) {
                            changeIsLoading();
                            if (e.code == 'weak-password') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Daha güçlü bir şifre giriniz.",
                                      style: context
                                          .themeData.textTheme.bodyLarge?.copyWith(color: AppColors.fieryRose),
                                    ),
                                    actions: [
                                      MyFilledButton(
                                          onTap: (() =>
                                              NavigationService().back()),
                                          label: "Kapat")
                                    ],
                                  );
                                },
                              );
                            } else if (e.code == 'email-already-in-use') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Bu Email ile oluşturulmuş bir kullanıcı mevcut. Giriş yapmak ister misiniz ?",
                                      style: context
                                          .themeData.textTheme.bodyLarge?.copyWith(color: AppColors.fieryRose),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MyFilledButton(
                                              onTap: (() => NavigationService()
                                                  .clearAllTo(
                                                      routeName:
                                                          Routes.signin)),
                                              label: "Giriş Yap"),
                                          Padding(
                                            padding: context.paddingNormalOnly(
                                                left: true),
                                            child: MyFilledButton(
                                                onTap: (() =>
                                                    NavigationService().back()),
                                                label: "Kapat"),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          }

                          if (user != null) {
                            UserDetail newUserDetail = UserDetail();
                            newUserDetail.uid = user.uid;
                            newUserDetail.name = "Unknown";
                            newUserDetail.phoneNumber = "000000000000";

                            newUserDetail.photoURL =
                                AppImages.defaultUserNet.path;
                            await FirestoreManager()
                                .createNewUserDoc(newUserDetail);
                            await context.read<AuthProvider>().updateUser();
                            changeIsLoading();
                            NavigationService().to(
                              routeName: Routes.createNewUser,
                            );
                          }
                        }
                      },
                      label: "Devam"),
                  Padding(
                    padding: context.paddingMediumOnly(top: true),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: context.paddingLowOnly(right: true),
                          child: Text(
                            "Hesabınız var mı?",
                            style: context.primarytTextTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() => NavigationService()
                              .clearAllTo(routeName: Routes.signin)),
                          child: Text(
                            "Giriş Yap",
                            style: context.themeData.textTheme.bodyMedium!
                                .copyWith(color: AppColors.fieryRose,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              )),
        ),
      ),
    );
  }
}
