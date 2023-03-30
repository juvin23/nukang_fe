// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nukang_fe/shared/category_model.dart';
import 'package:nukang_fe/shared/category_service.dart';
import 'package:nukang_fe/user/merchants/merchant_details.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/model/merchant_params.dart';
import 'package:nukang_fe/user/merchants/popular_list.dart';
import 'package:nukang_fe/promotions/promotion_card.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';

enum Options { search, upload, copy, exit }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CategoryModel? currentCategory;

  List<MerchantModel>? _merchantSearchResult;
  bool searchList = false;

  var searchValue = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchValue.addListener(listMerchant);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            searchList = false;
          });
        },
        child: Container(
          color: AppTheme.notWhite,
          child: Scaffold(
            backgroundColor: AppTheme.white,
            body: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top),
                getAppBarUI(),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          getSearchBarUI(),
                          Stack(
                            children: [
                              getPromotionsUI(),
                              if (searchList) getItemList(),
                            ],
                          ),
                          getCategoryUI(),
                          Flexible(
                            child: getMerchantList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    getPromotionsUI();
    getCategoryUI();
    getAppBarUI();
    return Future.delayed(Duration.zero);
  }

  Widget getCategoryUI() {
    return FutureBuilder<List<CategoryModel>>(
      future: getCategoryList(), // function where you call your api
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            currentCategory != null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
              border: Border.all(
                width: 1.0,
                color: AppTheme.grey,
              ),
            ),
          );
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 11.2, vertical: 12.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 18, right: 16, top: 16),
                      child: Text(
                        'Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: AppTheme.darkerText,
                        ),
                      ),
                    ),
                  ],
                ));
          } else {
            return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 16, top: 16),
                      child: Text(
                        'Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: AppTheme.darkerText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(snapshot.data!.length,
                            (index) => getButtonUI(snapshot.data?[index])),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // CategoryListView(
                    //   callBack: () {
                    //     // moveTo();
                    //   },
                    // ),
                  ],
                ));
          }
        }
      },
    );
  }

  Widget getPromotionsUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: PromotionCard(),
    );
  }

  Widget getMerchantList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: PopularList(
          callBack: () {
            moveTo();
          },
          params: MerchantParams(),
        ),
      ),
    );
  }

  void moveTo() {
    // Navigator.push<dynamic>(
    //   context,
    //   MaterialPageRoute<dynamic>(
    //     builder: (BuildContext context) => CourseInfoScreen(),
    //   ),
    // );
  }

  Widget getButtonUI(CategoryModel? category) {
    String txt = category!.name!;
    String img = 'assets/logos/category_logo/${category.name!}.png';
    img = img.replaceAll(' ', "_");
    currentCategory ??= category;
    return SizedBox(
      height: 70,
      width: 100,
      child: InkWell(
        onTap: () {
          setState(() {
            currentCategory = category;
            getMerchantList();
          });
        },
        child: Column(children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: category.id == currentCategory!.id
                ? AppTheme.darkerBlue
                : AppTheme.nearlyBlue,
            child: Image.asset(
              img.toLowerCase(),
              fit: BoxFit.fill,
              color: AppTheme.white,
            ),
          ),
          Text(
            txt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.27,
              color: category.id == currentCategory!.id
                  ? AppTheme.grey
                  : AppTheme.nearlyBlue,
            ),
          ),
        ]),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18, right: 2),
        child: searchField());
  }

  getItemList() {
    if (_merchantSearchResult == null) {
      return Container(
        color: AppTheme.white,
        height: 80,
        width: double.infinity,
        child: const Center(
          child: Text("No Data on List"),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: AppTheme.white,
      child: SizedBox(
        width: double.infinity,
        height: _merchantSearchResult!.length * 60,
        child: Column(
          children: List<Widget>.generate(
            _merchantSearchResult!.length,
            (int index) {
              // animationController?.forward();
              return getListItem(_merchantSearchResult![index]);
            },
          ),
        ),
      ),
    );
  }

  getListItem(MerchantModel merchant) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MerchantDetailsPage(
                  merchantModel: merchant,
                )),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
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
                  child: Image.asset(
                    "assets/merchants/merchant1.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(merchant.merhcantName!),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchField() {
    return Container(
      width: double.infinity,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.circular(13)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: searchValue,
                    style: const TextStyle(
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.nearlyBlue,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Cari tukang',
                      border: InputBorder.none,
                      helperStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: HexColor('#B9BABC'),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: HexColor('#B9BABC'),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        searchList = true;
                      });
                    },
                    onEditingComplete: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  listMerchant() async {
    MerchantService merchantservice = MerchantService.getInstance();
    // if (searchValue.text.trim() != '') {
    List<MerchantModel> res =
        await merchantservice.getMerchantsByName(searchValue.text);

    setState(() {
      _merchantSearchResult = res;
    });
    // }
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'Cari tukang untuk apa hari ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.27,
                    color: AppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            color: AppTheme.nearlyWhite,
            child: GestureDetector(
                child: Image.asset('assets/user/userImage.png')),
          )
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  Future<List<CategoryModel>> getCategoryList() {
    CategoryService service = CategoryService.getInstance();
    return service.getAll();
  }
}
