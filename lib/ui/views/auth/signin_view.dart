import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/inputs/password_input.dart';

import '../../widgets/inputs/email_input.dart';

class SignINView extends StatefulWidget {
  const SignINView({super.key});

  @override
  State<SignINView> createState() => _SignINViewState();
}

class _SignINViewState extends State<SignINView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.paddingHighAll,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/icon.png",
                      width: context.dynamicWidth(40),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: context.paddingHighOnly(bottom: true),
                      child: Text(
                        "İkinci El",
                        style: context.primarytTextTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Text(
                    "Giriş Yap",
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
                          user = await AuthManager().signINWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "Email veya şifre hatalı !!",
                                  style: context
                                      .themeData.textTheme.bodyLarge?.copyWith(color: AppColors.fieryRose),
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
                        changeIsLoading();
                        if (user != null) {
                          NavigationService()
                              .clearAllTo(routeName: Routes.home);
                        }
                      }
                    },
                    label: "Giriş Yap",
                  ),
                  Padding(
                    padding: context.paddingMediumOnly(top: true),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            TextEditingController _emailResetController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: context.paddingMediumAll,
                                        child: Text(
                                            "Şifre yenileme linkinin emalie gönderilebilmesi için email giriniz."),
                                      ),
                                      EmailInput(
                                          controller: _emailResetController),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          if (_emailResetController
                                              .text.isEmpty) {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding:
                                                      context.paddingHighAll,
                                                  child: Text(
                                                      "Email alanı boş olamaz"),
                                                );
                                              },
                                            );
                                          } else {
                                            try {
                                              await AuthManager()
                                                  .requestPasswordReset(
                                                      _emailResetController
                                                          .text);
                                              await showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        context.paddingHighAll,
                                                    child: Text(
                                                        "Email adresinize şifrenizi yenileyebileceğiniz bir link gönderilmiştir."),
                                                  );
                                                },
                                              );
                                              NavigationService().back();
                                            } on FirebaseException catch (_) {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        context.paddingHighAll,
                                                    child: Text(
                                                        "Geçersiz veya kayıtlı olmayan Email adresi girdiniz "),
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        },
                                        child: Text("Gönder")),
                                    TextButton(
                                        onPressed: () {
                                          NavigationService().back();
                                        },
                                        child: Text("Kapat"))
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Şifremi unuttum?",
                            style: context.primarytTextTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() => NavigationService()
                              .clearAllTo(routeName: Routes.signup)),
                          child: Text(
                            "Kayıt Ol",
                            style: context.themeData.textTheme.bodyMedium!
                                .copyWith(color: AppColors.fieryRose,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
