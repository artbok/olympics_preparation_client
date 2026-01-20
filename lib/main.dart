import 'package:flutter/material.dart';
import 'redirectPage.dart';
import 'package:hive_flutter/adapters.dart';
import 'localstorage.dart';

const String serverAddress = "http://127.0.0.1:5000";


void main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  putToTheStorage("serverAddress", serverAddress);
  runApp(const RedirectPage());
}