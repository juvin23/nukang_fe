import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/helper/widget/custom_button.dart';
import 'package:nukang_fe/helper/widget/custom_text_form_field.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/authentication/register/merchant_register_page.dart';
import 'package:nukang_fe/authentication/register/register_page.dart';
import 'package:nukang_fe/themes/app_theme.dart';

// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/appuser/app_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  DateTime? lastClickLogin;

  @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? nukangToken = prefs.getString('nukang_user');
    if (nukangToken != null) {
      setState(() {
        try {
          isLoggedIn = true;
          List<String> user = nukangToken.split(",");
          AppUser.token = user[0];
          AppUser.userId = user[1];
          AppUser.role = user[2] == "c" ? Role.customer : Role.merchant;
        } catch (e) {
          prefs.setString("nukang_user", "");
        }
      });
      return;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nukang_user', "");
    setState(() {
      AppUser.token = '';
      isLoggedIn = false;
    });
    Helper.clearStackPush(const LoginPage());
  }

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nukangUser =
        "${AppUser.token!},${AppUser.userId!},${AppUser.role == Role.customer ? "c" : "m"}";
    prefs.setString("nukang_user", nukangUser);

    if (AppUser.token != null && AppUser.userId != null) {
      Helper.clearStackPush(const HomePage());
    } else {
      Helper.toast(
          "email atau kata sandi salah", 250, MotionToastPosition.top, 250);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppUser.token != "" && AppUser.token != null) {
      return const HomePage();
    }
    return Material(
      color: AppTheme.nearlyWhite,
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top * 1.5,
              ),
              Image.asset(
                'assets/logos/nukang_logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: getMargin(top: 40, bottom: 15),
                width: MediaQuery.of(context).size.width * 0.7,
                child: CustomTextFormField(
                  controller: emailController,
                  variant: TextFormFieldVariant.OutlineBlack200,
                  fontStyle: TextFormFieldFontStyle.PoppinsRegular16,
                  hintText: "email",
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tidak boleh kosong.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: getMargin(top: 5),
                width: MediaQuery.of(context).size.width * 0.7,
                child: CustomTextFormField(
                  controller: passwordController,
                  variant: TextFormFieldVariant.OutlineBlack200,
                  fontStyle: TextFormFieldFontStyle.PoppinsRegular16,
                  hintText: "kata sandi",
                  isObscureText: true,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tidak boleh kosong.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("tidak punya akun?"),
              GestureDetector(
                  child: Text(
                    "daftar",
                    style:
                        AppTheme.body1.copyWith(color: AppTheme.nearlyBlueText),
                  ),
                  onTap: () {
                    Helper.pushAndReplace(const RegisterPage());
                  }),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppTheme.nearlyBlue,
                      foregroundColor: AppTheme.darkText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // <-- Radius
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!isRedundentClick(DateTime.now())) {
                          try {
                            await AppUserService.getInstance().authenticate(
                              {
                                "username": emailController.text,
                                "password": passwordController.text
                              },
                            );
                            login();
                          } catch (er) {
                            Helper.toast(
                                    "Email/Kata sandi salah",
                                    500,
                                    MotionToastPosition.top,
                                    MediaQuery.of(context).size.width * 0.9)
                                .show(context);
                            setState(() {
                              lastClickLogin = null;
                            });
                          }
                        }
                      }
                    },
                    child: lastClickLogin == null
                        ? const Text("masuk", style: AppTheme.buttonTextM)
                        : const CircularProgressIndicator(
                            color: AppTheme.nearlyWhite,
                          ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  bool isRedundentClick(DateTime currentTime) {
    if (lastClickLogin == null) {
      setState(() {
        lastClickLogin = currentTime;
      });
      return false;
    }
    if (currentTime.difference(lastClickLogin!).inSeconds < 10) {
      return true;
    }
    setState(() {
      lastClickLogin = null;
    });
    return false;
  }
}
