import 'package:flutter/material.dart';
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
  MerchantParams params = MerchantParams();

  @override
  void initState() {
    super.initState();
    params = widget.params;
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
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xa08192ac),
                    blurRadius: 11,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  merchantService.getMerchantProfileImage(merchant.merchantId),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
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
                merchant.merchantProvince?.provinceName ?? "unknown",
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
    await merchantService.getMerchants(params).then(
          (value) => merchantList = value,
        );

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
