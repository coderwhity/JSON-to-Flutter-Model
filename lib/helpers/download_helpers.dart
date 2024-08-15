import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:json2model/helpers/convertHelpers.dart';

// TODO: FIX DOWNLOAD ISSUE FOR ANDROID

void downloadModelFile(String modelCode, BuildContext context) async {
  if (modelCode.trim().isEmpty) {
    ConvertHelpers().showSnackBar(
        "Model code is empty. Please provide valid model code.", context, 2);
    return;
  }

  try {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      print("RESULT ");
      print(result);
      final filePath = '${result}json2model.dart';
      final file = io.File(filePath);
      await file.writeAsString(modelCode);
      ConvertHelpers().showSnackBar(
          "File saved as json2model.dart in the selected directory.",
          context,
          1);
    } else {
      ConvertHelpers()
          .showSnackBar("No directory selected. File not saved.", context, 2);
    }
  } catch (e) {
    ConvertHelpers()
        .showSnackBar("Failed to save file: ${e.toString()}", context, 2);
  }
}
