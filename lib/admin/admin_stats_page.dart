import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/requests/get_admin_stats.dart';
import 'package:olympics_preparation_client/widgets/admin_navigation.dart';
import 'package:olympics_preparation_client/admin/edit_user_dialog.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({super.key});

  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  @override
  Widget build(BuildContext context) {
    return scaffoldWithAdminNavigation(
      1,
      context,
      AppBar(
        title: const Text('Статистика пользователей'),
      ),
      FutureBuilder<List<dynamic>>(
        future: getAdminStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("error");
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Нет данных о пользователях',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) =>
                  _buildUserItem(users[index], index),
          );
        },
      ),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        title: Text(
          user['username'].toString(),
          style: textTheme.bodyLarge,
        ),
        subtitle: Row(
          children: [
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildStatChip('Рейтинг: ${user['rating'] ?? 0}', Colors.blue),
                      _buildStatChip('Верно: ${user['solved_correctly'] ?? 0}', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildStatChip('Всего: ${user['solved_total'] ?? 0}', Colors.grey),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_double_arrow_up),
              onPressed: () {changedUserDialog(context, user['username'], () => setState(() {}));}
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {deleteUserDialog(context, user['username'], () => setState(() {}));}
            ),
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
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}