import 'package:hive/hive.dart';

void putToTheStorage(var key, var value) {
  var box = Hive.box('storage');
  box.put(key, value);
}

dynamic getValue(var key) {
  var box = Hive.box('storage');
  return box.get(key);
}

void clearUserData() {
  var box = Hive.box('storage');
  box.delete('username');
  box.delete('password');
}