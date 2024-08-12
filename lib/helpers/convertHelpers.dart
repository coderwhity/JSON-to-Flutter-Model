import 'dart:convert';
import 'package:flutter/material.dart';

class ConvertHelpers {
  bool checkIsJsonValid(String data) {
    try {
      jsonDecode(data);
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
    classCache.clear();
    _generateModelClassStructureCache(rootClassName, json);
    _generateModelClasses();
    return stringBuffer.toString();
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
  // void _generateModelClass(String className, dynamic json) {
  //   if (classCache.containsKey(className)) return;

  //   StringBuffer buffer = StringBuffer();
  //   Map<String, String> typeMap = {};

  //   // Start the class
  //   stringBuffer.writeln('class $className {');

  //   // Generate class properties
  //   if (json is Map<String, dynamic>) {
  //     json.forEach((key, value) {
  //       try {
  //         String type = _getDartType(value, typeMap);
  //         stringBuffer.writeln('  $type? $key;');
  //       } catch (e) {
  //         print('Error generating property for $key: $e');
  //       }
  //     });
  //   }

  //   // Constructor
  //   stringBuffer.writeln();
  //   stringBuffer.writeln('  $className({');
  //   if (json is Map<String, dynamic>) {
  //     json.forEach((key, value) {
  //       stringBuffer.writeln('    this.$key,');
  //     });
  //   }
  //   stringBuffer.writeln('  });');

  //   // From JSON
  //   stringBuffer.writeln();
  //   stringBuffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  //   stringBuffer.writeln('    return $className(');
  //   if (json is Map<String, dynamic>) {
  //     json.forEach((key, value) {
  //       try {
  //         String type = typeMap[key]!;
  //         if (type.startsWith('List<')) {
  //           stringBuffer.writeln('      $key: json[\'$key\'] != null ? (json[\'$key\'] as List).map((i) => ${_getNestedClassName(type)}.fromJson(i as Map<String, dynamic>)).toList() : null,');
  //         } else if (type.startsWith('Map<')) {
  //           stringBuffer.writeln('      $key: json[\'$key\'] != null ? ${_getNestedClassName(type)}.fromJson(json[\'$key\'] as Map<String, dynamic>) : null,');
  //         } else {
  //           stringBuffer.writeln('      $key: json[\'$key\'],');
  //         }
  //       } catch (e) {
  //         print('Error in fromJson for $key: $e');
  //       }
  //     });
  //   }
  //   stringBuffer.writeln('    );');
  //   stringBuffer.writeln('  }');

  //   // To JSON
  //   stringBuffer.writeln();
  //   stringBuffer.writeln('  Map<String, dynamic> toJson() {');
  //   stringBuffer.writeln('    final Map<String, dynamic> data = <String, dynamic>{};');
  //   if (json is Map<String, dynamic>) {
  //     json.forEach((key, value) {
  //       try {
  //         String type = typeMap[key]!;
  //         if (type.startsWith('List<')) {
  //           stringBuffer.writeln('    if (this.$key != null) {');
  //           stringBuffer.writeln('      data[\'$key\'] = this.$key!.map((v) => v.toJson()).toList();');
  //           stringBuffer.writeln('    }');
  //         } else if (type.startsWith('Map<')) {
  //           stringBuffer.writeln('    if (this.$key != null) {');
  //           stringBuffer.writeln('      data[\'$key\'] = this.$key!.toJson();');
  //           stringBuffer.writeln('    }');
  //         } else {
  //           stringBuffer.writeln('    data[\'$key\'] = this.$key;');
  //         }
  //       } catch (e) {
  //         print('Error in toJson for $key: $e');
  //       }
  //     });
  //   }
  //   stringBuffer.writeln('    return data;');
  //   stringBuffer.writeln('  }');

  //   stringBuffer.writeln('}');

  //   // Cache the generated class
  //   classCache[className] = stringBuffer.toString();

  //   // Generate additional classes for nested types
  //   typeMap.forEach((key, type) {
  //     if (type.startsWith('List<') || type.startsWith('Map<')) {
  //       String nestedClassName = _getNestedClassName(type);
  //       if (nestedClassName.isNotEmpty) {
  //         dynamic nestedJson = {};
  //         if (json is Map && json[key] is List && (json[key] as List).isNotEmpty) {
  //           nestedJson = (json[key] as List).first;
  //         } else if (json is Map && json[key] is Map) {
  //           nestedJson = json[key];
  //         }
  //         if (nestedJson.isNotEmpty) {
  //           _generateModelClass(nestedClassName, nestedJson);
  //         }
  //       }
  //     }
  //   });
  // }

  // String _getDartType(dynamic value, Map<String, String> typeMap) {
  //   if (value is String) return 'String';
  //   if (value is int) return 'int';
  //   if (value is double) return 'double';
  //   if (value is bool) return 'bool';
  //   if (value is List) {
  //     if (value.isNotEmpty) {
  //       String itemType = _getDartType(value.first, typeMap);
  //       typeMap['List<dynamic>'] = 'List<$itemType>';
  //       return 'List<$itemType>';
  //     }
  //     return 'List<dynamic>';
  //   }
  //   if (value is Map) {
  //     String nestedClassName = 'NestedClass${classCache.length + 1}';
  //     typeMap['Map<String, dynamic>'] = nestedClassName;
  //     return nestedClassName;
  //   }
  //   return 'dynamic';
  // }

  // String _getNestedClassName(String type) {
  //   RegExp regExp = RegExp(r'List<(\w+)>|Map<(\w+)>');
  //   Match? match = regExp.firstMatch(type);
  //   if (match != null) {
  //     return match.group(1) ?? match.group(2) ?? '';
  //   }
  //   return '';
  // }
}
