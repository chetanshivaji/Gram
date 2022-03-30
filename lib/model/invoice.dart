import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:money/api/pdf_api.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';

//********************END HouseWater report invoice****************************** */
Widget getTableOnPDF(List<dynamic>? headers, List<List<dynamic>> data) {
  return Table.fromTextArray(
    headers: headers,
    data: data,
    border: null,
    headerStyle: TextStyle(fontWeight: FontWeight.bold),
    headerDecoration: BoxDecoration(color: PdfColors.grey300),
    cellHeight: 30,
    cellAlignments: {
      0: Alignment.center,
      1: Alignment.center,
      2: Alignment.center,
      3: Alignment.center,
      4: Alignment.center,
      5: Alignment.center,
    },
  );
}

class InvoiceInfo {
  final String formula;
  final String year;
  final String sortingType;
  final String taxType;

  const InvoiceInfo({
    required this.formula,
    required this.year,
    required this.sortingType,
    required this.taxType,
  });
}

abstract class Invoice {
  final InvoiceInfo info;
  const Invoice({
    required this.info,
  });
  Future<File> generate(String reportType, String userMail, String startDate,
      String endDate) async {
    final pdf = Document();

    String pdfName = reportType +
        "_" +
        info.taxType +
        "_" +
        info.year +
        "_" +
        info.sortingType;

    pdfName = pdfName.replaceAll(' ', '');
    String pdfTitle = pdfName;
    pdfName = pdfName + ".pdf";

    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(pdfName),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildTitle(pdfTitle, userMail, startDate, endDate),
          buildInvoice(reportType),
        ],
        footer: (context) => buildFooter(userMail, reportType),
      ),
    );

    return PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  Widget buildTitle(
          String pdfTitle, String userMail, String startDate, String endDate) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pdfTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(labelYear +
              equals +
              info.year +
              endL +
              txtDateRange +
              equals +
              startDate +
              "  :  " +
              endDate +
              endL +
              txtSortingType +
              equals +
              info.sortingType +
              endL +
              txtCalculation +
              equals +
              info.formula +
              endL +
              txtDownloadedByUser +
              equals +
              userMail +
              endL),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
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

  Widget buildInvoice(String reportType) {
    return Text(msgInvoidBuildFail);
  }

  static Widget buildFooter(String userMail, String reportType) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: txtGram, value: village + txtFwdSlash + pin),
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
          Expanded(
            child: Text(title, style: style),
          ),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

//********************START pending invoice****************************** */
class pendingInvoice extends Invoice {
  final List<pendingEntry> pendingInvoiceItems;

  const pendingInvoice({
    info,
    required this.pendingInvoiceItems,
  }) : super(info: info);
  Widget buildTitle(
          String pdfTitle, String userMail, String startDate, String endDate) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pdfTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(labelYear +
              equals +
              info.year +
              endL +
              txtSortingType +
              equals +
              info.sortingType +
              endL +
              txtCalculation +
              equals +
              info.formula +
              endL +
              txtDownloadedByUser +
              equals +
              userMail +
              endL),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingSrnum,
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingUid,
      tableHeadingAmount,
    ];
    data = pendingInvoiceItems.map(
      (item) {
        return [
          item.srnum,
          item.name,
          item.mobile,
          item.uid,
          item.amount,
        ];
      },
    ).toList();

    return getTableOnPDF(headers, data);
  }
}
//********************END pending invoice****************************** */

//********************START HouseWater report invoice****************************** */
class reportHouseWaterInvoice extends Invoice {
  final List<houseWaterReportEntry> houseWaterReportInvoiceItems;

  const reportHouseWaterInvoice({
    info,
    required this.houseWaterReportInvoiceItems,
  }) : super(info: info);

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingSrnum,
      tableHeadingName,
      tableHeadingMobile,
      tableHeadingUid,
      tableHeadingAmount,
      tableHeadingDate,
      tableHeadingUser,
    ];
    data = houseWaterReportInvoiceItems.map(
      (item) {
        return [
          item.srnum,
          item.name,
          item.mobile,
          item.uid,
          item.amount,
          item.date,
          item.user,
        ];
      },
    ).toList();

    return getTableOnPDF(headers, data);
  }
}

//********************START extra Income report invoice****************************** */
class reportExtraInvoice extends Invoice {
  final List<extraIncomeReportEntry> extraIncomeReportInvoiceItems;

  const reportExtraInvoice({
    info,
    required this.extraIncomeReportInvoiceItems,
  }) : super(info: info);

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingSrnum,
      tableHeadingAmount,
      tableHeadingReason,
      tableHeadingDate,
      tableHeadingUser,
    ];
    data = extraIncomeReportInvoiceItems.map((item) {
      return [
        item.srnum,
        item.amount,
        item.reason,
        item.date,
        item.user,
      ];
    }).toList();

    return getTableOnPDF(headers, data);
  }
}

//********************END extra Income report invoice****************************** */

//********************START out report invoice****************************** */

class reportOutInvoice extends Invoice {
  final List<outReportEntry> outReportInvoiceItems;

  const reportOutInvoice({
    info,
    required this.outReportInvoiceItems,
  }) : super(info: info);

  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      tableHeadingSrnum,
      tableHeadingName,
      tableHeadingReason,
      tableHeadingAmount,
      tableHeadingExtraInfo,
      tableHeadingDate,
      tableHeadingUser,
    ];
    data = outReportInvoiceItems.map(
      (item) {
        return [
          item.srnum,
          item.name,
          item.reason,
          item.amount,
          item.extraInfo,
          item.date,
          item.user,
        ];
      },
    ).toList();

    return getTableOnPDF(headers, data);
  }
}

//********************END out report invoice****************************** */

class entry {}

class pendingEntry extends entry {
  final String srnum;
  final String name;
  final String mobile;
  final String uid;
  final String amount;

  pendingEntry({
    required this.srnum,
    required this.name,
    required this.mobile,
    required this.uid,
    required this.amount,
  });
}

class houseWaterReportEntry extends entry {
  final String srnum;
  final String name;
  final String mobile;
  final String uid;
  final String amount;
  final String date;
  final String user;

  houseWaterReportEntry({
    required this.srnum,
    required this.name,
    required this.mobile,
    required this.uid,
    required this.amount,
    required this.date,
    required this.user,
  });
}

class extraIncomeReportEntry extends entry {
  final String srnum;
  final String amount;
  final String reason;
  final String date;
  final String user;

  extraIncomeReportEntry({
    required this.srnum,
    required this.amount,
    required this.reason,
    required this.date,
    required this.user,
  });
}

class outReportEntry extends entry {
  final String srnum;
  final String name;
  final String reason;
  final String amount;
  final String extraInfo;
  final String date;
  final String user;

  outReportEntry({
    required this.srnum,
    required this.name,
    required this.reason,
    required this.amount,
    required this.extraInfo,
    required this.date,
    required this.user,
  });
}
