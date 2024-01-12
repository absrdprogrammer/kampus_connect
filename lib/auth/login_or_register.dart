import 'package:flutter/material.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/pages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      togglePages();
      return const LoginPage();
    } else {
      togglePages();
      return const RegisterPage();
    }
  }
}
