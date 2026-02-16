import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/admin/admin_tasks_page.dart';
import 'package:olympics_preparation_client/user/authorization/login_page.dart';
import 'package:olympics_preparation_client/admin/admin_stats_page.dart';
import 'package:olympics_preparation_client/admin/upload_tasks_page.dart';
import 'package:olympics_preparation_client/admin/admin_duels_page.dart';

void _onDestinationSelected(BuildContext context, int index) {
  Widget? page;
  switch (index) {
    case 0:
      page = const AdminTasksPage();
      break;
    case 1:
      page = const AdminStatsPage();
      break;
    case 2:
      page = const UploadPage();
      break;
    case 3:
      page = const AdminDuelsPage();
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

Widget scaffoldWithAdminNavigation(
  int curPage,
  BuildContext context,
  PreferredSizeWidget? appBar,
  Widget body, [
  Widget? floatingActionButton,
]) {
  if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Задачи'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Статистика'),
          NavigationDestination(
            icon: Icon(Icons.upload_file),
            label: 'Загрузка',
          ),
          NavigationDestination(icon: Icon(Icons.one_k_sharp), label: 'Дуэли'),
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
                    icon: Icon(Icons.people),
                    label: Text('Статистика'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.upload_file),
                    label: Text('Загрузка'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.one_k_sharp),
                    label: Text('Дуэли'),
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
