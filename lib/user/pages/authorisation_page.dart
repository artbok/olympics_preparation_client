import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/user/pages/registration_page.dart';
import 'package:olympics_preparation_client/requests/auth_user.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/widgets/background.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Icon icon = const Icon(Icons.visibility_off);
    if (obscureText) {
      icon = const Icon(Icons.visibility);
    }
    return Scaffold(
        body: background1(Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Авторизация",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const Text(
              "Имя пользователя",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                maxLength: 16,
                controller: usernameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                ),
              ),
            ),
            const Text("Пароль",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Container(),
            SizedBox(
              width: 300,
              child: TextFormField(
                maxLength: 20,
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: icon,
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      }),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                ),
              ),
            ),
            Container(),
            button(
              const Text(
                "Войти",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              () async {
                String username = usernameController.text;
                String password = passwordController.text;
                Map<String, dynamic> data = await authUser(username, password);
                setState(() {
                  if (data["status"] == 'ok') {
                    putToTheStorage("username", username);
                    putToTheStorage('password', password);
                    // if (data["rightsLevel"] == 1) {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder: (context, animation1, animation2) =>
                    //           const UserStoragePage(),
                    //       transitionDuration: Duration.zero,
                    //       reverseTransitionDuration: Duration.zero,
                    //     ),
                    //   );
                    // } else {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder: (context, animation1, animation2) =>
                    //           const StoragePage(),
                    //       transitionDuration: Duration.zero,
                    //       reverseTransitionDuration: Duration.zero,
                    //     ),
                    //   );
                    // }
                  } else {
                    showIncorrectDataAlert(
                        context,
                        const Text(
                            "Пароль или Имя пользователя введены некорректно"));
                  }
                });
              },
            ),
            InkWell(
              child: const Text(
                "Нет аккаунта?",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () => {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const RegistrationPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                )
              },
            )
          ]),
    )));
  }
}