import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/helper/helper_function.dart';
import 'package:kampus_connect/pages/chat_detail_page.dart';
import 'package:kampus_connect/pages/home.dart';
import 'package:kampus_connect/pages/home_screen.dart';
import 'package:kampus_connect/pages/register.dart';
import 'package:kampus_connect/widgets/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailUser = '';
  String passwordUser = '';

  void login() async {
    // show loading circle
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailUser,
        password: passwordUser,
      );

      // pop loading circle
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InformationPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }

      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 350,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/welcome-image.png',
                    height: 400,
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              prefixIcon: Icons.email_outlined,
              hintText: "Input email",
              labelText: "Email",
              controller: emailController,
              obscureText: false,
              onTextChanged: (value) {
                setState(() {
                  emailUser = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              prefixIcon: Icons.lock_outline,
              hintText: "Input password",
              labelText: "Password",
              controller: passwordController,
              obscureText: true,
              onTextChanged: (value) {
                setState(() {
                  passwordUser = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: login,
              height: 45,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                    letterSpacing: 5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () => nextPage(context, const RegisterPage()),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
