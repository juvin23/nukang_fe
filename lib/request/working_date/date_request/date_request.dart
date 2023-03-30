// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/request/requestService.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/user/user/user_model.dart';

class DateRequest extends StatefulWidget {
  DateRequest({Key? key, MerchantModel? merchantModel, UserModel? userModel})
      : super(key: key);
  MerchantModel? merchantModel;
  UserModel? userModel;
  @override
  State<DateRequest> createState() => _DateRequestState();
}

class _DateRequestState extends State<DateRequest> {
  final _formKey = GlobalKey<FormState>();
  final RequestService requestService = RequestService();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'province': TextEditingController(),
    'city': TextEditingController(),
    'address': TextEditingController(),
    'email': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
    'jobDesc': TextEditingController()
  };
  String name = "";
  String address = "";
  DateTimeRange? selectedDate;
  List<String> provinces = [];
  var formatDate = DateFormat('EEE, dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    provinces = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.notWhite,
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
              const Text(
                "Request Tanggal Kerja",
                style: TextStyle(
                  color: AppTheme.lightText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      getTextField(
                          "nama", "nama", "", 1, formController['name']!),
                      getTextField("alamat", "alamat", "", 5,
                          formController['address']!),
                      getDropDownProvince(),
                      getDate(),
                      getTextField(
                          "Apa yang akan dilakukan tukang?",
                          "Deskripsi Pekerjaan",
                          "",
                          3,
                          formController['jobDesc']!),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppTheme.nearlyBlue,
                            foregroundColor: AppTheme.darkText,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: SingleChildScrollView(
                              //       scrollDirection: Axis.horizontal,
                              //       child: Text(
                              //         formController.data().toString(),
                              //       ),
                              //     ),
                              //   ),
                              // );
                              saveForm();
                            }
                          },
                          child: const Text('Request Date'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getProvinces() {
    return ['DKI Jakarta', 'Bogor', 'Jakarta'];
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

  getDate() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextFormField(
              controller: TextEditingController(
                text: selectedDate == null
                    ? ""
                    : formatDate.format(selectedDate!.start),
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
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (dateTimeRange != null) {
                  setState(() {
                    selectedDate = dateTimeRange;
                  });
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
            child: TextField(
              controller: TextEditingController(
                text: selectedDate == null
                    ? ""
                    : formatDate.format(selectedDate!.end),
              ),
              decoration: InputDecoration(
                hintText: selectedDate == null
                    ? "Select end date"
                    : formatDate.format(selectedDate!.end),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                labelText: "Select End Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              readOnly: true,
              onTap: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (dateTimeRange != null) {
                  setState(() {
                    selectedDate = dateTimeRange;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  getDropDownProvince() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: "Province",
          labelText: "Province",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        items: provinces.map((prov) {
          return DropdownMenuItem(
            value: prov,
            child: Text(prov),
          );
        }).toList(),
        isExpanded: true,
        isDense: true,
        onChanged: (value) => {},
      ),
    );
  }

  saveForm() {
    requestService.request(formController.data());
  }
}

extension Data on Map<String, TextEditingController> {
  Map<String, String> data() {
    final res = <String, String>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value?.text);
    }
    return res;
  }
}
