import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:money/api/pdf_api.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//********************END HouseWater report invoice****************************** */
Widget getTableOnPDF(List<dynamic>? headers, List<List<dynamic>> data) {
  return Table.fromTextArray(
    headers: headers,
    data: data,
    cellStyle: myPdfTableCellFontStyle,
    border: null,
    headerStyle:
        myPdfTableCellFontStyle, //TextStyle(fontWeight: FontWeight.bold),
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

    pdfName = pdfName.replaceAll(' ', '_');
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

    return await PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  Widget buildTitle(
          String pdfTitle, String userMail, String startDate, String endDate) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pdfTitle,
            style:
                myPdfTableCellFontStyle, //TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
              AppLocalizations.of(gContext)!.tableHeadingYear +
                  equals +
                  info.year +
                  endL +
                  AppLocalizations.of(gContext)!.txtDateRange +
                  equals +
                  startDate +
                  "  :  " +
                  endDate +
                  endL +
                  AppLocalizations.of(gContext)!.txtSortingType +
                  equals +
                  info.sortingType +
                  endL +
                  AppLocalizations.of(gContext)!.txtCalculation +
                  equals +
                  info.formula +
                  endL +
                  AppLocalizations.of(gContext)!.txtDownloadedByUser +
                  equals +
                  userMail +
                  endL,
              style: myPdfTableCellFontStyle),
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
    return Text(AppLocalizations.of(gContext)!.msgInvoidBuildFail,
        style: myPdfTableCellFontStyle);
  }

  static Widget buildFooter(String userMail, String reportType) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: AppLocalizations.of(gContext)!.appMainLabel,
              value: village + txtFwdSlash + pin),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: AppLocalizations.of(gContext)!.txtTaxType,
              value: reportType),
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
        //Text(title, style: style),
        Text(title, style: myPdfTableCellFontStyle),
        SizedBox(width: 2 * PdfPageFormat.mm),
        //Text(value),
        Text(value, style: myPdfTableCellFontStyle),
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
            child: Text(title, style: myPdfTableCellFontStyle),
          ),
          Text(value, style: myPdfTableCellFontStyle),
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
            //style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            style: myPdfTableCellFontStyle,
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            AppLocalizations.of(gContext)!.tableHeadingYear +
                equals +
                info.year +
                endL +
                AppLocalizations.of(gContext)!.txtSortingType +
                equals +
                info.sortingType +
                endL +
                AppLocalizations.of(gContext)!.txtCalculation +
                equals +
                info.formula +
                endL +
                AppLocalizations.of(gContext)!.txtDownloadedByUser +
                equals +
                userMail +
                endL,
            style: myPdfTableCellFontStyle,
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
  @override
  Widget buildInvoice(String reportType) {
    var headers;
    var data;

    headers = [
      AppLocalizations.of(gContext)!.tableHeadingSrnum,
      AppLocalizations.of(gContext)!.tableHeadingName,
      AppLocalizations.of(gContext)!.tableHeadingMobile,
      AppLocalizations.of(gContext)!.tableHeadingUid,
      AppLocalizations.of(gContext)!.tableHeadingAmount,
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
      AppLocalizations.of(gContext)!.tableHeadingSrnum,
      AppLocalizations.of(gContext)!.tableHeadingName,
      AppLocalizations.of(gContext)!.tableHeadingMobile,
      AppLocalizations.of(gContext)!.tableHeadingUid,
      AppLocalizations.of(gContext)!.tableHeadingAmount,
      AppLocalizations.of(gContext)!.tableHeadingDate,
      AppLocalizations.of(gContext)!.tableHeadingUser,
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
      AppLocalizations.of(gContext)!.tableHeadingSrnum,
      AppLocalizations.of(gContext)!.tableHeadingAmount,
      AppLocalizations.of(gContext)!.tableHeadingReason,
      AppLocalizations.of(gContext)!.tableHeadingDate,
      AppLocalizations.of(gContext)!.tableHeadingUser,
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
      AppLocalizations.of(gContext)!.tableHeadingSrnum,
      AppLocalizations.of(gContext)!.tableHeadingName,
      AppLocalizations.of(gContext)!.tableHeadingReason,
      AppLocalizations.of(gContext)!.tableHeadingAmount,
      AppLocalizations.of(gContext)!.tableHeadingExtraInfo,
      AppLocalizations.of(gContext)!.tableHeadingDate,
      AppLocalizations.of(gContext)!.tableHeadingUser,
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
