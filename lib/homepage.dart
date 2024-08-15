import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json2model/helpers/convertHelpers.dart';
import 'helpers/download_helpers.dart'
    if (dart.library.html) 'helpers/web_download_helpers.dart' as my_worker;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConverting = false;
  TextEditingController _jsonTextController = TextEditingController();
  TextEditingController _modelTextController = TextEditingController();

  void copyModel() async {
    await Clipboard.setData(ClipboardData(text: _modelTextController.text));
    ConvertHelpers().showSnackBar("Model Copied.", context, 1);
  }

  void downloadModelFile() async {
    my_worker.downloadModelFile(_modelTextController.text, context);
    // String modelCode = _modelTextController.text;
    // if (kIsWeb) {
    //   print("DOWNLOADING FOR WEB");
    //   // Web platform
    //   final bytes = utf8.encode(modelCode);
    //   final blob = html.Blob([Uint8List.fromList(bytes)]);
    //   final url = html.Url.createObjectUrlFromBlob(blob);

    //   final anchor = html.AnchorElement(href: url)
    //     ..setAttribute('download', 'json2model.dart')
    //     ..click();

    //   html.Url.revokeObjectUrl(url);

    //   ConvertHelpers().showSnackBar("Model file downloaded", context, 1);
    // } else if (io.Platform.isAndroid || io.Platform.isIOS) {
    //   // Mobile platform
    //   // Mobile platforms do not support file downloads directly, so you will need to use plugins like `flutter_downloader` or `path_provider`
    //   ConvertHelpers().showSnackBar(
    //       "File download is not supported on mobile platforms.", context, 2);
    // } else {
    //   // Desktop platforms (Windows, macOS, Linux)
    //   // For desktop platforms, you can use `dart:io` to write files
    //   // final file = io.File('path/to/your/directory/json2model.dart');
    //   // await file.writeAsString(modelCode);

    //   // ConvertHelpers().showSnackBar("Model file downloaded to ${file.path}", context, 1);
    // }
    // ConvertHelpers().showSnackBar("Coming Soon..", context, 1);
  }

  void convertData() async {
    print("CONVERT BIG");
    if (_isConverting) {
      setState(() {
        _isConverting = false;
      });
      print("IS CONVERTING");
    }
    setState(() {
      _isConverting = true;
    });
    if (_jsonTextController.text.trim().isNotEmpty) {
      bool validStatus =
          ConvertHelpers().checkIsJsonValid(_jsonTextController.text.trim());
      if (!validStatus) {
        ConvertHelpers().showSnackBar("Invalid JSON", context, 2);
        setState(() {
          _isConverting = false;
        });
        return;
      }
      print("TILL HERE");
      dynamic jsonData = jsonDecode(_jsonTextController.text.trim());
      print("JSON DATA");
      String dataAfterConverting = "";
      if (jsonData is Map) {
        dataAfterConverting = await ConvertHelpers().generateModelClasses(
            "ModelName", jsonData as Map<String, dynamic>);
      } else if (jsonData is List<dynamic>) {
        dataAfterConverting = await ConvertHelpers()
            .generateModelClassesInputIsList("ModelName", jsonData);
      }
      print(dataAfterConverting);
      _modelTextController.text = dataAfterConverting;
    } else {
      ConvertHelpers().showSnackBar("Please Enter JSON data.", context, 2);
    }
    setState(() {
      _isConverting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Json2Model"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isSmallScreen =
                  constraints.maxWidth < 800; // Adjust the breakpoint as needed
              double height = constraints.maxHeight;
              double width = constraints.maxWidth;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: isSmallScreen
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: height * 0.4, // Adjust height as needed
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _jsonTextController,
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(fontSize: width * 0.05),
                                      hintText: "Enter JSON here",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                    expands: true,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: Colors.transparent,
                              // margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        convertData();
                                      },
                                      child: Container(
                                        width: width * 0.3,
                                        height: width * 0.07,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "Convert",
                                          style:
                                              TextStyle(fontSize: width * 0.05),
                                        )),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Wrap(
                                      spacing: 5,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            copyModel();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: width * 0.1,
                                            width: width * 0.1,
                                            child: Center(
                                              child: Icon(Icons.copy,
                                                  color: Colors.white,
                                                  size: width * 0.055),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            downloadModelFile();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: width * 0.1,
                                            width: width * 0.1,
                                            child: Icon(Icons.download,
                                                color: Colors.white,
                                                size: width * 0.055),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: height * 0.4, // Adjust height as needed
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _modelTextController,
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(fontSize: width * 0.05),
                                      hintText: "Model will be displayed here",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                    expands: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Card(
                              elevation: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                height: 150, // Adjust height as needed
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _jsonTextController,
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(fontSize: width * 0.02),
                                      hintText: "Enter JSON here",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                    expands: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Card(
                              color: Colors.transparent,
                              elevation: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            convertData();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: width * 0.03,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Convert",
                                              style: TextStyle(
                                                  fontSize: width * 0.01),
                                            )),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.05),
                                        Wrap(
                                          spacing: 5,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                copyModel();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                height: width * 0.03,
                                                width: width * 0.03,
                                                child: Center(
                                                  child: Icon(Icons.copy,
                                                      color: Colors.white,
                                                      size: width * 0.015),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                downloadModelFile();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                height: width * 0.03,
                                                width: width * 0.03,
                                                child: Icon(Icons.download,
                                                    color: Colors.white,
                                                    size: width * 0.015),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Card(
                              elevation: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                height: 150, // Adjust height as needed
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _modelTextController,
                                    decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(fontSize: width * 0.02),
                                      hintText: "Model will be displayed here",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                    expands: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
