import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';
import 'package:olympics_preparation_client/user/pages/admin_registration_page.dart';
import 'package:olympics_preparation_client/requests/create_user.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';
import 'package:olympics_preparation_client/user/pages/first_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String status = "";
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text("Регистрация", style: textThemes.titleLarge),
            ),
            Expanded(flex: 2, child: Container()),
            Flexible(
              flex: 1,
              child: Text("Имя пользователя", style: textThemes.bodyMedium),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 2, child: Container()),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(flex: 2, child: Container()),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Text("Пароль", style: textThemes.bodyMedium),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 2, child: Container()),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
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
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(flex: 2, child: Container()),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: button(
                Text("Зарегистрироваться", style: textThemes.bodyMedium),
                () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  Map<String, dynamic> data = await createUser(
                    username,
                    password,
                    1,
                  );
                  setState(() {
                    if (data["status"] == "ok") {
                      putToTheStorage("username", username);
                      putToTheStorage("password", password);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const FirstPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else {
                      showIncorrectDataAlert(
                          context,
                          const Text(
                              "Пользователь с таким именем уже существует"));
                    }
                  });
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                child: Text("Уже есть аккаунт?", style: textThemes.bodyLarge),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const LoginPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ),
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const AdminRegistrationPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Text(
                    "Регистрация для админов",
                    style: textThemes.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
