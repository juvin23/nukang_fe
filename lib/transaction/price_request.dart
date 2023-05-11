// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/core.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/transaction/transaction_model.dart';
import 'package:nukang_fe/transaction/transaction_service.dart';
import 'package:nukang_fe/transaction/work_list.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/customer/customer_service.dart';

class PriceRequest extends StatefulWidget {
  const PriceRequest({Key? key, required this.transaction}) : super(key: key);
  final Transaction transaction;

  @override
  State<PriceRequest> createState() => _PriceRequestState();
}

class _PriceRequestState extends State<PriceRequest> {
  final _pRequestForm = GlobalKey<FormState>();
  Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'provinceCode': TextEditingController(),
    'cityCode': TextEditingController(),
    'address': TextEditingController(),
    'email': TextEditingController(),
    'denied': TextEditingController(),
    'phoneNum': TextEditingController(),
    'startdate': TextEditingController(),
    'enddate': TextEditingController(),
    'description': TextEditingController(),
    'merchantId': TextEditingController(),
    'customerId': TextEditingController(),
    'transactionId': TextEditingController(),
    'amount': TextEditingController()
  };

  List<String> provinces = [];
  DateFormat formatFullDate = DateFormat('EEE, dd-MMM-yyyy');
  DateFormat formatDate = DateFormat("yyyy-MM-dd");

  final CityService cityService = CityService.getInstance();
  final ProvinceService provinceService = ProvinceService.getInstance();
  final TransactionService transactionService =
      TransactionService.getInstance();

  String? _selectedProvince;
  String? _selectedCity;

  bool isApproval = false;
  bool isCancel = false;
  bool isView = false;
  late Future<List<Province>> _provinces;
  late Future<List<City>> _cities;
  String tittle = "Pengajuan Biaya";

  DateTime? isClickCancel;

  DateTime? isClickApprove;

  DateTime? isClickRequest;

  bool isDenied = false;

  @override
  void initState() {
    getData();
    getUserData();
    if (widget.transaction.recordStatus == "2") {
      isApproval = false;
      isCancel = false;
    } else {
      isDenied = widget.transaction.recordStatus == "X" ||
          widget.transaction.recordStatus == "XX";
      isCancel = (widget.transaction.customerId == AppUser.userId &&
              widget.transaction.recordStatus == "3") ||
          widget.transaction.recordStatus == "4";
      isApproval = (widget.transaction.merchantId == AppUser.userId &&
              widget.transaction.recordStatus == "3") ||
          isCancel ||
          isDenied;
    }
    if (isApproval || isCancel || isDenied) {
      getDataApproval();
    }
    super.initState();
  }

  getData() async {
    _provinces = getProvinces();
    _cities = getCities();
  }

  getUserData() {
    var trans = widget.transaction;
    CustomerService.getInstance()
        .getCustomerById(trans.customerId)
        .then((value) {
      setState(() {
        formController['name']!.text = value.name!;
        formController['address']!.text = value.address!;
        _selectedProvince = formController['provinceCode']!.text =
            value.province!.provinceCode!;
        _selectedCity =
            formController['cityCode']!.text = value.city!.cityCode!;
        formController['name']!.text = value.name!;
        formController['customerId']!.text = trans.customerId!;
        formController['merchantId']!.text = trans.merchantId!;
        formController['transactionId']!.text = trans.transactionId!;
        formController['description']!.text = trans.description!;
        formController['startdate']!.text =
            (trans.startDate!).toString().substring(0, 10);
        formController['enddate']!.text =
            (trans.endDate!).toString().substring(0, 10);
        formController['address']!.text = trans.address!;
        formController['provinceCode']!.text = trans.province!;
        _selectedProvince = trans.province!;
        formController['cityCode']!.text = trans.city!;
        _selectedCity = trans.city!;
      });
    });
  }

  getDataApproval() {
    Transaction trans = widget.transaction;

    if (isApproval || isCancel) {
      setState(() {
        formController['amount']!.text =
            CurrencyInputFormatter.format(trans.amount!.toStringAsFixed(0));
      });
    }
    if (isDenied) {
      setState(() {
        formController['denied']!.text = trans.deniedReason!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.notWhite,
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
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: AppTheme.nearlyWhite,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(
                        imageUrl: ImageService.getProfileImage(
                            widget.transaction.merchantId),
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
                      key: _pRequestForm,
                      child: Column(
                        children: <Widget>[
                          if (isDenied)
                            getDenied(
                                "Alasan ditolak",
                                "Alasan ditolak",
                                widget.transaction.deniedReason!,
                                6,
                                formController['denied']!),
                          getDisabledTextField(
                              "nama", "nama", "", 1, formController['name']!),
                          getDisabledTextField("alamat", "alamat", "", 5,
                              formController['address']!),
                          getDropDownProvince(),
                          getDropDownCity(),
                          getDate(),
                          getDisabledTextField(
                              "Apa yang akan dilakukan tukang?",
                              "Deskripsi Pekerjaan",
                              "",
                              3,
                              formController['description']!),
                          getTextField(
                            "Biaya yang disepakati",
                            "Biaya yang disepakati",
                            "",
                            1,
                            formController['amount']!,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: getButton(),
                          )
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
    if (!isApproval && !isCancel) return getRequestButton();
    if (widget.transaction.recordStatus == "4") return getDoneButton();
    if (isCancel) return getCancelButton();
    if (isApproval) return getApprovalButton();
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
                        widget.transaction.transactionId!)
                    .then((value) {
                  if (value.statusCode == 200) {
                    var toast =
                        _displaySuccessMotionToast("Pengajuan biaya ditolak");
                    toast.show(context);
                    Future.delayed(const Duration(seconds: 2)).then((value) {
                      toast.dismiss();

                      Navigator.pop(context, true);
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
                    widget.transaction.transactionId!)
                .then((value) {
              if (value.statusCode == 200) {
                Navigator.pop(context, true);
                var toast =
                    _displaySuccessMotionToast("Pengajuan biaya dibatalkan");
                toast.show(context);
                toast.dismiss();
                Helper.pushAndReplace(
                  const WorkList(),
                );
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

  getDoneButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(130, 45),
        backgroundColor: AppTheme.nearlyBlue,
        foregroundColor: AppTheme.nearlyWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // <-- Radius
        ),
      ),
      onPressed: () async {
        if (_pRequestForm.currentState!.validate()) {
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
                          'Selesaikan Pekerjaan?',
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
                              "Tidak",
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
                              child: FittedBox(
                                child: isClickApprove == null
                                    ? const Text(
                                        "Ya",
                                        style: AppTheme.buttonTextM,
                                      )
                                    : const CircularProgressIndicator(
                                        color: AppTheme.nearlyWhite),
                              ))
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
      child: isClickApprove == null
          ? const Text(
              "Pekerjaan Selesai",
              style: AppTheme.buttonTextM,
              textAlign: TextAlign.center,
            )
          : const CircularProgressIndicator(
              color: AppTheme.notWhite,
            ),
    );
  }

  getRequestButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppTheme.nearlyBlue,
        foregroundColor: AppTheme.darkText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (isRedundent(DateTime.now(), isClickApprove)) {
          return;
        } else {
          setState(() {
            isClickApprove = null;
          });
        }
        if (_pRequestForm.currentState!.validate()) {
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
      child: isClickApprove == null
          ? const Text(
              "Ajukan biaya",
              style: AppTheme.buttonTextM,
            )
          : const CircularProgressIndicator(
              color: AppTheme.nearlyWhite,
            ),
    );
  }

  Future<List<Province>> getProvinces() async {
    return await provinceService.getProvinces();
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

  getDropDownCity() {
    return FutureBuilder<List<City>>(
      future: _cities, // function where you call your api
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
                items: const [
                  DropdownMenuItem(
                    value: "NO_DATA",
                    child: Text("no Data"),
                  )
                ],
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
                            value: snapshot.data![index].cityCode,
                            child: Text(
                                snapshot.data![index].cityName ?? "no Data"),
                          )),
                  isExpanded: true,
                  isDense: true,
                  onChanged: null),
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
                            value: snapshot.data?[index].provinceCode,
                            child: Text(snapshot.data?[index].provinceName ??
                                "no Data"),
                          )),
                  onChanged: null),
            );
          }
        }
      },
    );
  }

  Future<List<City>> getCities() async {
    return await cityService.getCities(_selectedProvince);
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter()
          ],
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tidak boleh kosong.';
            }
            return null;
          },
          readOnly: isApproval,
        ),
      ),
    );
  }

  getDisabledTextField(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
      // color: isApproval ? AppTheme.lighterGrey : AppTheme.nearlyWhite,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      child: Theme(
        data: ThemeData(
          disabledColor: Colors.grey,
        ),
        child: TextFormField(
          style: AppTheme.captionDisabled,
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
          readOnly: true,
        ),
      ),
    );
  }

  getDate() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextFormField(
              controller: formController['startdate'],
              style: AppTheme.captionDisabled,
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
              onTap: () {},
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
              controller: formController['enddate'],
              validator: (value) {
                if (value == null || value == "") return "Tidak boleh kosong";
                return null;
              },
              style: AppTheme.captionDisabled,
              decoration: InputDecoration(
                hintText: 'Tanggal Akhir',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: 'Tanggal Akhir',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              readOnly: true,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }

  saveForm() async {
    formController['amount']!.text =
        formController['amount']!.text.replaceAll(",", "");
    if (isApproval) {
      transactionService
          .approvePrice(widget.transaction.transactionId)
          .then((value) {
        if (value.statusCode == 200) {
          if (value.statusCode == 200) {
            var txt;
            if (widget.transaction.recordStatus == "4") {
              txt = "Pengerjaan Selesai";
            } else {
              txt = "Pengajuan biaya diterima";
            }
            var toast = _displaySuccessMotionToast(txt);
            toast.show(context);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              toast.dismiss();
              Navigator.pop(context, true);
            });
          }
        } else {
          throw "";
        }
      });
    } else {
      transactionService
          .requestPrice(
              widget.transaction.transactionId,
              formController['amount']!.text,
              formController['startdate']!.text,
              formController['enddate']!.text)
          .then((value) {
        if (value.statusCode == 200) {
          var toast = _displaySuccessMotionToast("Biaya diajukan");
          if (value.statusCode == 200) {
            toast.show(context);
            Future.delayed(const Duration(seconds: 2)).then((value) {
              toast.dismiss();

              Navigator.pop(context, true);
            });
          }
        }
      });
    }
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

class CurrencyInputFormatter extends TextInputFormatter {
  static String format(String val) {
    double value = double.parse(val);
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(value);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.decimalPattern();

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
