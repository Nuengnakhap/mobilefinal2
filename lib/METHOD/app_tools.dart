import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

writeDataLocally({String key, String value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

removeDataLocally(String key) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.remove(key);
}

Future<String> getDataLocally(String key) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key) ?? '';
}

// หา application path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// สร้าง file
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

// write ลง file
Future<File> writeData(String data) async {
  final file = await _localFile;
  return file.writeAsString('$data');
}

// read จาก file
Future<String> readData() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return '';
  }
}

