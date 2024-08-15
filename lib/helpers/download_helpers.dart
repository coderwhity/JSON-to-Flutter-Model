import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json2model/helpers/convertHelpers.dart';
import 'dart:io' as io;

void downloadModelFile(String modelCode, BuildContext context) async {
  if (io.Platform.isAndroid || io.Platform.isIOS) {
    // Mobile platform
    // Mobile platforms do not support file downloads directly, so you will need to use plugins like `flutter_downloader` or `path_provider`
    ConvertHelpers().showSnackBar(
        "File download is not supported on mobile platforms.", context, 2);
  } else {
    // Desktop platforms (Windows, macOS, Linux)
    // For desktop platforms, you can use `dart:io` to write files
    // final file = io.File('path/to/your/directory/json2model.dart');
    // await file.writeAsString(modelCode);

    // ConvertHelpers().showSnackBar("Model file downloaded to ${file.path}", context, 1);
  }
  ConvertHelpers().showSnackBar("Coming Soon..", context, 1);
}
