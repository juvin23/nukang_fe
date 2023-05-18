// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nukang_fe/authentication/login_page.dart';
import 'package:nukang_fe/faq/faq_page.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/ratingpage/rating_list_page.dart';
import 'package:nukang_fe/authentication/register/customer_register_page.dart';
import 'package:nukang_fe/authentication/register/merchant_register_page.dart';
import 'package:nukang_fe/shared/category_model.dart';
import 'package:nukang_fe/shared/category_service.dart';
import 'package:nukang_fe/transaction/transaction_service.dart';
import 'package:nukang_fe/transaction/work_list.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/merchants/merchant_details.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/model/merchant_params.dart';
import 'package:nukang_fe/user/merchants/popular_list.dart';
import 'package:nukang_fe/promotions/promotion_card.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Options { search, upload, copy, exit }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoryModel? currentCategory;
  CategoryService categoryService = CategoryService.getInstance();
  MerchantService merchantService = MerchantService.getInstance();

  List<MerchantModel>? _merchantSearchResult;
  bool searchList = false;
  bool dropdownList = false;
  var searchValue = TextEditingController();

  int notifCount = 0;

  late Future<List<CategoryModel>> _categories;

  @override
  void initState() {
    super.initState();
    searchValue.addListener(listMerchant);
    checkNotif();
    _categories = getCategories();
  }

  checkNotif() {
    TransactionService.getInstance().getNotificationCount().then((value) {
      setState(() {
        notifCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    return GestureDetector(
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
              SizedBox(height: MediaQuery.of(context).padding.top * 1.5),
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
                        if (AppUser.role == Role.customer) getCategoryUI(),
                        Flexible(
                          child: AppUser.role == Role.customer
                              ? getMerchantList()
                              : RatingList(
                                  merchantId: AppUser.userId!,
                                  transactionId: "",
                                ),
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
    );
  }

  Widget getCategoryUI() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categories, // function where you call your api
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
                color: Color.fromARGB(68, 58, 81, 96),
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
                  children: const <Widget>[],
                ));
          } else {
            return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                  ],
                ));
          }
        }
      },
    );
  }

  Widget getPromotionsUI() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: PromotionCard(),
    );
  }

  Widget getMerchantList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: PopularList(
        params: MerchantParams.of("category", currentCategory?.id ?? ""),
      ),
    );
  }

  Widget getButtonUI(CategoryModel? category) {
    String txt = category!.name;
    String img = 'assets/logos/category_logo/${category.name}.png';
    img = img.replaceAll(' ', "_");

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
      );
    }
    if (_merchantSearchResult!.isEmpty) {
      return Container(
        color: AppTheme.white,
        height: 80,
        width: double.infinity,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: AppTheme.white,
      child: SizedBox(
        width: double.infinity,
        height: _merchantSearchResult!.length * 100,
        child: Column(
          children: List<Widget>.generate(
            _merchantSearchResult!.length,
            (int index) {
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
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  ImageService.getProfileImage(merchant.merchantId),
                  height: 55,
                  width: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant.merchantName!,
                      style: AppTheme.body1,
                    ),
                    Text(merchant.merchantProvince!.provinceName!)
                  ],
                ),
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
    // if (searchValue.text.trim() != '') {
    List<MerchantModel> res =
        await merchantService.getMerchantsByName(searchValue.text);

    setState(() {
      _merchantSearchResult =
          res.where((element) => element.merchantId != AppUser.userId).toList();
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
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  transitionDuration: const Duration(milliseconds: 100),
                  barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                  barrierColor: Colors.black.withOpacity(0.5),
                  pageBuilder: (context, _, __) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            color: Color.fromARGB(255, 184, 198, 205),
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 210, 220, 224),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide())),
                                  child: ListTile(
                                      title: const Text(
                                        'Profil Saya',
                                        style: AppTheme.buttonTextDarkM,
                                      ),
                                      onTap: () {
                                        Helper.pushAndReplace(
                                          AppUser.role == Role.customer
                                              ? CustomerRegistration(
                                                  customerId:
                                                      AppUser.userId ?? "",
                                                  appUserId: "",
                                                  token: "",
                                                )
                                              : MerchantRegistration(
                                                  merchantId:
                                                      AppUser.userId ?? "",
                                                  appUserId: "",
                                                  token: "",
                                                ),
                                        );
                                      }),
                                ),
                                Badge(
                                  position:
                                      BadgePosition.topEnd(end: 5, top: 10),
                                  showBadge: (notifCount > 0),
                                  child: (AppUser.role == Role.customer)
                                      ? Container(
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: ListTile(
                                              title: const Text(
                                                'Daftar Pengerjaan',
                                                style: AppTheme.buttonTextDarkM,
                                              ),
                                              onTap: () {
                                                TransactionService.getInstance()
                                                    .clearNotification()
                                                    .then(
                                                  (value) {
                                                    checkNotif();
                                                  },
                                                );
                                                Helper.pushAndReplace(
                                                  const WorkList(),
                                                );
                                              }),
                                        )
                                      : Container(
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: ListTile(
                                              title: const Text(
                                                'Daftar Pekerjaan',
                                                style: AppTheme.buttonTextDarkM,
                                              ),
                                              onTap: () {
                                                TransactionService.getInstance()
                                                    .clearNotification()
                                                    .then((value) {
                                                  checkNotif();
                                                });
                                                Helper.pushAndReplace(
                                                  const WorkList(),
                                                );
                                              }),
                                        ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide())),
                                  child: ListTile(
                                    title: const Text(
                                      'Bantuan',
                                      style: AppTheme.buttonTextDarkM,
                                    ),
                                    onTap: () {
                                      Helper.pushAndReplace(const FaqPage());
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide())),
                                  child: ListTile(
                                      title: const Text(
                                        'Keluar ',
                                        style: AppTheme.buttonTextDarkM,
                                      ),
                                      trailing:
                                          const Icon(Icons.logout_outlined),
                                      onTap: () async {
                                        AppUser.role = null;
                                        AppUser.token = null;
                                        AppUser.userId = null;
                                        AppUser.username = null;
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString("nukang_user", "");
                                        Helper.clearStackPush(
                                            const LoginPage());
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ).drive(Tween<Offset>(
                        begin: Offset(0, -1.0),
                        end: Offset.zero,
                      )),
                      child: child,
                    );
                  },
                );
              },
              child: CircleAvatar(
                  radius: 70,
                  backgroundColor: AppTheme.white,
                  child: Badge(
                    position: BadgePosition.topEnd(top: 5, end: 5),
                    showBadge: (notifCount > 0),
                    badgeContent: Text(
                      notifCount.toString(),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: CachedNetworkImage(
                          imageUrl:
                              ImageService.getProfileImage(AppUser.userId),
                          placeholder: (context, url) =>
                              Image.asset("assets/user/userImage.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/user/userImage.png'),
                        )),
                  )),
            ),
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

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categori = await categoryService.getAll();
    setState(() {
      currentCategory = categori[0];
    });
    return categori;
  }
}
