import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/user/pages/registration_page.dart';
import 'package:olympics_preparation_client/requests/auth_user.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/widgets/background.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';
import 'package:olympics_preparation_client/widgets/root.dart';

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
    final colors = Theme.of(context).colorScheme;
    final textThemes = Theme.of(context).textTheme;
    Icon icon = const Icon(Icons.visibility_off);
    if (obscureText) {
      icon = const Icon(Icons.visibility);
    }
    return Scaffold(
      backgroundColor: colors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Авторизация", style: textThemes.titleLarge),
            Text("Имя пользователя", style: textThemes.bodyLarge),
            SizedBox(
              width: 300,
              child: TextFormField(
                maxLength: 16,
                controller: usernameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ),
            Text("Пароль", style: textThemes.bodyLarge),
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
                    },
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ),
            Container(),
            button(Text("Войти", style: textThemes.titleLarge), () async {
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
                      "Пароль или Имя пользователя введены некорректно",
                    ),
                  );
                }
              });
            }),
            InkWell(
              child: Text("Нет аккаунта?", style: textThemes.titleLarge),
              onTap: () => {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const RegistrationPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
