import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/image_picker.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:nukang_fe/shared/city_service.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:nukang_fe/shared/province_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/customer/customer_service.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration(
      {super.key,
      required this.customerId,
      required this.appUserId,
      required this.token});
  final String customerId;
  final String appUserId;
  final String token;

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final _formKey = GlobalKey<FormState>();
  final CustomerService userService = CustomerService();
  final CityService cityService = CityService.getInstance();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'provinceCode': TextEditingController(),
    'cityCode': TextEditingController(),
    'birthdate': TextEditingController(),
    'email': TextEditingController(),
    'number': TextEditingController(),
    'customerId': TextEditingController()
  };

  String name = "";
  String address = "";
  DateTime? birthdate;
  var formatFullDate = DateFormat('EEE, dd-MMM-yyyy');
  var formatDate = DateFormat('yyyy-MM-dd');

  final ProvinceService provinceService = ProvinceService.getInstance();
  late Future<List<Province>> _provinces;
  Future<List<City>>? _cities;
  String? selectedProvince;
  bool isEdit = false;
  String? selectedCity;

  var isImageUploaded = false;

  ImageHelper imageHelper = ImageHelper.getInstance();

  Widget _image = Image(
    image: NetworkImage(ImageService.getProfileImage(AppUser.userId)),
  );

  DateTime? isClick;

  @override
  void initState() {
    getData();

    if (widget.customerId.trim() != "") {
      CustomerService.getInstance().getCustomerById(widget.customerId).then(
        (customer) {
          setState(() {
            isEdit = true;
            formController['name']!.text = customer.name!;
            formController['address']!.text = customer.address!;
            selectedProvince = formController['provinceCode']!.text =
                customer.province!.provinceCode!;

            selectedCity =
                formController['cityCode']!.text = customer.city!.cityCode!;
            formController['number']!.text = customer.number!;
            formController['birthdate']!.text =
                (customer.birthdate!).toString().substring(0, 10);
            birthdate = customer.birthdate!;
          });
        },
      );
    }

    setState(() {
      _image = Image(
        image: NetworkImage(ImageService.getProfileImage(AppUser.userId)),
      );
    });
    super.initState();
  }

  getData() {
    _cities = getCities();
    _provinces = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarOpacity: 0.5,
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        title: Image.asset(
          "assets/logos/nukang_logo.png",
          width: 150,
        ),
        actions: const [],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top * 1.5,
                  ),
                  if (!isEdit)
                    const Text("Data Pengguna", style: AppTheme.headline),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          imagePickerWidget(),
                          getTextField(
                              "nama", "nama", "", 1, formController['name']!),
                          getTextField("alamat", "alamat", "", 5,
                              formController['address']!),
                          getDropDownProvince(),
                          getDropDownCity(),
                          getDate(),
                          getNumberOnly("nomor telepon", "nomor telepon", "", 1,
                              formController['number']!),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppTheme.nearlyBlue,
                        foregroundColor: AppTheme.darkText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveForm();
                        }
                      },
                      child: isClick != null
                          ? const CircularProgressIndicator(
                              color: AppTheme.nearlyWhite,
                            )
                          : Text(isEdit ? "Ubah" : 'Daftar'),
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

  Widget imagePickerWidget() {
    return Stack(
      alignment: isImageUploaded ? Alignment.bottomCenter : Alignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: AppTheme.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: _image,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.cameraswitch_sharp,
            size: 40 - (isImageUploaded ? 15 : 0),
          ),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Ubah foto profil?',
                            style: AppTheme.body2,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                          onPressed: () async {
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            "Ya",
                            style: AppTheme.buttonTextM,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(85, 45),
                            backgroundColor: AppTheme.nearlyWhite,
                            foregroundColor: AppTheme.nearlyBlue,
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
                      ],
                    ),
                  ),
                );
              },
            ).then((value) async {
              if (value) {
                await imageHelper
                    .uploadImage(
                  ImageSource.gallery,
                  "userResources",
                )
                    .then((value) {
                  setState(() {
                    _image = Image(
                      image: NetworkImage(
                          '${ImageService.getProfileImage(widget.appUserId)}?rand=${Random().nextInt(100)}'),
                    );
                    isImageUploaded = true;
                  });
                });
              }
            });
          },
        ),
      ],
    );
  }

  getDate() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextFormField(
              controller: TextEditingController(
                text:
                    birthdate == null ? "" : formatFullDate.format(birthdate!),
              ),
              decoration: InputDecoration(
                hintText: "Tanggal Lahir",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: "Tanggal Lahir",
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
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  lastDate: DateTime.now(),
                  firstDate: DateTime.utc(1900, 01, 01),
                ).then((value) {
                  setState(() {
                    birthdate = value;
                  });
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Province>> getProvinces() async {
    return await provinceService.getProvinces();
  }

  Future<List<City>> getCities() async {
    return await cityService.getCities(selectedProvince ?? "");
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
                    child: Text("Tidak ada data!"),
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
                value: selectedProvince,
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
                    child: Text(
                        snapshot.data?[index].provinceName ?? "Belum Tersedia"),
                  ),
                ),
                isExpanded: true,
                isDense: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value!;
                    selectedCity = null;
                    formController['provinceCode']!.text = value;
                  });

                  _cities = getCities();
                },
              ),
            );
          }
        }
      },
    );
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
          if (snapshot.hasError ||
              snapshot.data == null ||
              selectedProvince == null) {
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
                validator: (value) {
                  if (value == null) {
                    return 'Tidak boleh kosong.';
                  }
                  return null;
                },
                items: const [],
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
                value: selectedCity,
                decoration: InputDecoration(
                  hintText: "Kota",
                  labelText: "Kota",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: List.generate(
                  snapshot.data!.length,
                  (index) => DropdownMenuItem(
                    value: snapshot.data![index].cityCode,
                    child: Text(snapshot.data![index].cityName ?? ""),
                  ),
                ),
                isExpanded: true,
                isDense: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong.';
                  }
                  return null;
                },
                onChanged: (value) => {
                  setState(() {
                    selectedCity = value!;
                    formController['cityCode']!.text = value;
                  })
                },
              ),
            );
          }
        }
      },
    );
  }

  getTextField(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      child: TextFormField(
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
      ),
    );
  }

  getNumberOnly(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12)
        ],
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
      ),
    );
  }

  getRonlyTextField(String hint, String label, String init, int maxLines,
      TextEditingController fieldControl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      child: TextFormField(
        enabled: false,
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
      ),
    );
  }

  saveForm() {
    if (!isRedundent(DateTime.now())) {
      print("isEdit" + isEdit.toString());
      try {
        isEdit ? update() : create();
      } catch (e) {
        Helper.toast(e.toString(), 250, MotionToastPosition.top, 350);
      }
    }
  }

  create() {
    formController['birthdate']?.text = birthdate.toString().substring(0, 10);
    formController['provinceCode']?.text = selectedProvince!;
    formController['customerId']!.text = AppUser.userId!;
    userService.create(formController.data()).then(
      (value) {
        if (value) {
          var toast = _displaySuccessMotionToast("Pendaftaran berhasil");
          toast.show(context);
          Future.delayed(const Duration(seconds: 2)).then((value) {
            toast.dismiss();
            Helper.clearStackPush(const HomePage());
          });
        } else {
          Helper.toast("Terjadi kesalahan coba lagi.", 300,
                  MotionToastPosition.top, 300)
              .show(context);
        }
      },
    );
  }

  update() {
    formController['birthdate']?.text = birthdate.toString().substring(0, 10);
    formController['provinceCode']?.text = selectedProvince!;
    formController['customerId']!.text = AppUser.userId!;
    userService.update(formController.data()).then(
      (value) {
        if (value) {
          var toast = _displaySuccessMotionToast("Ubah profil berhasil");
          toast.show(context);
          Future.delayed(const Duration(seconds: 2)).then((value) {
            toast.dismiss();
            Helper.clearStackPush(const HomePage());
          });
        } else {
          Helper.toast("Terjadi kesalahan coba lagi.", 300,
              MotionToastPosition.top, 300);
        }
      },
    );
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

  bool isRedundent(DateTime current) {
    if (isClick == null) {
      setState(() {
        isClick = current;
      });
      return false;
    }

    if (isClick!.difference(current).inSeconds < 10) {
      return true;
    }
    setState(() {
      isClick = null;
    });

    return false;
  }
}
