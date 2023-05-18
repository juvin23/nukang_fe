import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/size_utils.dart';
import 'package:nukang_fe/ratingpage/rating_input_page.dart';
import 'package:nukang_fe/themes/app_theme.dart';
import 'package:nukang_fe/transaction/date_request.dart';
import 'package:nukang_fe/transaction/price_request.dart';
import 'package:nukang_fe/transaction/transaction_model.dart';
import 'package:nukang_fe/transaction/transaction_service.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

// ignore: must_be_immutable
class WorkList extends StatefulWidget {
  const WorkList({super.key});

  @override
  State<WorkList> createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
  TransactionService service = TransactionService.getInstance();
  late Future<TransactionCount> transactionCount;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  late Future<List<Transaction>> transactions;

  @override
  initState() {
    reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        title: Text(
          AppUser.role == Role.customer
              ? "Daftar Pengerjaan"
              : "Daftar Pekerjaan",
          style: AppTheme.headline.copyWith(),
        ),
        actions: const [],
      ),
      backgroundColor: AppTheme.nearlyWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (AppUser.role == Role.merchant)
                FutureBuilder<TransactionCount>(
                  future: transactionCount,
                  builder: (context, snapshot) {
                    TransactionCount? data = snapshot.data;
                    return Container(
                      height: 100,
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyBlue,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Total Transaksi   : ${data != null ? data.count.toString() : "0"}",
                                style: AppTheme.body1,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Total Pendapatan   : Rp. ${data != null ? formatter.format(data.total) : "0.0"}",
                                style: AppTheme.body1,
                              ),
                            )
                          ]),
                    );
                  },
                ),
              Container(
                width: double.maxFinite,
                padding: getPadding(
                  left: 26,
                  right: 26,
                  bottom: 16,
                ),
                child: FutureBuilder<List<Transaction>>(
                  future: transactions, // function where you call your api
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Transaction>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(116, 233, 233, 233)
                              .withOpacity(0.04),
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12.5),
                          child: const Text("Tidak ada transaksi berlangsung."),
                        );
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12.5),
                            child:
                                const Text("Tidak ada transaksi berlangsung."),
                          );
                        }
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12.5),
                            child: Column(
                              children: List.generate(
                                snapshot.data!.length,
                                (index) => getListItem(snapshot.data![index]),
                              ),
                            ));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reload() {
    setState(() {
      transactions = getTransaction(AppUser.role == Role.merchant);
      if (AppUser.role == Role.merchant) {
        transactionCount = getTransactionCount();
      }
    });
  }

  Widget getListItem(Transaction transaction) {
    return GestureDetector(
      onTap: () async => {
        if (transaction.recordStatus == "1" ||
            (transaction.recordStatus == "2" &&
                AppUser.userId == transaction.merchantId))
          {
            await Helper.navigateToRoute(
              DateRequest(
                transaction: transaction,
                merchantId: transaction.merchantId!,
              ),
            ).then((value) => reload())
          }
        else if (transaction.recordStatus == "2" ||
            transaction.recordStatus == "3" ||
            transaction.recordStatus == "4")
          {
            await Helper.navigateToRoute(
              PriceRequest(
                transaction: transaction,
              ),
            ).then((value) => reload())
          }
        else if (transaction.recordStatus == "5")
          {
            await Helper.navigateToRoute(
              RatingInputPage(
                transaction: transaction,
              ),
            ).then((value) => reload())
          }
        else if (transaction.recordStatus == "X" ||
            transaction.recordStatus == "XX")
          {
            if (transaction.amount != null)
              await Helper.navigateToRoute(
                PriceRequest(
                  transaction: transaction,
                ),
              ).then((value) => reload())
            else
              {
                await Helper.navigateToRoute(
                  DateRequest(
                    merchantId: transaction.merchantId!,
                    transaction: transaction,
                  ),
                ).then((value) => reload())
              },
          }
      },
      child: SizedBox(
        width: double.maxFinite,
        child: Container(
          width: getHorizontalSize(
            304,
          ),
          margin: getMargin(
            left: 4,
            top: 20,
          ),
          padding: getPadding(
            left: 11,
            top: 18,
            right: 11,
            bottom: 18,
          ),
          decoration: BoxDecoration(
            color: AppTheme.notWhite,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: getMargin(
                  top: 4,
                  right: 51,
                ),
                child: Text(
                  formatter.format(transaction.lastUpdate!),
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: AppTheme.body1,
                ),
              ),
              Container(
                margin: getMargin(
                  top: 4,
                  right: 51,
                ),
                child: Text(
                  transaction.description ?? "",
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: AppTheme.body2,
                ),
              ),
              Container(
                margin: getMargin(
                  top: 4,
                  right: 51,
                ),
                decoration: BoxDecoration(
                  color: getColor(transaction),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2.0,
                    color: const Color.fromARGB(255, 16, 16, 16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    getStatus(transaction) ?? "unknown",
                    maxLines: null,
                    textAlign: TextAlign.left,
                    style: AppTheme.body2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getColor(Transaction transaction) {
    switch (transaction.recordStatus) {
      case "1":
        return Colors.lightBlue[200];
      case "2":
        return Colors.lightBlue[500];
      case "3":
        return Colors.lightBlue[200];
      case "4":
        return Colors.lightBlue[500];
      case "5":
        return Colors.greenAccent[200];
      case "X":
        return Colors.redAccent[200];
    }
  }

  getStatus(Transaction transaction) {
    switch (transaction.recordStatus) {
      case "1":
        return "Pengajuan Tanggal";
      case "2":
        return "Tanggal Disetujui";
      case "3":
        return "Pengajuan biaya";
      case "4":
        return "Pekerjaan berlangsung";
      case "5":
        return "Transaksi Selesai.";
      case "X":
        return "ditolak";
      case "XX":
        return "dibatalkan";
    }
  }

  Future<List<Transaction>> getTransaction(bool? isCheckPekerjaan) {
    if (isCheckPekerjaan == null || isCheckPekerjaan == false) {
      return service.getList();
    }
    return service.getPekerjaanList();
  }

  Future<TransactionCount> getTransactionCount() {
    return TransactionService.getInstance().count();
  }
}

class TransactionCount {
  double total = 0;
  int count = 0;
  TransactionCount();

  factory TransactionCount.fromJson(Map<String, dynamic> e) {
    TransactionCount transactionCount = TransactionCount();
    transactionCount.total = e['amount'];
    transactionCount.count = e['count'];
    return transactionCount;
  }
}
