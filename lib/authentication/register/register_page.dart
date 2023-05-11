import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nukang_fe/authentication/login_page.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/authentication/register/customer_register_page.dart';
import 'package:nukang_fe/authentication/register/merchant_register_page.dart';
import 'package:nukang_fe/authentication/register/register_main_page.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _isCustomer = true;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppTheme.nearlyWhite,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top * 1.5 * 1.5,
            ),
            Image.asset(
              "assets/logos/nukang_logo.png",
              width: 200,
            ),
            Expanded(child: Container()),
            const Text(
              "Daftar sebagai apa?",
              style: AppTheme.display1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  getMerchantCustomerDropDown(),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    _isCustomer ? customerDesc() : merchantDesc(),
                    textAlign: TextAlign.justify,
                    style: AppTheme.caption.copyWith(),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationMain(
                        role: _isCustomer ? "customer" : "merchant"),
                  ),
                );
              },
              child: Text(
                "selanjutnya",
                style: AppTheme.body1.copyWith(
                    color: AppTheme.nearlyBlueText,
                    decoration:
                        TextDecoration.combine([TextDecoration.underline])),
              ),
            ),
            Expanded(child: Container()),
            const Text("Sudah punya akun?"),
            GestureDetector(
              child: const Text(
                "masuk",
                style: AppTheme.body1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ));
  }

  String merchantDesc() {
    return '''Menyediakan layanan jasa untuk kegiatan-kegiatan yang berhubungan dengan rumah.\nSeperti jasa Service AC, pengecatan rumah, servis sofa, renovasi kamar mandi dan lain sebagainya.''';
  }

  String customerDesc() {
    return '''Mencari penyedia jasa untuk mengerjakan pekerjaan yang berhubungan dengan rumah.\nSeperti jasa Service AC, pengecatan rumah, servis sofa, renovasi kamar mandi dan lain sebagainya.''';
  }

  getMerchantCustomerDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: _isCustomer ? AppTheme.nearlyBlue : AppTheme.white,
            foregroundColor:
                !_isCustomer ? AppTheme.nearlyBlue : AppTheme.white,
            side: const BorderSide(
              color: AppTheme.nearlyBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              if (!_isCustomer) _isCustomer = !_isCustomer;
            });
          },
          child: const Text("Pengguna"),
        ),
        const SizedBox(
          width: 20,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor:
                !_isCustomer ? AppTheme.nearlyBlue : AppTheme.white,
            foregroundColor: _isCustomer ? AppTheme.nearlyBlue : AppTheme.white,
            side: const BorderSide(
              color: AppTheme.nearlyBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              if (_isCustomer) _isCustomer = !_isCustomer;
            });
          },
          child: const Text(" Mitra  "),
        ),
      ],
    );
  }
}
