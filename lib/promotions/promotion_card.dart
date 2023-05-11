// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:developer';

import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/promotions/promotion_detail.dart';
import 'package:nukang_fe/promotions/promotion_model.dart';

class PromotionCard extends StatefulWidget {
  const PromotionCard({Key? key}) : super(key: key);

  @override
  State<PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {
  late Future<List<Promotion>> _imageList;
  String baseUrl = 'Https://${Environment.apiUrl}/api/v1/ads/get-ads';

  @override
  void initState() {
    _imageList = getData();
    super.initState();
  }

  Future<List<Promotion>> getData() async {
    Uri uri = Uri.https(Environment.apiUrl, '/api/v1/ads/get-ads');
    await HttpHelper.get(uri).then((value) {
      if (value.statusCode == 200) {
        Iterable it = jsonDecode(value.body);
        return it.map(
          (e) => Promotion.fromJson(
            jsonDecode(e),
          ),
        );
      }
    });
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Promotion promotion = Promotion();
    promotion.id = '0';
    promotion.name = 'Testing Data';
    promotion.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";
    promotion.startDate = DateTime.parse("2023-05-10");
    promotion.endDate = DateTime.parse("2023-05-10");

    return FutureBuilder(
      future: _imageList,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return GFCarousel(
            autoPlay: true,
            height: 150,
            items: List.generate(
              3,
              (index) => getBanner(promotion),
            ),
          );
        } else {
          if (snapshot.data!.isNotEmpty) {
            return GFCarousel(
              autoPlay: true,
              height: 150,
              items: snapshot.data!.map((e) => getBanner(e)).toList(),
            );
          }
          return GFCarousel(
            autoPlay: true,
            height: 150,
            items: List.generate(
              3,
              (index) => getBanner(promotion),
            ),
          );
        }
      },
    );
  }

  Widget getBanner(Promotion promotion) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: GestureDetector(
          onTap: () => Helper.navigateToRoute(PromotionDetails(
            promotion: promotion,
          )),
          child: Image.network(
            '$baseUrl/${promotion.id}',
            fit: BoxFit.fitHeight,
            width: 900,
          ),
        ),
      ),
    );
  }
}
