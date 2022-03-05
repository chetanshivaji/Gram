import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:money/api/pdf_api.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

//********************END HouseWater report invoice****************************** */

class receiptInfo {
  final String date;
  final String taxType;
  final String name;
  final String amount;
  final String mobile;
  final String userMail;

  const receiptInfo({
    required this.date,
    required this.taxType,
    required this.name,
    required this.amount,
    required this.mobile,
    required this.userMail,
  });
}

abstract class receipt {
  final receiptInfo info;
  const receipt({
    required this.info,
  });
  //year date, name, mobile, amount, tax type, userMail(reciver).
  //Gram Details, - village, taluka, district, state, pin,
  //Stamp, Signature

  Future<File> generate(String reportType, String userMail) async {
    final pdf = Document();

    String pdfName = reportType +
        "_" +
        info.taxType +
        "_" +
        '_Receipt' +
        "_" +
        info.date +
        "_" +
        userMail;

    pdfName = pdfName.replaceAll(' ', '');
    String pdfTitle = pdfName;
    pdfName = pdfName + ".pdf";

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(pdfName),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(pdfTitle),
        buildInvoice(reportType),
        pw.Text("Dear " +
            info.name +
            " received " +
            info.taxType +
            " tax amount of Rs. " +
            info.amount +
            "Thank you!"),
      ],
      footer: (context) => buildFooter(userMail, reportType),
    ));

    return PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  Widget buildHeader(String pdfName) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: pdfName,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  Widget buildTitle(String pdfTitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pdfTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text("Year =  " +
              info.date +
              "\n" +
              "TaxType =  " +
              info.taxType +
              "\n" +
              "Name =  " +
              info.name +
              "\n" +
              "Mobile =  " +
              info.mobile +
              "\n" +
              "Downloaded by user =  " +
              info.userMail +
              "\n"),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  Widget buildInvoice(String reportType) {
    return Text("Something wrong in building RECEIPT main class");
  }

  static Widget buildFooter(String userMail, String reportType) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Downloaded', value: userMail),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Type', value: reportType),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

//********************START pending invoice****************************** */
/*
class pendingReceipt extends receipt {
  const pendingReceipt({
    info,
  }) : super(info: info);

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      'TaxType',
      'Mobile',
      'Amount',
    ];
    data = pendingInvoiceItems.map((item) {
      return [
        item.name,
        item.mobile,
        item.amount,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }
}
//********************END pending invoice****************************** */
*/
//********************START HouseWater report invoice****************************** */
class receivedReceipt extends receipt {
  const receivedReceipt({
    info,
  }) : super(info: info);

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      'Name',
      'Mobile',
      'Amount',
      'Date',
      'User',
    ];
    List<List<dynamic>> lld = [
      [info.name, info.mobile, info.amount, info.date, info.userMail],
    ];

    return Table.fromTextArray(
      headers: headers,
      data: lld,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }
}
