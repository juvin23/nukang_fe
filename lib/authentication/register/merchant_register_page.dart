import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nukang_fe/helper/image_picker.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/homepage.dart';
import 'package:nukang_fe/shared/category_model.dart';
import 'package:nukang_fe/shared/category_service.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:nukang_fe/shared/city_service.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:nukang_fe/shared/province_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';
import 'package:nukang_fe/helper/helper.dart';

class MerchantRegistration extends StatefulWidget {
  const MerchantRegistration({super.key, required this.merchantId});
  final String merchantId;

  @override
  State<MerchantRegistration> createState() => _MerchantRegistrationState();
}

class _MerchantRegistrationState extends State<MerchantRegistration> {
  final _formKey = GlobalKey<FormState>();
  final merchantService = MerchantService.getInstance();
  final cityService = CityService();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'provinceCode': TextEditingController(),
    'cityCode': TextEditingController(),
    'email': TextEditingController(),
    'description': TextEditingController(),
    'number': TextEditingController(),
    'merchantId': TextEditingController(text: AppUser.userId),
  };
  bool isChecked = false;
  DateTime? isclick;

  Widget _image = CachedNetworkImage(
    imageUrl: ImageService.getProfileImage(AppUser.userId),
    placeholder: (context, url) => Image.asset("assets/user/userImage.png"),
    errorWidget: (context, url, error) =>
        Image.asset('assets/user/userImage.png'),
  );

  final ProvinceService provinceService = ProvinceService.getInstance();

  String? selectedProvince;

  String? selectedCity;
  late Future<List<Province>> _provinces;
  late Future<List<City>> _cities;

  List<CategoryModel> _categories = [];

  List<CategoryModel> _selectedCategories = [];
  late Set<CategoryModel?> nullableSelectedCategories;

  final ImageHelper imageHelper = ImageHelper.getInstance();

  bool? isImageUploaded;
  bool isEdit = false;

  DateTime? isClick;

  @override
  void initState() {
    getData();
    if (widget.merchantId.trim() != "") {
      setState(() {
        isEdit = true;
        MerchantService.getInstance().getMerchantById(widget.merchantId).then(
          (merchant) {
            formController['name']!.text = merchant.merchantName!;
            formController['address']!.text = merchant.merchantAddress!;
            formController['description']!.text = merchant.description!;
            formController['number']!.text = merchant.number!;
            selectedProvince = formController['provinceCode']!.text =
                merchant.merchantProvince!.provinceCode!;
            selectedCity = formController['cityCode']!.text =
                merchant.merchantCity!.cityCode!;
            for (MerchantCategories cat in merchant.category!) {
              _selectedCategories.add(cat.category!);
            }
          },
        );
      });
    } else {
      formController['merchantId']!.text = AppUser.userId!;
    }
    setState(() {
      _image = CachedNetworkImage(
        imageUrl: ImageService.getProfileImage(AppUser.userId),
        placeholder: (context, url) => Image.asset("assets/user/userImage.png"),
        errorWidget: (context, url, error) =>
            Image.asset('assets/user/userImage.png'),
      );
    });
    super.initState();
  }

  getData() {
    _provinces = getProvinces();
    _cities = getCities();
    getCategoryList();
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
      body: GestureDetector(
        onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top * 1.5,
                  ),
                  if (!isEdit)
                    const Text("Data Mitra", style: AppTheme.headline),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: imagePickerWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          getTextField(
                              "nama", "nama", "", 1, formController['name']!),
                          getTextField("alamat", "alamat", "", 5,
                              formController['address']!),
                          getDropDownProvince(),
                          getDropDownCity(),
                          getNumberField("No. Handphone", "No. Handphone", "",
                              1, formController['number']!),
                          getTextField("Deskripsi", "Deskripsi", "", 10,
                              formController['description']!),
                          getCategories()
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
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        if (!isRedundentClick(DateTime.now())) {
                          saveForm();
                        }
                      },
                      child: isClick == null
                          ? Text(isEdit ? 'Ubah' : "Daftar")
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
      ),
    );
  }

  Widget imagePickerWidget() {
    return Stack(
      alignment:
          isImageUploaded ?? false ? Alignment.bottomCenter : Alignment.center,
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
            color: Colors.white,
            size: 40 - (isImageUploaded ?? false ? 15 : 0),
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
                      key: ValueKey(Random().nextInt(100)),
                      image: NetworkImage(
                          '${ImageService.getProfileImage(AppUser.userId)}?rand=${Random().nextInt(100)}'),
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

  Future<List<Province>> getProvinces() async {
    return await provinceService.getProvinces();
  }

  Future<List<City>> getCities() async {
    return await cityService.getCities(selectedProvince);
  }

  Widget getCategories() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          width: 1.0,
          color: AppTheme.grey,
        ),
      ),
      child: Column(
        children: <Widget>[
          MultiSelectBottomSheetField<CategoryModel>(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "tidak boleh kosong";
              }
              return null;
            },
            initialChildSize: 0.4,
            listType: MultiSelectListType.CHIP,
            buttonText: const Text("Pilih Kategori Layanan"),
            title: const Text("Pilih Kategori"),
            items: getItems(),
            initialValue: _selectedCategories,
            selectedColor: const Color.fromARGB(126, 2, 123, 163),
            selectedItemsTextStyle: AppTheme.buttonTextM,
            onSelectionChanged: (List<CategoryModel?> selectedCategories) {
              // Do something with the selected categories
            },
            onConfirm: (values) {
              setState(() {
                _selectedCategories = values;
              });
            },
            chipDisplay: MultiSelectChipDisplay<CategoryModel>(
              onTap: (value) {
                setState(() {
                  _selectedCategories.remove(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void addCategories(bool? tr) {}

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
        } else if (snapshot.hasError) {
          return Container();
        } else {
          if (snapshot.data == null) {
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
              child: DropdownButtonFormField<String>(
                value: selectedProvince,
                decoration: InputDecoration(
                  hintText: "Provinsi",
                  labelText: "Provinsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: snapshot.data!.map((e) {
                  return DropdownMenuItem(
                    value: e.provinceCode,
                    child: Text(e.provinceName ?? ""),
                  );
                }).toList(),
                isExpanded: true,
                isDense: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(
                    () {
                      _cities = getCities();
                      selectedProvince = value!;
                      formController['provinceCode']?.text = value;
                    },
                  );
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
                  setState(
                    () {
                      selectedCity = value!;
                      formController['cityCode']?.text = value;
                    },
                  )
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

  getNumberField(String hint, String label, String init, int maxLines,
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
    if (_formKey.currentState!.validate()) {
      formController['merchantId']!.text = AppUser.userId!;

      try {
        isEdit ? update() : create();
      } catch (e) {
        Helper.toast(e.toString(), 250, MotionToastPosition.top, 350);
      }
    }
  }

  create() {
    Map<String, dynamic> param = formController.data();
    param.putIfAbsent(
      "merchantCategory",
      () {
        String val = "";
        for (var e in _selectedCategories) {
          val += "${e.id},";
        }
        return val;
      },
    );
    try {
      merchantService.create(param).then(
        (value) {
          if (value.merchantName != null) {
            var toast = _displaySuccessMotionToast("Pendafataran Berhasil");
            toast.show(context);
            Future.delayed(const Duration(seconds: 1)).then(
              (value) {
                toast.dismiss();
                Helper.clearStackPush(
                  const HomePage(),
                );
              },
            );
          }
        },
      );
    } catch (e) {
      Helper.toast(e.toString(), 250, MotionToastPosition.top, 300);
    }
  }

  update() {
    merchantService.update(formController.data()).then(
      (value) {
        if (value) {
          var toast = _displaySuccessMotionToast("Ubah Berhasil");
          toast.show(context);
          Future.delayed(const Duration(seconds: 1)).then((value) {
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

  List<MultiSelectItem<CategoryModel>> getItems() {
    return _categories
        .map((e) => MultiSelectItem<CategoryModel>(e, e.name))
        .toList();
  }

  getCategoryList() async {
    CategoryService service = CategoryService.getInstance();
    service.getAll().then((value) {
      setState(() {
        _categories = value;
      });
    });
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
      animationType: AnimationType.fromRight,
      animationDuration: const Duration(milliseconds: 200),
      dismissable: true,
    );
    return toast;
  }

  bool isRedundentClick(DateTime currentTime) {
    if (isClick == null) {
      setState(() {
        isClick = currentTime;
      });
      return false;
    }
    if (currentTime.difference(isClick!).inSeconds < 10) {
      return true;
    }
    setState(() {
      isClick = null;
    });
    return false;
  }
}
