import 'dart:convert';

import 'package:flutter/material.dart';

class ConvertHelpers {
  bool checkIsJsonValid(String data) {
    try {
      var obj = jsonDecode(data);
      print("VALID JSON");
      return true;
    } catch (e) {
      print("INVALID JSON");
      return false;
    }
  }

  void showSnackBar(String msg, BuildContext context, int type) {
    // TYPES
    /*
    1 - Green Success 
    2 - Red Something Went Wrong / Conversion Failed
    */
    print("SNACKBAR");
    Color textColor = Colors.white;
    Color bgColor = Colors.redAccent;
    if (type == 1) {
      bgColor = Colors.green;
    }
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

Map<String, String> classCache = {};

String generateModelClasses(String rootClassName, Map<String, dynamic> json) {
  classCache.clear();
  _generateModelClass(rootClassName, json);
  return classCache.values.join('\n\n');
}

void _generateModelClass(String className, Map<String, dynamic> json) {
  if (classCache.containsKey(className)) return;

  StringBuffer buffer = StringBuffer();
  Map<String, String> typeMap = {};

  // Start the class
  buffer.writeln('class $className {');

  // Generate class properties
  json.forEach((key, value) {
    try {
      String type = _getDartType(value, typeMap);
      buffer.writeln('  $type? $key;');
    } catch (e) {
      print('Error generating property for $key: $e');
    }
  });

  // Constructor
  buffer.writeln();
  buffer.writeln('  $className({');
  json.forEach((key, value) {
    buffer.writeln('    this.$key,');
  });
  buffer.writeln('  });');

  // From JSON
  buffer.writeln();
  buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  json.forEach((key, value) {
    try {
      String type = typeMap[key]!;
      if (type.startsWith('List<')) {
        buffer.writeln('      $key: json[\'$key\'] != null ? (json[\'$key\'] as List).map((i) => ${_getNestedClassName(type)}.fromJson(i as Map<String, dynamic>)).toList() : null,');
      } else if (type.startsWith('Map<')) {
        buffer.writeln('      $key: json[\'$key\'] != null ? ${_getNestedClassName(type)}.fromJson(json[\'$key\'] as Map<String, dynamic>) : null,');
      } else {
        buffer.writeln('      $key: json[\'$key\'],');
      }
    } catch (e) {
      print('Error in fromJson for $key: $e');
    }
  });
  buffer.writeln('    );');
  buffer.writeln('  }');

  // To JSON
  buffer.writeln();
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    final Map<String, dynamic> data = <String, dynamic>{};');
  json.forEach((key, value) {
    try {
      String type = typeMap[key]!;
      if (type.startsWith('List<')) {
        buffer.writeln('    if (this.$key != null) {');
        buffer.writeln('      data[\'$key\'] = this.$key!.map((v) => v.toJson()).toList();');
        buffer.writeln('    }');
      } else if (type.startsWith('Map<')) {
        buffer.writeln('    if (this.$key != null) {');
        buffer.writeln('      data[\'$key\'] = this.$key!.toJson();');
        buffer.writeln('    }');
      } else {
        buffer.writeln('    data[\'$key\'] = this.$key;');
      }
    } catch (e) {
      print('Error in toJson for $key: $e');
    }
  });
  buffer.writeln('    return data;');
  buffer.writeln('  }');

  buffer.writeln('}');

  // Cache the generated class
  classCache[className] = buffer.toString();

  // Generate additional classes for nested types
  typeMap.forEach((key, type) {
    if (type.startsWith('List<') || type.startsWith('Map<')) {
      String nestedClassName = _getNestedClassName(type);
      if (nestedClassName.isNotEmpty) {
        Map<String, dynamic> nestedJson = {};
        if (json[key] is List && (json[key] as List).isNotEmpty) {
          nestedJson = (json[key] as List).first as Map<String, dynamic>;
        } else if (json[key] is Map) {
          nestedJson = json[key] as Map<String, dynamic>;
        }
        if (nestedJson.isNotEmpty) {
          _generateModelClass(nestedClassName, nestedJson);
        }
      }
    }
  });
}

String _getDartType(dynamic value, Map<String, String> typeMap) {
  if (value is String) return 'String';
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is List) {
    if (value.isNotEmpty) {
      String itemType = _getDartType(value.first, typeMap);
      typeMap['List<dynamic>'] = 'List<$itemType>';
      return 'List<$itemType>';
    }
    return 'List<dynamic>';
  }
  if (value is Map) {
    String nestedClassName = 'NestedClass${classCache.length + 1}';
    typeMap['Map<String, dynamic>'] = nestedClassName;
    return nestedClassName;
  }
  return 'dynamic';
}

String _getNestedClassName(String type) {
  RegExp regExp = RegExp(r'List<(\w+)>|Map<(\w+)>');
  Match? match = regExp.firstMatch(type);
  if (match != null) {
    return match.group(1) ?? match.group(2) ?? '';
  }
  return '';
}
}
