import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nukang_fe/merchants/merchant_details.dart';
import 'package:nukang_fe/merchants/model/merchant_model.dart';
import 'package:nukang_fe/merchants/services/merchant_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class PopularList extends StatefulWidget {
  PopularList({super.key, this.callBack});
  final VoidCallback? callBack;

  @override
  State<PopularList> createState() => _PopularListState();
}

class _PopularListState extends State<PopularList>
    with TickerProviderStateMixin {
  final MerchantService merchantService = MerchantService();
  List<MerchantModel> merchantList = [];
  AnimationController? animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        future: getMerchants(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (merchantList.isEmpty) {
            return Wrap(
              alignment: WrapAlignment.center,
              children: const [
                Text("No Services Available For You To Access"),
              ],
            );
          } else {
            return GridView(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 3),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.8,
              ),
              children: List<Widget>.generate(
                merchantList.length,
                (int index) {
                  animationController?.forward();
                  return getListItem(merchantList[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }

  getListItem(MerchantModel merchant) {
    return InkWell(
      onTap: () => moveToPage(merchant),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.notWhite,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/${merchant.imagePath}',
              height: 150,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: getItemDetail(merchant),
            )
          ],
        ),
      ),
    );
  }

  getItemDetail(MerchantModel merchant) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchant.merhcantName ?? "no name.",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                merchant.merchantProvince?.name ?? "unknown",
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightText),
              ),
              Text(
                merchant.description ??
                    "Disini harusnya deskripsi dan gabisa overflow",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              )
            ],
          ),
        ),
        SizedBox(
            width: 20,
            child: Column(
              children: [
                Image.asset(
                  "assets/logos/star.png",
                  width: 14,
                  height: 14,
                ),
                Text(
                  merchant.getRating(),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ))
      ],
    );
  }

  Future<bool> getMerchants() async {
    await merchantService.getMerchants().then(
          (value) => merchantList = value,
        );

    return true;
  }

  moveToPage(MerchantModel merchant) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MerchantDetailsPage(
                model: merchant,
              )),
    );
  }
}
