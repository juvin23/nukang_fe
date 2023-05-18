import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/authentication/login_page.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/helper/widget/custom_text_form_field.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/authentication/register/customer_register_page.dart';
import 'package:nukang_fe/authentication/register/merchant_register_page.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/appuser/app_user_service.dart';

class RegistrationMain extends StatefulWidget {
  RegistrationMain({super.key, required this.role});
  String role;

  @override
  State<RegistrationMain> createState() => _RegistrationMain();
}

class _RegistrationMain extends State<RegistrationMain> {
  final _formKey = GlobalKey<FormState>();
  final AppUserService appUserService = AppUserService.getInstance();
  final Map<String, TextEditingController> formController = {
    'username': TextEditingController(),
    'password': TextEditingController(),
    'role': TextEditingController()
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
      child: Scaffold(
        body: Container(
          color: AppTheme.nearlyWhite,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                Image.asset(
                  "assets/logos/nukang_logo.png",
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
                    isObscureText: false,
                    controller: formController['username'],
                    variant: TextFormFieldVariant.OutlineBlack200,
                    fontStyle: TextFormFieldFontStyle.PoppinsRegular16,
                    hintText: "email",
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tidak boleh kosong.';
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) return "email tidak valid";
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
                    controller: formController['password'],
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppTheme.nearlyBlue,
                        foregroundColor: AppTheme.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          try {
                            saveForm();
                          } catch (e) {
                            Helper.toast(e.toString(), 250,
                                MotionToastPosition.top, 300);
                          }
                        }
                      },
                      child: const Text('Daftar'),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom * 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveForm() async {
    formController['role']!.text = widget.role;
    try {
      await appUserService.register(formController.data());
      if (AppUser.token == null) throw "Terjadi kesalahan silahkan coba lagi";
      Helper.pushAndReplace(
        widget.role == "customer"
            ? CustomerRegistration(
                customerId: "",
                appUserId: AppUser.userId!,
                token: AppUser.token!,
              )
            : MerchantRegistration(
                merchantId: "",
                appUserId: AppUser.userId!,
                token: AppUser.token!,
              ),
      );
    } catch (er) {
      Helper.toast(er.toString(), 500, MotionToastPosition.top,
              MediaQuery.of(context).size.width * 0.9)
          .show(context);
    }
  }
}
