import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:nukang_fe/shared/city_service.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:nukang_fe/shared/province_service.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/user/user_service.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key});

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  final cityService = CityService();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'provinceCode': TextEditingController(),
    'cityCode': TextEditingController(),
    'birthdate': TextEditingController(),
    'email': TextEditingController(),
    'number': TextEditingController()
  };

  String name = "";
  String address = "";
  DateTime? birthdate;
  var formatDate = DateFormat('EEE, dd-MMM-yyyy');

  final provinceService = ProvinceService.getInstance();

  String? selectedProvince;

  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Image.asset(
              "assets/logos/nukang_logo.png",
              width: 150,
            ),
            const Text("User Registration", style: AppTheme.headline),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    getTextField(
                        "nama", "nama", "", 1, formController['name']!),
                    getTextField(
                        "alamat", "alamat", "", 5, formController['address']!),
                    getDropDownProvince(),
                    getDropDownCity(),
                    getDate(),
                    getTextField(
                        "email", "email", "", 1, formController['email']!),
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
                text: birthdate == null ? "" : formatDate.format(birthdate!),
              ),
              decoration: InputDecoration(
                hintText: "Select StartDate",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: "Select Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              readOnly: true,
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  lastDate: DateTime.utc(9999, 01, 01),
                  firstDate: DateTime.utc(1963, 01, 01),
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
    return await cityService.getCities();
  }

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
                isExpanded: true,
                isDense: true,
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
                  print(value),
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
    formController['birthdate']?.text = birthdate.toString().substring(0, 10);
    formController['provinceCode']?.text = selectedProvince!;
    formController['number']?.text = '087881814150';
    userService.create(formController.data());
    print(formController.data());
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
