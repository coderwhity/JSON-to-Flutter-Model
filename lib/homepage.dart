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
    String text = _modelTextController.text.trim();
    if (text.isEmpty) {
      ConvertHelpers().showSnackBar(
          "Model text is empty. Please enter valid JSON data.", context, 2);
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    ConvertHelpers().showSnackBar("Model Copied.", context, 1);
  }

  void downloadModelFile() async {
    String text = _modelTextController.text.trim();
    if (text.isEmpty) {
      ConvertHelpers().showSnackBar(
          "Model text is empty. Please enter valid JSON data.", context, 2);
      return;
    }
    my_worker.downloadModelFile(text, context);
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
        if ((jsonData as List<dynamic>).isEmpty) {
          ConvertHelpers().showSnackBar(
              "Invalid JSON.", context, 2);
          return;
        }
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
                  constraints.maxWidth < 800; 
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
                                height: height * 0.4, 
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
                                height: height * 0.4,
                                
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
                                height: 150, 
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
                                height: 150,  
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
