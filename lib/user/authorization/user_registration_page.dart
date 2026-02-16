import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/user/authorization/login_page.dart';
import 'package:olympics_preparation_client/user/authorization/admin_registration_page.dart';
import 'package:olympics_preparation_client/requests/create_user.dart';
import 'package:olympics_preparation_client/user/user_tasks_page.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';

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
            Text("Регистрация", style: textThemes.titleLarge),
            Column(
              children: [
                Text("Имя пользователя", style: textThemes.bodyMedium),
                SizedBox(
                  width: 380,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("Пароль", style: textThemes.bodyMedium),
                SizedBox(
                  width: 380,
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
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            button(
              Text("Зарегистрироваться", style: textThemes.bodyLarge),
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
                            const UserTasksPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  } else {
                    showIncorrectDataAlert(
                      context,
                      const Text("Пользователь с таким именем уже существует"),
                    );
                  }
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
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
                Align(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
