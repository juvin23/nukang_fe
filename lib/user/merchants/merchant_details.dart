// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/core.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/ratingpage/rating_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/transaction/date_request.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MerchantDetailsPage extends StatefulWidget {
  const MerchantDetailsPage({Key? key, required this.merchantModel})
      : super(key: key);
  final MerchantModel merchantModel;

  @override
  State<MerchantDetailsPage> createState() => _MerchantDetailsPageState();
}

class _MerchantDetailsPageState extends State<MerchantDetailsPage> {
  bool isViewRating = false;
  Future<List<RatingModel>>? ratings;

  @override
  Widget build(BuildContext context) {
    MerchantModel merchantModel = widget.merchantModel;
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.5,
        centerTitle: true,
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        title: Text(
          "Mitra",
          style: AppTheme.headline.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(
                image: NetworkImage(
                  ImageService.getProfileImage(merchantModel.merchantId),
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 16,
              ),
              AnimatedContainer(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(43),
                    border: const Border(),
                  ),
                  duration: const Duration(milliseconds: 50),
                  height: isViewRating
                      ? MediaQuery.of(context).size.height * 0.3
                      : MediaQuery.of(context).size.height * 0.08,
                  width: isViewRating
                      ? MediaQuery.of(context).size.width * 0.8
                      : 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (merchantModel.getRatingCount() <= 0) return;
                              setState(() {
                                isViewRating = !isViewRating;
                                ratings = RatingService.getInstance().getRating(
                                    "", widget.merchantModel.merchantId!);
                              });
                            },
                            child: getRatingSummary(widget.merchantModel)),
                        if (isViewRating)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: getRating(),
                          )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 16,
              ),
              Text(
                merchantModel.merchantName ?? "",
                style: AppTheme.display1,
              ),
              Container(
                height: 500,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  merchantModel.description!,
                  style: AppTheme.body2,
                ),
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.08,
          5,
          MediaQuery.of(context).size.width * 0.08,
          35,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (AppUser.role != Role.merchant)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.nearlyBlue,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ButtonUtility.moveToPage(
                      DateRequest(
                        transaction: null,
                        merchantId: merchantModel.merchantId!,
                      ),
                      context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Pesan Sekarang",
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
            Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(130, 77, 213, 43),
                      shape: const CircleBorder()),
                  onPressed: () {
                    var url =
                        "https://wa.me/62${merchantModel.number!.startsWith("0") ? merchantModel.number!.substring(1) : merchantModel.number}/?text=${Uri.parse(merchantModel.merchantName!)}";
                    try {
                      launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } catch (e) {
                      Helper.toast("unable to launch whatsapp", 250,
                          MotionToastPosition.top, 250);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(
                      Icons.whatsapp_rounded,
                      size: 40,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRating() {
    return FutureBuilder(
        future: ratings,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else if (snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.map((e) => getRatingItem(e)).toList(),
              ),
            );
          }
          return Container();
        });
  }

  getRatingSummary(MerchantModel merchant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logos/star.png",
          width: 30,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${merchant.getRating()} (${merchant.getRatingCount()})",
          style: AppTheme.caption.copyWith(fontSize: 20),
        )
      ],
    );
  }

  Widget getRatingItem(RatingModel rating) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      padding: const EdgeInsets.all(10),
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.lighterGrey),
          color: AppTheme.nearlyWhite),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(
                "assets/logos/star.png",
                height: 30,
              ),
              Text(
                rating.rating.toString(),
                style: AppTheme.caption.copyWith(fontSize: 12),
              )
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: Text(
              rating.review!,
              style: AppTheme.body2.copyWith(
                fontSize: 13,
              ),
              overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
    );
  }
}
