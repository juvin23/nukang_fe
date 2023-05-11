import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/user/merchants/merchant_details.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/model/merchant_params.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class PopularList extends StatefulWidget {
  const PopularList({super.key, this.callBack, required this.params});
  final VoidCallback? callBack;
  final MerchantParams params;

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
    return FutureBuilder<bool>(
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
    );
  }

  getListItem(MerchantModel merchant) {
    return InkWell(
      onTap: () => moveToPage(merchant),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: ImageService.getProfileImage(merchant.merchantId),
                placeholder: (context, url) =>
                    Image.asset("assets/user/userImage.png"),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/user/userImage.png'),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: getItemDetail(merchant),
            )
          ],
        ),
      ),
    );
  }

  getItemDetail(MerchantModel merchant) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchant.merchantName ?? "no name.",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                merchant.merchantProvince?.provinceName ?? "unknown",
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightText),
              ),
              Text(
                merchant.description ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              )
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
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
        )
      ],
    );
  }

  Future<bool> getMerchants() async {
    await merchantService.getMerchants(widget.params).then((value) {
      merchantList = value;
    });

    return true;
  }

  moveToPage(MerchantModel merchant) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MerchantDetailsPage(
                merchantModel: merchant,
              )),
    );
  }
}
