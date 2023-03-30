import 'package:flutter/cupertino.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nukang_fe/environment.dart';

class PromotionCard extends StatelessWidget {
  PromotionCard({super.key});
  List<String> imageList = [
    Environment.apiUrl + "/api/v1/promosi/get-promosi",
  ];

  @override
  Widget build(BuildContext context) {
    return GFCarousel(
      autoPlay: true,
      height: 150,
      items: imageList.map(
        (url) {
          url = 'http://$url';
          return Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.fitHeight,
                width: 900,
              ),
            ),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(25),
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: NetworkImage(url),
            //   ),
            // ),
          );
        },
      ).toList(),
    );
  }
}
