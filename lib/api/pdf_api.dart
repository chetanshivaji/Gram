import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String gReceiptPdfName = "";

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$name');

    gReceiptPdfName =
        await '${dir?.path}/$name'; //for sending attachmenet to mail.

    await file.writeAsBytes(bytes, flush: true);
    print(file.exists());

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
