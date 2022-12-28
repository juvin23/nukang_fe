import 'package:flutter/material.dart';
import 'package:nukang_fe/themes/app_theme.dart';

import 'model/merchant_model.dart';

class MerchantDetailsPage extends StatelessWidget {
  const MerchantDetailsPage({super.key, required this.model});
  final MerchantModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_rounded),
            ),
          ),
          Column(
            children: [
              Image.asset("assets/${model.imagePath ?? ""}"),
              Text(
                model.merhcantName ?? "",
                style: const TextStyle(color: AppTheme.darkText, fontSize: 30),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.nearlyBlue,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Whatsapp ${model.merhcantName ?? ""} now!"),
                      const Icon(Icons.whatsapp_rounded)
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
