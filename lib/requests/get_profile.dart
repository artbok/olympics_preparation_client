import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/localstorage.dart';

Future<Map<String, dynamic>> getProfile(String username) async {
    Map<String, dynamic> params = {"username": username};

    final serverAddress = getValue("serverAddress");

    final Uri url = Uri.parse('$serverAddress/getProfile');
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(params),
    );
  
    Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
    
}