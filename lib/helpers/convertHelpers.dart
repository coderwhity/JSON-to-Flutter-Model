import 'dart:convert';
import 'package:flutter/material.dart';

class ConvertHelpers {
  bool checkIsJsonValid(String data) {
    try {
      print(jsonDecode(data));

      print("VALID JSON");
      return true;
    } catch (e) {
      print("INVALID JSON");
      return false;
    }
  }

  void showSnackBar(String msg, BuildContext context, int type) {
    Color textColor = Colors.white;
    Color bgColor = type == 1 ? Colors.green : Colors.redAccent;
    var snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Text(
        msg,
        style: TextStyle(color: textColor),
      ),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  StringBuffer stringBuffer = StringBuffer();
  Map<dynamic, dynamic> classCache = {};
  List<String> dataTypes = ['String', 'int', 'bool', 'List', 'Map', 'dynamic'];

  String generateModelClasses(String rootClassName, Map<String, dynamic> json) {
    print("JSON : ");
    print(json);

    classCache.clear();
    _generateModelClassStructureCache(rootClassName, json);
    _generateModelClasses();
    return stringBuffer.toString();
  }

  String generateModelClassesInputIsList(
      String rootClassName, List<dynamic> jsonList) {
    print("JSON : ");
    print(jsonList);

    classCache.clear();
    _generateModelClassStructureCacheForList(rootClassName, jsonList);
    _generateModelClasses();
    return stringBuffer.toString();
  }

  void _generateModelClassStructureCacheForList(
      String rootClassName, List<dynamic> jsonList) {
    // if (classCache.containsKey(rootClassName)) {
    //   return;
    // }
    classCache[rootClassName] = {};
    int maxAttributesIndex = 0;
    // jsonList.forEach((key) {
    for (int i = 0; i < jsonList.length; i++) {
      Map<String, dynamic> dataInMap = jsonList[i] as Map<String, dynamic>;
      if (dataInMap.entries.length >
          (jsonList[maxAttributesIndex] as Map<String, dynamic>)
              .entries
              .length) {
        maxAttributesIndex = i;
      }
    }
    Map<String, dynamic> json =
        jsonList[maxAttributesIndex] as Map<String, dynamic>;
    json.forEach((key, value) {
      print(key);

      String valueType = "dynamic";
      if (value is String) {
        valueType = "String";
        // print("Is String");
        // return String;
      } else if (value is int) {
        valueType = "int";
        // print("Is Int");
      } else if (value is double) {
        valueType = "double";
        // print("Is Double");
      } else if (value is bool) {
        valueType = "bool";
        // print("Is Bool");
      } else if (value is List) {
        valueType = "List<dynamic>";
        // print("Is Bool");
      } else if (value is Map) {
        valueType = key + "Model";
        _generateModelClassStructureCache(key + "Model", value);
        // print("Is Map");
      } else {
        valueType = "dynamic";
        // print("Is dynamic");
      }
    Map<dynamic, dynamic> valueOfClass = classCache[rootClassName];
    valueOfClass[key] = valueType;
    });
    print(classCache);
  }

  void _generateModelClasses() {
    print("IN GENERATE MODEL");
    classCache.forEach((key, value) {
      print(key);
      stringBuffer.writeln('class $key {');
      value.forEach((key1, value1) {
        stringBuffer.writeln('  $value1? $key1;');
      });
      stringBuffer.writeln();
      stringBuffer.writeln('  $key({');
      value.forEach((key2, value2) {
        stringBuffer.writeln('    this.$key2,');
      });
      stringBuffer.writeln('  });');
      stringBuffer.writeln();
      stringBuffer
          .writeln('  factory $key.fromJson(Map<String, dynamic> json) {');
      stringBuffer.writeln('    return $key(');
      value.forEach((key3, value3) {
        if (!dataTypes.contains(value3)) {
          if (value3.toString().contains('List')) {
            stringBuffer.writeln("${key3}: json['${key3}'] ?? null,");
          } else {
            stringBuffer.writeln(
                "${key3}: json['${key3}'] != null ? new ${value3}.fromJson(json['${key3}']) : null,");
          }
        } else {
          stringBuffer.writeln("${key3}: json['${key3}'] ?? null,");
        }
      });
      stringBuffer.writeln('  );');
      stringBuffer.writeln(' }');
      stringBuffer.writeln();
      stringBuffer.writeln('  Map<String, dynamic> toJson() {');
      stringBuffer.writeln(
          '    final Map<String, dynamic> data = <String, dynamic>{};');
      value.forEach((key4, value4) {
        stringBuffer.writeln("      data['${key4}'] = this.${key4};");
      });
      stringBuffer.writeln("      return data;");
      stringBuffer.writeln('}');
      stringBuffer.writeln('}');
    });
  }

  void _generateModelClassStructureCache(
      String rootClassName, Map<dynamic, dynamic> json) {
    if (classCache.containsKey(rootClassName)) {
      return;
    }
    classCache[rootClassName] = {};

    json.forEach((key, value) {
      print(key);

      String valueType = "dynamic";
      if (value is String) {
        valueType = "String";
        // print("Is String");
        // return String;
      } else if (value is int) {
        valueType = "int";
        // print("Is Int");
      } else if (value is double) {
        valueType = "double";
        // print("Is Double");
      } else if (value is bool) {
        valueType = "bool";
        // print("Is Bool");
      } else if (value is List) {
        valueType = "List<dynamic>";
        // print("Is Bool");
      } else if (value is Map) {
        valueType = key + "Model";
        _generateModelClassStructureCache(key + "Model", value);
        // print("Is Map");
      } else {
        valueType = "dynamic";
        // print("Is dynamic");
      }
      Map<dynamic, dynamic> valueOfClass = classCache[rootClassName];
      valueOfClass[key] = valueType;
    });
    print(classCache);
  }
}
