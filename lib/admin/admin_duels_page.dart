import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/widgets/admin_navigation.dart';

class AdminDuelsPage extends StatefulWidget {
  const AdminDuelsPage({super.key});

  @override
  _AdminDuelsPageState createState() => _AdminDuelsPageState();
}

class _AdminDuelsPageState extends State<AdminDuelsPage> {
  List<Map<String, dynamic>> duels = [];
  bool isLoading = true;
  String? errorMessage;
  Set<int> cancellingDuelIds = {}; 

  @override
  void initState() {
    super.initState();
    fetchDuels();
  }

  Future<void> fetchDuels() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get-duels'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        
        List<Map<String, dynamic>> parsedDuels = [];
        
        if (data is List) {
          for (var item in data) {
            if (item is Map) {
              Map<String, dynamic> convertedItem = {};
              item.forEach((key, value) {
                convertedItem[key.toString()] = value;
              });
              parsedDuels.add(convertedItem);
            }
          }
        } else if (data is Map) {
          Map<String, dynamic> singleItem = {};
          data.forEach((key, value) {
            singleItem[key.toString()] = value;
          });
          parsedDuels = [singleItem];
        }

        setState(() {
          duels = parsedDuels;
          isLoading = false;
        });
        
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> cancelDuel(int duelId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение отмены'),
        content: Text('Вы уверены, что хотите отменить дуэль #$duelId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Нет'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Да, отменить'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      cancellingDuelIds.add(duelId);
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/cancel-duel'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'duel_id': duelId}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Дуэль #$duelId успешно отменена'),
            backgroundColor: Colors.green,
          ),
        );
        await fetchDuels(); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? 'Ошибка при отмене дуэли'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сети: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        cancellingDuelIds.remove(duelId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return scaffoldWithAdminNavigation(
      3,
      context,
      AppBar(
        title: const Text('Управление дуэлями'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchDuels,
          ),
        ],
      ),
      Center(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchDuels,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  )
                : duels.isEmpty
                    ? const Center(child: Text('Нет дуэлей'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: duels.length,
                        itemBuilder: (context, index) {
                          final duel = duels[index];
                          final duelId = duel['duel_id'] ?? 0;
                          final isCancelled = duel['is_cancelled'] == true;
                          final isCancelling = cancellingDuelIds.contains(duelId);
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30, 
                              vertical: 5
                            ), 
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCancelled 
                                    ? Colors.grey[300] 
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: isCancelled
                                    ? Border.all(color: Colors.red, width: 1)
                                    : null,
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${duel['username1']} vs ${duel['username2']}',
                                        style: TextStyle(
                                          decoration: isCancelled 
                                              ? TextDecoration.lineThrough 
                                              : null,
                                          color: isCancelled 
                                              ? Colors.grey[600] 
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (isCancelled)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8, 
                                          vertical: 2
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Отменена',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  'Результат: ${duel['score1']} - ${duel['score2']}',
                                  style: TextStyle(
                                    decoration: isCancelled 
                                        ? TextDecoration.lineThrough 
                                        : null,
                                    color: isCancelled 
                                        ? Colors.grey[600] 
                                        : null,
                                  ),
                                ),
                                trailing: isCancelled
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.grey,
                                      )
                                    : isCancelling
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => cancelDuel(duelId),
                                            tooltip: 'Отменить дуэль',
                                          ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}