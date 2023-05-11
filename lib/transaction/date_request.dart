// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/core.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/transaction/transaction_model.dart';
import 'package:nukang_fe/transaction/transaction_service.dart';
import 'package:nukang_fe/transaction/work_list.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/customer/customer_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';

class DateRequest extends StatefulWidget {
  const DateRequest(
      {Key? key,
      required this.transaction,
      required this.merchantId,
      this.denied})
      : super(key: key);
  final Transaction? transaction;
  final String merchantId;
  final String? denied;

  @override
  State<DateRequest> createState() {
    return _DateRequestState();
  }
}

class _DateRequestState extends State<DateRequest> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'provinceCode': TextEditingController(),
    'cityCode': TextEditingController(),
    'address': TextEditingController(),
    'email': TextEditingController(),
    'denied': TextEditingController(),
    'phoneNum': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
    'description': TextEditingController(),
    'merchantId': TextEditingController(),
    'customerId': TextEditingController(),
    'deniedReason': TextEditingController(),
    'transactionId': TextEditingController()
  };
  DateTime? isClickApprove;
  DateTime? isClickCancel;
  DateTime? isClickRequest;
  List<String> provinces = [];
  DateFormat formatFullDate = DateFormat('EEE, dd-MMM-yyyy');
  DateFormat formatDate = DateFormat("yyyy-MM-dd");

  final CityService cityService = CityService.getInstance();
  final ProvinceService provinceService = ProvinceService.getInstance();
  final TransactionService transactionService =
      TransactionService.getInstance();

  String? _selectedProvince;
  String? _selectedCity;

  late Future<List<Province>> _provinces;
  late Future<List<City>> _cities;

  bool isApproval = false;
  bool isCancel = false;
  bool isDenied = false;

  String btnText = "Ajukan Tanggal Kerja";

  getUserData() {
    if (AppUser.role == Role.customer) {
      CustomerService.getInstance()
          .getCustomerById(AppUser.userId)
          .then((value) {
        setState(() {
          formController['name']!.text = value.name!;
          formController['address']!.text = value.address!;
          _selectedProvince = formController['provinceCode']!.text =
              value.province!.provinceCode!;
          _selectedCity =
              formController['cityCode']!.text = value.city!.cityCode!;
        });
      });
    }
  }

  @override
  void initState() {
    getData();
    if (widget.transaction == null) {
      isApproval = false;
      isCancel = false;
      getUserData();
    } else {
      isDenied = widget.transaction!.recordStatus == "X" ||
          widget.transaction!.recordStatus == "XX";
      isCancel = (widget.transaction!.customerId == AppUser.userId &&
              widget.transaction!.recordStatus == "1") ||
          widget.transaction!.recordStatus == "2";
      isApproval = (widget.transaction!.merchantId == AppUser.userId &&
              widget.transaction!.recordStatus == "1") ||
          isCancel ||
          isDenied;
    }
    if (isApproval || isCancel || isDenied) {
      getDataApproval();
    }
    super.initState();
  }

  getData() async {
    setState(() {
      _provinces = getProvinces();
      _cities = getCities();
    });
    // print(_cities);
    // print(_provinces);
    // print("PROVINCESSSS");
  }

  getDataApproval() {
    Transaction trans = widget.transaction!;
    CustomerService.getInstance()
        .getCustomerById(trans.customerId!)
        .then((value) {
      setState(() {
        formController['name']!.text = value.name!;
        formController['customerId']!.text = trans.customerId!;
        formController['merchantId']!.text = trans.merchantId!;
        formController['transactionId']!.text = trans.transactionId!;
        formController['description']!.text = trans.description!;
        formController['startDate']!.text =
            (trans.startDate!).toString().substring(0, 10);
        formController['endDate']!.text =
            (trans.endDate!).toString().substring(0, 10);
        formController['address']!.text = trans.address!;
        formController['deniedReason']!.text = trans.deniedReason!;
        formController['provinceCode']!.text = trans.province!;
        _selectedProvince = trans.province!;
        formController['cityCode']!.text = trans.city!;
        _selectedCity = trans.city!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarOpacity: 0.5,
              centerTitle: true,
              backgroundColor: AppTheme.nearlyWhite,
              foregroundColor: AppTheme.dark_grey,
              title: Image.asset(
                "assets/logos/nukang_logo.png",
                width: 150,
              ),
              actions: const [],
            ),
            backgroundColor: AppTheme.nearlyWhite,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top * 0.8,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: AppTheme.nearlyWhite,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(
                        imageUrl:
                            ImageService.getProfileImage(widget.merchantId),
                        placeholder: (context, url) =>
                            Image.asset("assets/user/userImage.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/user/userImage.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          if (isDenied)
                            getDenied(
                                "Alasan ditolak",
                                "Alasan ditolak",
                                widget.transaction!.deniedReason!,
                                6,
                                formController['deniedReason']!),
                          getTextField(
                              "nama", "nama", "", 1, formController['name']!),
                          getTextField("alamat", "alamat", "", 5,
                              formController['address']!),
                          getDropDownProvince(),
                          getDropDownCity(),
                          getDate(),
                          getTextField(
                              "Apa yang akan dilakukan tukang?",
                              "Deskripsi Pekerjaan",
                              "",
                              3,
                              formController['description']!),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: getButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getButton() {
    if (isDenied) return Container();
    if (isCancel) return getCancelButton();
    if (isApproval) return getApprovalButton();
    return getRequestButton();
  }

  getApprovalButton() {
    return Row(
      children: [
        Expanded(child: Container()),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(85, 45),
            backgroundColor: const Color.fromARGB(117, 220, 38, 38),
            foregroundColor: AppTheme.lightText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // <-- Radius
            ),
          ),
          onPressed: () {
            if (isRedundent(DateTime.now(), isClickCancel)) {
              return;
            } else {
              setState(() {
                isClickCancel = null;
              });
            }
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Alasan Menolak',
                            style: AppTheme.body2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: formController['denied'],
                          maxLines: 3,
                          minLines: 3,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              hintText: "belum melakukan konfirmasi",
                              labelText: "Alasan"),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(85, 45),
                            backgroundColor:
                                const Color.fromARGB(255, 245, 52, 52),
                            foregroundColor: AppTheme.buttonRed,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            if (isNotRedundentClick(DateTime.now(), "cancel")) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text(
                            "Tolak",
                            style: AppTheme.buttonTextM,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ).then((value) {
              if (value == true && formController['denied']!.text == "") {
                Helper.toast("alasan penolakan harus diisi", 250,
                        MotionToastPosition.top, 300)
                    .show(context);
                setState(() {
                  isClickCancel = null;
                });
              } else if (value == true) {
                transactionService
                    .reject(formController['denied']!.text,
                        widget.transaction!.transactionId!)
                    .then((value) async {
                  if (value.statusCode == 200) {
                    var toast =
                        _displaySuccessMotionToast("Pengajuan tanggal ditolak");
                    toast.show(context);
                    await Future.delayed(const Duration(seconds: 2))
                        .then((value) {
                      toast.dismiss();
                      Helper.navigateBack();
                    });
                  }
                });
              } else {
                setState(() {
                  isClickCancel = null;
                });
              }
            });
          },
          child: isClickCancel == null
              ? const Text("Tolak")
              : const CircularProgressIndicator(
                  color: AppTheme.nearlyWhite,
                ),
        ),
        const SizedBox(
          width: 30,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(100, 50),
            backgroundColor: AppTheme.nearlyBlue,
            foregroundColor: AppTheme.lighterGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // <-- Radius
            ),
          ),
          onPressed: () async {
            if (isRedundent(DateTime.now(), isClickApprove)) {
              return;
            } else {
              setState(() {
                isClickApprove = null;
              });
            }
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Terima Transaksi?',
                            style: AppTheme.body2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(85, 45),
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 52, 52),
                                foregroundColor: AppTheme.buttonRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                "batal",
                                style: AppTheme.buttonTextM,
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(85, 45),
                                backgroundColor: AppTheme.nearlyBlue,
                                foregroundColor: AppTheme.nearlyWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Terima",
                                style: AppTheme.buttonTextM,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ).then((value) {
              if (value == true) {
                if (isNotRedundentClick(DateTime.now(), "aprv")) {
                  try {
                    saveForm();
                  } catch (e) {
                    Helper.toast("terjadi kesalahan coba lagi.", 250,
                            MotionToastPosition.top, 300)
                        .show(context);
                  }
                }
              } else {
                setState(() {
                  isClickApprove = null;
                });
              }
            });
          },
          child: isClickApprove != null
              ? const CircularProgressIndicator(
                  color: AppTheme.nearlyWhite,
                )
              : const Text(
                  "Terima",
                  style: AppTheme.buttonTextM,
                ),
        ),
      ],
    );
  }

  getCancelButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(85, 45),
        backgroundColor: const Color.fromARGB(255, 245, 52, 52),
        foregroundColor: AppTheme.nearlyWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // <-- Radius
        ),
      ),
      onPressed: () {
        if (isRedundent(DateTime.now(), isClickCancel)) {
          return;
        } else {
          setState(() {
            isClickCancel = null;
          });
        }
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Alasan Dibatalkan',
                        style: AppTheme.body2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: formController['denied'],
                      maxLines: 3,
                      minLines: 3,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText:
                              "merchant tidak bisa hadir di waktu yang ditentukan.",
                          labelText: "Alasan"),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(85, 45),
                        backgroundColor: const Color.fromARGB(255, 245, 52, 52),
                        foregroundColor: AppTheme.buttonRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context, true);
                      },
                      child: isClickCancel == null
                          ? const Text(
                              "Batal",
                              style: AppTheme.buttonTextM,
                            )
                          : const CircularProgressIndicator(
                              color: AppTheme.nearlyWhite),
                    )
                  ],
                ),
              ),
            );
          },
        ).then((value) {
          if (value == true && formController['denied']!.text.trim() == "") {
            Helper.toast("alasan dibatalkan harus diisi", 250,
                    MotionToastPosition.top, 300)
                .show(context);
            setState(() {
              isClickCancel = null;
            });
          } else if (value != null && value) {
            transactionService
                .cancel(formController['denied']!.text,
                    widget.transaction!.transactionId!)
                .then((value) async {
              if (value.statusCode == 200) {
                var toast =
                    _displaySuccessMotionToast("Pengajuan tanggal dibatalkan");
                toast.show(context);
                await Future.delayed(const Duration(seconds: 2)).then((value) {
                  toast.dismiss();
                  Helper.navigateBack();
                });
              }
            });
          }
        });
      },
      child: isClickCancel == null
          ? const Text("Batal")
          : const CircularProgressIndicator(
              color: AppTheme.nearlyWhite,
            ),
    );
  }

  getRequestButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppTheme.nearlyBlue,
        foregroundColor: AppTheme.darkText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // <-- Radius
        ),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState!.validate()) {
          if (isRedundent(DateTime.now(), isClickApprove)) {
            return;
          } else {
            setState(() {
              isClickApprove = null;
            });
          }
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Ajukan?',
                          style: AppTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(85, 45),
                              backgroundColor:
                                  const Color.fromARGB(255, 245, 52, 52),
                              foregroundColor: AppTheme.buttonRed,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              "batal",
                              style: AppTheme.buttonTextM,
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(85, 45),
                              backgroundColor: AppTheme.nearlyBlue,
                              foregroundColor: AppTheme.nearlyWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              if (isNotRedundentClick(DateTime.now(), "aprv")) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: isClickApprove == null
                                ? const Text(
                                    "Ajukan",
                                    style: AppTheme.buttonTextM,
                                  )
                                : const CircularProgressIndicator(
                                    color: AppTheme.nearlyWhite),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ).then((value) {
            if (value) {
              try {
                saveForm();
              } catch (e) {
                Helper.toast(e.toString(), 250, MotionToastPosition.top, 300)
                    .show(context);
              }
            }
          });
        }
      },
      child: isClickApprove != null
          ? const CircularProgressIndicator(
              color: AppTheme.nearlyWhite,
            )
          : const Text(
              "Ajukan tanggal",
              style: AppTheme.buttonTextM,
            ),
    );
  }

  Future<List<Province>> getProvinces() async {
    return await provinceService.getProvinces();
  }

  getDropDownCity() {
    return FutureBuilder<List<City>>(
      future: _cities,
      builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
              margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Kota",
                  labelText: "Kota",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: const [],
                validator: (value) {
                  if (value == null || value == "") return "Tidak boleh kosong";
                  return null;
                },
                isExpanded: true,
                isDense: true,
                onChanged: null,
              ),
            );
          } else {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
              child: DropdownButtonFormField(
                value: _selectedCity,
                style: AppTheme.caption,
                decoration: InputDecoration(
                  hintText: "kota",
                  labelText: "Kota",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: List.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                          value: snapshot.data![index].cityCode!,
                          child:
                              Text(snapshot.data![index].cityName ?? "no Data"),
                        )),
                isExpanded: true,
                isDense: true,
                onChanged: isApproval
                    ? null
                    : (value) => {
                          setState(() {
                            _selectedCity = value.toString();
                            formController['cityCode']!.text =
                                _selectedCity ?? "";
                          })
                        },
              ),
            );
          }
        }
      },
    );
  }

  getDropDownProvince() {
    return FutureBuilder<List<Province>>(
      future: _provinces, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<Province>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
              margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Provinsi",
                  labelText: "Provinsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "NO_DATA",
                    child: Text("no Data"),
                  )
                ],
                isExpanded: true,
                isDense: true,
                onChanged: (value) => {},
              ),
            );
          } else {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
              child: DropdownButtonFormField(
                style: AppTheme.caption,
                value: _selectedProvince,
                decoration: InputDecoration(
                  hintText: "Provinsi",
                  labelText: "Provinsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: List.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                          value: snapshot.data![index].provinceCode,
                          child: Text(
                              snapshot.data?[index].provinceName ?? "no Data"),
                        )),
                onChanged: isApproval
                    ? null
                    : (value) {
                        setState(() {
                          _selectedProvince = value.toString();
                          formController['provinceCode']!.text =
                              _selectedProvince!;
                        });
                        _selectedCity = null;
                        _cities = getCities();
                      },
              ),
            );
          }
        }
      },
    );
  }

  Future<List<City>> getCities() async {
    return await cityService.getCities(_selectedProvince ?? "0");
  }

  getTextField(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
        // color: isApproval ? AppTheme.lighterGrey : AppTheme.nearlyWhite,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
        child: Theme(
          data: ThemeData(
            disabledColor: Colors.grey,
          ),
          child: TextFormField(
            style: isApproval ? AppTheme.captionDisabled : AppTheme.caption,
            controller: fieldControl,
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            minLines: 1,
            maxLines: maxLines,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong.';
              }
              return null;
            },
            readOnly: isApproval,
          ),
        ));
  }

  getDenied(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
        // color: isApproval ? AppTheme.lighterGrey : AppTheme.nearlyWhite,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(78, 233, 71, 71),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Theme(
          data: ThemeData(
            disabledColor: const Color.fromARGB(255, 241, 0, 0),
          ),
          child: TextFormField(
            style: isApproval ? AppTheme.captionDisabled : AppTheme.caption,
            controller: fieldControl,
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              fillColor: AppTheme.buttonRed,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            minLines: 1,
            maxLines: maxLines,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong.';
              }
              return null;
            },
            readOnly: isApproval,
          ),
        ));
  }

  getDate() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextFormField(
              controller: formController['startDate'],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong.';
                }
                return null;
              },
              style: isApproval ? AppTheme.captionDisabled : AppTheme.caption,
              decoration: InputDecoration(
                hintText: "Pilih Tanggal",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: "Tanggal Mulai",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              readOnly: true,
              onTap: () async {
                if (!isApproval) {
                  final DateTimeRange? dateTimeRange =
                      await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(3000),
                  );
                  if (dateTimeRange != null) {
                    setState(() {
                      formController['startDate']!.text =
                          (dateTimeRange.start).toString().substring(0, 10);

                      formController['endDate']!.text =
                          (dateTimeRange.end).toString().substring(0, 10);
                    });
                  }
                }
              },
            ),
          ),
        ),
        const Text(
          "-",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextFormField(
              controller: formController['endDate'],
              style: isApproval ? AppTheme.captionDisabled : AppTheme.caption,
              decoration: InputDecoration(
                hintText: 'Tanggal Akhir',
                errorStyle: TextStyle(
                  color: Theme.of(context).errorColor, // or any other color
                ),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: 'Tanggal Akhir',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong.';
                }
                return null;
              },
              readOnly: true,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }

  saveForm() async {
    if (_formKey.currentState!.validate()) {
      formController['customerId']!.text = AppUser.userId!;
      formController['merchantId']!.text = widget.merchantId;

      if (isApproval) {
        await transactionService
            .approve(widget.transaction!.transactionId)
            .then((value) async {
          isClickApprove = null;
          var toast = _displaySuccessMotionToast("Pengajuan tanggal diterima");
          if (value.statusCode == 200) {
            toast.show(context);
            await Future.delayed(const Duration(seconds: 2)).then((value) {
              toast.dismiss();
              Helper.navigateBack();
            });
          } else {
            throw "Terjadi kesalahan";
          }
        });
      } else {
        await transactionService.request(formController.data()).then((value) {
          var toast = _displaySuccessMotionToast("Pengajuan tanggal berhasil");
          toast.show(context);
          if (value.statusCode == 200) {
            toast.show(context);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              toast.dismiss();
              Helper.navigateBack();
            });
          } else {
            throw "Pengajuan tidak dapat diproses";
          }
        });
      }
    }
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

  bool isNotRedundentClick(DateTime currentTime, String button) {
    switch (button) {
      case "cancel":
        if (isClickCancel == null) {
          setState(() {
            isClickCancel = currentTime;
          });
          return true;
        }
        if (currentTime.difference(isClickCancel!).inSeconds < 10) {
          return false;
        }
        setState(() {
          isClickCancel = null;
        });
        return true;

      case "aprv":
        if (isClickApprove == null) {
          setState(() {
            isClickApprove = currentTime;
          });
          return true;
        }
        if (currentTime.difference(isClickApprove!).inSeconds < 10) {
          return false;
        }
        setState(() {
          isClickApprove = null;
        });
        return true;
      case "req":
        if (isClickRequest == null) {
          setState(() {
            isClickRequest = currentTime;
          });
          return true;
        }
        if (currentTime.difference(isClickRequest!).inSeconds < 10) {
          return false;
        }
        setState(() {
          isClickRequest = null;
        });
        return true;
      default:
    }

    return true;
  }

  bool isRedundent(DateTime dateTime, DateTime? isClickApprove) {
    if (isClickApprove == null) return false;
    if (dateTime.difference(isClickApprove).inSeconds < 10) {
      return true;
    }

    return false;
  }
}
