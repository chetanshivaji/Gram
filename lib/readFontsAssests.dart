//import 'package:flutter/material.dart';  //dont user material.dart or it will mix up with pdf creation apis
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:money/util.dart';

Future<void> readFontsFromAssets() async {
  var fontTableCellData =
      await rootBundle.load("assets/MartelSans-Regular.ttf");

  myPdfTableCellFontStyle = TextStyle(font: Font.ttf(fontTableCellData));
}
