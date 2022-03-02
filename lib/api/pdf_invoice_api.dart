import 'dart:io';
import 'package:money/model/invoice.dart';
import 'package:money/api/pdf_api.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      pendingInvoice invoice, String reportType, String userMail) async {
    final pdf = Document();

    String pdfName = reportType +
        "_" +
        invoice.info.taxType +
        "_" +
        '_Invoice' +
        "_" +
        invoice.info.year +
        "_" +
        invoice.info.sortingType +
        "_" +
        userMail;

    pdfName = pdfName.replaceAll(' ', '');
    String pdfTitle = pdfName;
    pdfName = pdfName + ".pdf";

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, pdfName),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice, pdfTitle, userMail),
        buildInvoice(invoice),
      ],
      footer: (context) => buildFooter(invoice, userMail, reportType),
    ));

    return PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  static Widget buildHeader(pendingInvoice invoice, String pdfName) => Column(
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

  static Widget buildTitle(
          pendingInvoice invoice, String pdfTitle, String userMail) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pdfTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text("Year =  " +
              invoice.info.year +
              "\n" +
              "Sorting type =  " +
              invoice.info.sortingType +
              "\n" +
              "Calculation =  " +
              invoice.info.formula +
              "\n" +
              "Downloaded by user =  " +
              userMail +
              "\n"),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(pendingInvoice invoice) {
    final headers = [
      'Name',
      'Mobile',
      'Amount',
    ];
    final data = invoice.pendingInvoiceItems.map((item) {
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

  static Widget buildFooter(
          pendingInvoice invoice, String userMail, String reportType) =>
      Column(
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
