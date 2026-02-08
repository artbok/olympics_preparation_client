import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'localstorage.dart';
import 'package:olympics_preparation_client/root.dart';

const String serverAddress = "http://127.0.0.1:5000";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  putToTheStorage("serverAddress", serverAddress);
  clearUserData();
  runApp(const Root());
}
