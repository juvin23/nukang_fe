import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/promotions/promotion_model.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';

class PromotionDetails extends StatelessWidget {
  PromotionDetails({
    super.key,
    required this.promotion,
  });
  final Promotion promotion;
  final String baseUrl = 'Https://${Environment.apiUrl}/api/v1/ads/get-ads';

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("dd MMM yyyy");
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.5,
        centerTitle: true,
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        title: Text(
          "Iklan",
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
                  '$baseUrl/${promotion.id}',
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              Text(
                promotion.name ?? "",
                style: AppTheme.display1,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'periode : ${formatter.format(promotion.startDate!)} - ${formatter.format(promotion.endDate!)}',
                  textAlign: TextAlign.left,
                  style: AppTheme.body2.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightText),
                ),
              ),
              Container(
                height: 500,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 10),
                child: Text(
                  promotion.desc!,
                  style: AppTheme.caption,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
