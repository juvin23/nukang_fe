import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nukang_fe/shared/category_model.dart';
import 'package:nukang_fe/shared/category_service.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:nukang_fe/shared/city_service.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:nukang_fe/shared/province_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/merchants/services/merchant_service.dart';
import 'package:nukang_fe/user/user/user_service.dart';

class MerchantRegistration extends StatefulWidget {
  const MerchantRegistration({super.key});

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
  };
  bool isChecked = false;

  String name = "";
  String address = "";

  final provinceService = ProvinceService();

  String? selectedProvince;

  String? selectedCity;

  List<CategoryModel>? _category = [];

  List<CategoryModel>? _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/logos/nukang_logo.png",
                  width: 150,
                ),
                const Text("Merchant Registration", style: AppTheme.headline),
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
                        getTextField(
                            "email", "email", "", 1, formController['email']!),
                        getTextField("Description", "description", "", 1,
                            formController['description']!),
                        getCheckBoxes()
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
                      saveForm();
                    },
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Province>> getProvinces() async {
    return await provinceService.getProvinces();
  }

  Future<List<City>> getCities() async {
    return await cityService.getCities();
  }

  Widget getCheckBoxes() {
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
          MultiSelectBottomSheetField(
            initialChildSize: 0.4,
            listType: MultiSelectListType.CHIP,
            searchable: true,
            buttonText: const Text("Service Categories"),
            title: const Text("Select Categories"),
            items: getItems(),
            onConfirm: (values) {
              setState(() {
                _selectedCategories = values.cast<CategoryModel>();
              });
            },
            chipDisplay: MultiSelectChipDisplay(
              onTap: (value) {
                setState(() {
                  _selectedCategories!.remove(value);
                });
              },
            ),
          ),
          if (_selectedCategories!.isEmpty)
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "None selected",
                  style: TextStyle(color: Colors.black54),
                ))
        ],
      ),
    );
  }

  void addCategories(bool? tr) {}

  getDropDownProvince() {
    return FutureBuilder<List<Province>>(
      future: getProvinces(), // function where you call your api
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
                  hintText: "Province",
                  labelText: "Province",
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
                value: selectedProvince,
                decoration: InputDecoration(
                  hintText: "Province",
                  labelText: "Province",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                items: List.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                          value: snapshot.data?[index].provinceCode,
                          child: Text(
                              snapshot.data?[index].provinceName ?? "no Data"),
                        )),
                onSaved: (newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                onChanged: (value) => {
                  setState(() {
                    selectedProvince = value!;
                  })
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
      future: getCities(), // function where you call your api
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
                  hintText: "City",
                  labelText: "City",
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
                value: selectedCity,
                decoration: InputDecoration(
                  hintText: "City",
                  labelText: "City",
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
                onChanged: (value) => {
                  setState(() {
                    selectedCity = value!;
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
    formController['cityCode']?.text = selectedCity!;
    formController['provinceCode']?.text = selectedProvince!;
    formController['number']?.text = '087881814150';
    // String categories = '';
    // for (var element in _selectedCategories!) {
    //   categories += '${element.id!},';
    // }
    Map<String, dynamic> param = formController.data();
    param.putIfAbsent(
      "category",
      () => _selectedCategories!.map((e) => {"category": e.toJson()}).toList(),
    );
    print(param);
    merchantService.create(param);
  }

  List<MultiSelectItem<CategoryModel>> getItems() {
    return _category!
        .map((e) => MultiSelectItem<CategoryModel>(e, e.name!))
        .toList();
  }

  getCategoryList() async {
    CategoryService service = CategoryService.getInstance();
    service.getAll().then((value) => _category = value);
  }
}

extension Data on Map<String, TextEditingController> {
  Map<String, dynamic> data() {
    final res = <String, dynamic>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value?.text);
    }

    return res;
  }
}
