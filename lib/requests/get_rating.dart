import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<int> getRating(String username) async {
  Map<String, dynamic> params = {"username": username};

  final Uri url = Uri.parse('${getValue("serverAddress")}/getRating');

  final response = await http.post(
    url,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["rating"];
}
