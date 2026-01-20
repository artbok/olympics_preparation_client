import 'package:flutter/material.dart';
import 'localstorage.dart';
import 'package:olympics_preparation_client/requests/auth_user.dart';
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';


class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});


  Future<Widget> checkAuth() async {
    String? username = getValue("username");
    String? password = getValue("password");
    if (username != null && password != null) {
      Map<String, dynamic> data = await authUser(username, password);
      if (data["status"] == 'ok') {
        // if (data["rightsLevel"] == 1) {
        //   return const UserStoragePage();
        // } else {
        //   return const StoragePage();
        // }
      }
    }
    return const LoginPage();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Управление спортивным инвентарем',
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: checkAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Ошибка: ${snapshot.error}');
            }
            {
              return snapshot.data!;
            }
          },
        ));
  }
}