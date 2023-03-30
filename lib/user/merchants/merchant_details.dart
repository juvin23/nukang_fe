import 'package:flutter/material.dart';
import 'package:nukang_fe/request/working_date/date_request/date_request.dart';
import 'package:nukang_fe/shared/button_utility.dart';
import 'package:nukang_fe/themes/app_theme.dart';

import 'model/merchant_model.dart';

class MerchantDetailsPage extends StatelessWidget {
  const MerchantDetailsPage({super.key, required this.merchantModel});
  final MerchantModel merchantModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Image.asset(
                'assets/merchants/merchant1.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                merchantModel.merhcantName ?? "",
                style: const TextStyle(color: AppTheme.darkText, fontSize: 30),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.nearlyBlue,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        ButtonUtility.moveToPage(
                            DateRequest(merchantModel: merchantModel), context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Order Now",
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(130, 77, 213, 43),
                            shape: const CircleBorder()),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.whatsapp_rounded,
                            size: 40,
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
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
        ]),
      ),
    );
  }
}
