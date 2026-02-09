// lib/admin/admin_stats_page.dart
import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/requests/get_admin_stats.dart';
import 'package:olympics_preparation_client/widgets/admin_navigation.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({super.key});

  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final response = await getAdminStats();
      setState(() {
        users = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildUserItem(Map<String, dynamic> user, int index) {
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          user['username'].toString(),
          style: textTheme.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatChip('Рейтинг: ${user['rating'] ?? 0}', Colors.blue),
                const SizedBox(width: 8),
                _buildStatChip('Верно: ${user['solved_correctly'] ?? 0}', Colors.green),
              ],
            ),
            const SizedBox(height: 4),
            _buildStatChip('Всего: ${user['solved_total'] ?? 0}', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldWithAdminNavigation(
      2,
      context,
      AppBar(
        title: const Text('Статистика пользователей'),
        actions: [
        ],
      ),
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        error,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadStats,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : users.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Нет данных о пользователях',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadStats,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) => 
                            _buildUserItem(users[index], index),
                      ),
                    ),
    );
  }
}