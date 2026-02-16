import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<Map<String, dynamic>> createTask(
  String taskDescription,
  String taskSubject,
  String taskDifficulty,
  String taskHint,
  String taskAnswer,
  String taskExplanation,
  String taskTopic,
) async {
  String username = getValue("username");
  String password = getValue("password");
  Map<String, dynamic> params = {
    "description": taskDescription,
    "subject": taskSubject,
    "difficulty": taskDifficulty,
    "hint": taskHint,
    "answer": taskAnswer,
    "explanation": taskExplanation,
    "topic": taskTopic,
    "username": username,
    "password": password,
  };
  final Uri url = Uri.parse('${getValue("serverAddress")}/newTask');
  final response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
