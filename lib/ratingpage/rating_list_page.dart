// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nukang_fe/ratingpage/rating_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class RatingList extends StatefulWidget {
  const RatingList(
      {Key? key, required this.transactionId, required this.merchantId})
      : super(key: key);
  final String transactionId;
  final String merchantId;

  @override
  State<RatingList> createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  late Future<List<RatingModel>> _ratingList;

  @override
  void initState() {
    _ratingList = RatingService.getInstance()
        .getRating(widget.transactionId, widget.merchantId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.nearlyWhite,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top * 1.5,
            ),
            const Text(
              "Ulasan",
              style: AppTheme.title,
            ),
            FutureBuilder<List<RatingModel>>(
              future: _ratingList,
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Belum ada penilaian."),
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children:
                        snapshot.data!.map((e) => getRatingItem(e)).toList(),
                  );
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
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
