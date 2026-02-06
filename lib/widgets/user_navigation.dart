import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/user/pages/user_tasks_page.dart';
import 'package:olympics_preparation_client/user/pages/duels/matchmaking_page.dart';
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';

void _onDestinationSelected(BuildContext context, int index) {
  Widget? page;
  switch (index) {
    case 0:
      page = const UserTasksPage();
    case 1:
      page = const MatchmakingPage();
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

Widget scaffoldWithUserNavigation(
    int curPage, BuildContext context, Widget body) {
  if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Задачи',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_mma,),
            label: 'Дуэли',
          ),
        ],
        selectedIndex: curPage,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
      ),
      body:  body
    );
  }
  return Scaffold(
      body: Row(children: [
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
        const SizedBox(height: 10)
      ],
    ),
    Expanded(child: body)
  ]));
}
