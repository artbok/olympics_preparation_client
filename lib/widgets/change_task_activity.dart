import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<Map<String, dynamic>> editTaskActivity(int taskId, String status) async {
  String username = getValue("username");
  String password = getValue("password");
  Map<String, dynamic> params = {
    "taskId": taskId,
    "status": status,
    "username": username,
    "password": password,
  };
  final Uri url = Uri.parse(
    '${getValue("serverAddress")}/editTaskActivity',
  );
  final response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
