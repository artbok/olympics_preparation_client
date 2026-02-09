import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/widgets/admin_navigation.dart';


class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isLoading = false;

  static const String SERVER_URL = 'http://127.0.0.1:5000/upload';

  Future<void> _uploadJson() async {
    setState(() => _isLoading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
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

      if (file.bytes == null) {
        throw Exception('Не удалось прочитать содержимое файла');
      }

      String jsonString;
      try {
        jsonString = utf8.decode(file.bytes!);
      } catch (e) {
        throw FormatException('Некорректная кодировка UTF-8 в файле');
      }

      try {
        json.decode(jsonString);
      } catch (e) {
        throw FormatException('Невалидный JSON: ${e.toString()}');
      }

      final response = await http
          .post(
            Uri.parse(SERVER_URL),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonString,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage('✅ Задача успешно добавлена!', isError: false);
      } else {
        String error = 'Сервер вернул ошибку (${response.statusCode})';
        try {
          final body = json.decode(response.body);
          if (body is Map && body['error'] != null) {
            error = 'Ошибка сервера: ${body['error']}';
          }
        } catch (_) {}
        _showMessage(error, isError: true);
      }
    } on TimeoutException catch (_) {
      _showMessage('Таймаут: сервер не отвечает (15 сек)', isError: true);
    } on FormatException catch (e) {
      _showMessage('Невалидный JSON: ${e.message}', isError: true);
    } catch (e) {
      _showMessage('Ошибка: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Закрыть',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textThemes = Theme.of(context).textTheme;
    
    return scaffoldWithAdminNavigation(
      2, 
      context,
      AppBar(
        title: const Text('Загрузчик задач'),
        titleTextStyle: textThemes.bodyLarge,
      ),
      Center(
        child: SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Загрузите JSON-файл с задачей',
                        textAlign: TextAlign.center,
                        style: textThemes.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _uploadJson,
                        icon: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 226, 226, 226),
                                  ),
                                ),
                              )
                            : const Icon(Icons.file_upload, size: 24),
                        label: Text(
                          _isLoading ? 'Отправка...' : 'Выбрать файл',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          backgroundColor: const Color.fromARGB(
                            255,
                            220,
                            220,
                            220,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Макс. размер: 1 МБ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
