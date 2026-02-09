// lib/requests/get_admin_stats.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<List<dynamic>> getAdminStats() async {
  final username = getValue("username");
  final password = getValue("password");
  
  final params = {
    "username": username,
    "password": password,
  };
  
  final Uri url = Uri.parse('${getValue("serverAddress")}/admin/stats');
  
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode(params),
  );
  
  if (response.statusCode != 200) {
    throw Exception('Ошибка сервера: ${response.statusCode}');
  }
  
  final dynamic data = jsonDecode(response.body);
  
  if (data is List) {
    return data;
  } else if (data is Map && data.containsKey('status') && data['status'] == 'access_denied') {
    throw Exception('Доступ запрещен');
  } else {
    throw Exception('Неожиданный формат данных');
  }
}