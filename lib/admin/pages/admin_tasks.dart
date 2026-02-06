import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const TaskUploaderApp());

class TaskUploaderApp extends StatelessWidget {
  const TaskUploaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Загрузчик задач',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UploadPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isLoading = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  
  // ЗАМЕНИТЕ НА ВАШ РЕАЛЬНЫЙ URL!
  static const String SERVER_URL = 'http://127.0.0.1:5000';

  Future<void> _uploadJson() async {
    setState(() => _isLoading = true);

    try {
      // 1. Выбор файла
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        _showMessage('Отменено пользователем', isError: true);
        return;
      }

      PlatformFile file = result.files.first;
      if (file.size != null && file.size! > 1024 * 1024) {
        _showMessage('Файл слишком большой (макс. 1 МБ)', isError: true);
        return;
      }

      // 2. Чтение JSON
      String jsonString = await file.readAsString();
      json.decode(jsonString); // Проверка валидности

      // 3. Отправка на сервер
      final response = await http.post(
        Uri.parse(SERVER_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      ).timeout(const Duration(seconds: 15));

      // 4. Обработка ответа
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage('✅ Задача успешно добавлена!', isError: false);
      } else {
        String error = 'Сервер отклонил задачу';
        try {
          final body = json.decode(response.body);
          if (body['error'] != null) error = 'Ошибка: ${body['error']}';
        } catch (_) {}
        _showMessage(error, isError: true);
      }
    } catch (e) {
      String msg = 'Ошибка подключения';
      if (e is TimeoutException) msg = 'Таймаут: сервер не отвечает';
      if (e is FormatException) msg = 'Невалидный JSON';
      _showMessage(msg, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Загрузчик задач')),
      body: Center(
        child: SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _uploadJson,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.upload_file, size: 24),
                label: Text(_isLoading ? 'Отправка...' : 'Загрузить JSON'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}