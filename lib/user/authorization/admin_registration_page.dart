import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/admin/admin_tasks_page.dart';
import 'package:olympics_preparation_client/user/authorization/login_page.dart';
import 'package:olympics_preparation_client/requests/create_user.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';


class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
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
            Text(
              "Регистрация для администратора",
              style: textThemes.titleLarge,
            ),
            Expanded(flex: 2, child: Container()),
            Text("Имя пользователя", style: textThemes.bodyMedium),
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
            Text("Пароль", style: textThemes.bodyMedium),

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
            button(
              Text("Зарегистроваться", style: textThemes.bodyMedium),
              () async {
                String username = usernameController.text;
                String password = passwordController.text;
                Map<String, dynamic> data = await createUser(
                  username,
                  password,
                  2,
                );
                setState(() {
                  if (data["status"] == 'ok') {
                    putToTheStorage("username", username);
                    putToTheStorage('password', password);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const AdminTasksPage(),
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
            Flexible(
              flex: 5,
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
            Flexible(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }
}
