import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<Map<String, dynamic>> getTasks(String username, String password, List<String> selectedDifficulties, List<String> selectedTopics, int page) async {
  Map<String, dynamic> params = {"username": username, "password": password, "page": page, "selectedDifficulties": selectedDifficulties, "selectedTopics": selectedTopics};

  final Uri url = Uri.parse('${getValue("serverAddress")}/getTasks');

  final response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}