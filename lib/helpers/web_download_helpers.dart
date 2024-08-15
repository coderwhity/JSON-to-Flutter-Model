import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json2model/helpers/convertHelpers.dart';
import 'dart:io' as io;

void downloadModelFile(String modelCode, BuildContext context) async {
  if (kIsWeb) {
    print("DOWNLOADING FOR WEB");
    // Web platform
    final bytes = utf8.encode(modelCode);
    final blob = html.Blob([Uint8List.fromList(bytes)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'json2model.dart')
      ..click();

    html.Url.revokeObjectUrl(url);

    ConvertHelpers().showSnackBar("Model file downloaded", context, 1);
  } 
}
