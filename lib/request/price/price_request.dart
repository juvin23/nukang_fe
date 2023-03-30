// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukang_fe/request/working_date/date_request/date_request.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class PriceRequest extends StatefulWidget {
  const PriceRequest({Key? key}) : super(key: key);

  @override
  State<PriceRequest> createState() => _PriceRequestState();
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

class _PriceRequestState extends State<PriceRequest> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> formController = {
    'name': TextEditingController(),
    'province': TextEditingController(),
    'city': TextEditingController(),
    'address': TextEditingController(),
    'email': TextEditingController(),
    'startDate': TextEditingController(),
    'endDate': TextEditingController(),
    'jobDesc': TextEditingController(),
    'priceCont': TextEditingController()
  };

  String name = "";
  String address = "";
  DateTimeRange? selectedDate;
  List<String> provinces = [];
  var formatDate = DateFormat('EEE, dd-MMM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              getRonlyTextField("nama", "nama", "", 1, formController['name']!),
              getRonlyTextField(
                  "alamat", "alamat", "", 5, formController['address']!),
              getDropDownProvince(),
              getDate(),
              getRonlyTextField("Apa yang akan dilakukan tukang?",
                  "Deskripsi Pekerjaan", "", 3, formController['jobDesc']!),
              getTextField(
                "Price",
                "Price",
                "",
                1,
                formController['priceCont']!,
              )
            ],
          ),
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

  getProvinces() {
    return ['DKI Jakarta', 'Bogor', 'Jakarta'];
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
}
