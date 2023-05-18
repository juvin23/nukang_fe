// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/helper/widget/custom_text_form_field.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/ratingpage/rating_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/transaction/transaction_model.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

class RatingInputPage extends StatefulWidget {
  const RatingInputPage({Key? key, required this.transaction})
      : super(key: key);
  final Transaction transaction;
  @override
  State<RatingInputPage> createState() => _RatingInputPageState();
}

class _RatingInputPageState extends State<RatingInputPage> {
  final Map<String, TextEditingController> formController = {
    'merchantId': TextEditingController(),
    'transactionId': TextEditingController(),
    'rating': TextEditingController(),
    'review': TextEditingController(),
  };
  Transaction transaction = Transaction();
  int? rating;
  String? comment;
  List<RatingModel>? ratings;
  double _initRating = 0;
  bool isRated = false;

  DateTime? isClick;
  @override
  void initState() {
    transaction = widget.transaction;
    getRating();
    super.initState();
  }

  getRating() async {
    await RatingService.getInstance()
        .getRating(transaction.transactionId!, "")
        .then((value) {
      setState(() {
        ratings = value;
        if (value.isNotEmpty) {
          _initRating = ratings![0].rating!;
          isRated = false;
          formController['review']!.text = ratings![0].review!;
        } else {
          isRated = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarOpacity: 0.5,
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        title: Text(
          "Ulasan",
          style: AppTheme.headline.copyWith(),
        ),
        actions: const [],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                isRated && AppUser.role == Role.merchant
                    ? Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(207, 255, 0, 0),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Belum diulas oleh pengguna jasa",
                          style: AppTheme.caption.copyWith(
                              fontSize: 20, color: AppTheme.lighterGrey),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: MediaQuery.of(context).padding.top * 1.5,
                ),
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CachedNetworkImage(
                        imageUrl: ImageService.getProfileImage(
                            transaction.merchantId),
                        width: 150,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Tanggal Transaksi Anda :",
                                style: AppTheme.body1.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w200),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                DateFormat('EEE, dd-MMM-yyyy')
                                    .format(transaction.lastUpdate!),
                                style: AppTheme.body1.copyWith(
                                    fontSize: 15, fontWeight: FontWeight.w200),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: Text(
                                  transaction.description ??
                                      "ASDA SODKASO DKA ASODK AO KAO KPkPASOD ASDA SODKASO DKA ASODKKAO KPkPASOD ASDA SODKASO DKA ASODKK AOSDKAO KPkPASOD ASDA SODKASO DKA ASODK AO K AOSDKAO KPkPASODK ASDA SODKASO DKA ASODK AO K AOSDKAO KPkPASODK ASDA SODKASO DKA ASODK AO K AOSDKAO KPkPASODK K",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 4.0,
                        ),
                        RatingBar.builder(
                          ignoreGestures: ((ratings == null)
                                  ? false
                                  : ratings!.isNotEmpty) ||
                              AppUser.role == Role.merchant,
                          initialRating: _initRating,
                          allowHalfRating: false,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.blueAccent,
                          ),
                          itemSize: 50,
                          onRatingUpdate: (rating) {
                            formController['rating']!.text =
                                rating.toInt().toString();
                          },
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "tidak boleh kosong";
                    }
                    return null;
                  },
                  controller: formController['review'],
                  hintText: "Berikan komentar",
                  textInputAction: TextInputAction.done,
                  maxLines: 6,
                  isDisabled: _initRating > 0 || AppUser.role == Role.merchant,
                ),
                Container(
                  width: width ?? double.maxFinite,
                  margin: getMargin(
                    left: 14,
                    top: 28,
                    right: 10,
                    bottom: 5,
                  ),
                ),
                if (_initRating == 0 &&
                    AppUser.userId!.trim() != transaction.merchantId!.trim())
                  Padding(
                    padding: getPadding(
                      bottom: 2,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppTheme.nearlyBlue,
                        foregroundColor: AppTheme.darkText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        () => FocusManager.instance.primaryFocus?.unfocus();

                        if (isNotRedundentClick(DateTime.now())) {
                          try {
                            saveForm();
                          } catch (e) {
                            Helper.toast(e.toString(), 250,
                                    MotionToastPosition.top, 300)
                                .show(context);
                          }
                        }
                      },
                      child: isClick == null
                          ? const Text(
                              'ulas',
                              style: AppTheme.buttonTextM,
                            )
                          : const CircularProgressIndicator(
                              color: AppTheme.nearlyWhite,
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

  saveForm() async {
    if (formController['review']!.text == '' ||
        formController['rating']!.text == '') {
      setState(() {
        isClick = null;
      });
      Helper.toast("Ulasan dan penilaian tidak boleh kosong", 200,
              MotionToastPosition.top, 300)
          .show(context);
    }
    formController['merchantId']!.text = transaction.merchantId!;
    formController['transactionId']!.text = transaction.transactionId!;
    RatingService.getInstance().giveRating(formController.data()).then((value) {
      var toast = _displaySuccessMotionToast("Ulasan diterima");
      if (value.statusCode == 200) {
        toast.show(context);
        Future.delayed(const Duration(seconds: 2)).then((value) {
          toast.dismiss();
          Helper.clearStackPush(const HomePage());
        });
      } else {
        throw "Terjadi kesalahan";
      }
    });
  }

  bool isNotRedundentClick(DateTime currentTime) {
    if (isClick == null) {
      setState(() {
        isClick = currentTime;
      });
      return true;
    }
    if (currentTime.difference(isClick!).inSeconds < 10) {
      return false;
    }
    setState(() {
      isClick = null;
    });
    return true;
  }

  bool isRedundent(DateTime dateTime, DateTime? isClickApprove) {
    if (isClickApprove == null) return false;
    if (dateTime.difference(isClickApprove).inSeconds < 10) {
      return true;
    }

    return false;
  }

  MotionToast _displaySuccessMotionToast(txt) {
    MotionToast toast = MotionToast.success(
      title: const Text(
        'Success',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        txt,
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.rtl,
      position: MotionToastPosition.top,
      animationType: AnimationType.fromRight,
      animationDuration: const Duration(milliseconds: 200),
      dismissable: true,
    );
    return toast;
  }
}
