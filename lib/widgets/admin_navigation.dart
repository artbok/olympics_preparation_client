// Обновляем admin_navigation.dart
import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/admin/admin_tasks_page.dart';
import 'package:olympics_preparation_client/user/duels/matchmaking_page.dart';
import 'package:olympics_preparation_client/user/authorization/login_page.dart';
import 'package:olympics_preparation_client/admin/admin_stats_page.dart'; // Добавляем импорт

void _onDestinationSelected(BuildContext context, int index) {
  Widget? page;
  switch (index) {
    case 0:
      page = const AdminTasksPage();
      break;
    case 1:
      page = const MatchmakingPage();
      break;
    case 2:
      page = const AdminStatsPage(); // Добавляем новую страницу
      break;
  }
  if (page != null) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page!,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

// В admin_navigation.dart обновляем функцию scaffoldWithAdminNavigation
Widget scaffoldWithAdminNavigation(
  int curPage,
  BuildContext context,
  PreferredSizeWidget? appBar,
  Widget body,
  [Widget? floatingActionButton]
) {
  if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Задачи'),
          NavigationDestination(icon: Icon(Icons.sports_mma), label: 'Дуэли'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Статистика'),
        ],
        selectedIndex: curPage,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
      ),
      body: body,
    );
  }
  return Scaffold(
    appBar: appBar,
    body: Row(
      children: [
        Column(
          children: [
            Expanded(
              child: NavigationRail(
                selectedIndex: curPage,
                groupAlignment: -1.0,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (index) =>
                    _onDestinationSelected(context, index),
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.list_alt),
                    label: Text('Задачи'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_mma),
                    label: Text('Дуэли'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Статистика'),
                  ),
                ],
              ),
            ),
            const Divider(),
            IconButton(
              icon: const Icon(Icons.logout, size: 40),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
        Expanded(child: body),
      ],
    ),
    floatingActionButton: floatingActionButton,
  );
}