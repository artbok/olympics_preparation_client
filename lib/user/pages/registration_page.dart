import 'package:flutter/material.dart';
import 'package:flutter_application_1/user/pages/authorisation_page.dart';
import 'package:flutter_application_1/user/pages/admin_registration_page.dart';
import 'package:flutter_application_1/localstorage.dart';
import 'package:flutter_application_1/requests/create_user.dart';
import 'package:flutter_application_1/widgets/background.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/show_alert.dart';

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
    Icon icon = const Icon(Icons.visibility_off);
    if (obscureText) {
      icon = const Icon(Icons.visibility);
    }

    return Scaffold(
        body: background1(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Flexible(
              child: Text("Регистрация",
                  style: TextStyle(
                    fontSize: 40,
                  )),
            ),
            Expanded(flex: 2, child: Container()),
            const Flexible(
              flex: 1,
              child: Text(
                "Имя пользователя",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 2, child: Container()),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      maxLength: 16,
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                  ),
                  Flexible(flex: 2, child: Container())
                ],
              ),
            ),
            const Flexible(
              flex: 1,
              child: Text("Пароль",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 1,
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: button(
                const Text("Зарегистрироваться",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  Map<String, dynamic> data =
                      await createUser(username, password, 1);
                  setState(() {
                    // if (data["status"] == "ok") {
                    //   putToTheStorage("username", username);
                    //   putToTheStorage("password", password);
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
                    //   showIncorrectDataAlert(
                    //       context,
                    //       const Text(
                    //           "Пользователь с таким именем уже существует"));
                    // }
                  });
                },
              ),
            ),
            Flexible(
                flex: 1,
                child: InkWell(
                  child: const Text("Уже есть аккаунт?",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const LoginPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  },
                )),
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
                    child: const Text("Регистрация для админов",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}