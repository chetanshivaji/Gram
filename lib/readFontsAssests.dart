import 'dart:io';
//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:flutter/services.dart';
import 'package:money/api/pdf_api.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:money/constants.dart';
import 'package:money/util.dart';

Future<void> readFontsFromAssets() async {
  var fontTableCellData = await rootBundle.load("assets/Poppins-Light.ttf");

  myPdfTableCellFontStyle = TextStyle(font: Font.ttf(fontTableCellData));
}
