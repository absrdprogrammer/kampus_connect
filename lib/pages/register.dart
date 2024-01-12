import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kampus_connect/helper/helper_function.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/widgets/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String username = '';
  String emailText = '';
  String passwordText = '';
  String confirmPassword = '';

  Future<void> registerUser() async {
    // print(
    //     "Username : $username, Email : $emailText, Password: $passwordText, Confirm Password: $confirmPassword");
    // show loading circle
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // make sure password match
    if (passwordText != confirmPassword) {
      // pop loading circle
      Navigator.pop(context);

      // show error message user
      displayMessageToUser("Password don't match", context);
    }
    // try creating the user
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailText, password: passwordText);

      await userCredential.user?.updateDisplayName(username);

      // create user document and add to firestore
      createUserDocument(userCredential, username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  Future<void> createUserDocument(
      UserCredential? userCredential, String username) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'role': 'user',
        'email': userCredential.user!.email,
        'username': username,
        'profileImg':
            'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: constraints.maxWidth > 350 ? 350 : 200,
                  child: Stack(children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/hello-image.png',
                        height: constraints.maxWidth > 400 ? 400 : 200,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Nama TextField
                MyTextField(
                  prefixIcon: Icons.person_2_outlined,
                  hintText: "Input name",
                  labelText: "Username",
                  controller: usernameController,
                  obscureText: false,
                  onTextChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Email TextField
                MyTextField(
                  prefixIcon: Icons.email_outlined,
                  hintText: "Input email",
                  labelText: "Email",
                  controller: emailController,
                  obscureText: false,
                  onTextChanged: (value) {
                    setState(() {
                      emailText = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Password TextField
                MyTextField(
                  prefixIcon: Icons.lock_outline,
                  hintText: "Input password",
                  labelText: "Password",
                  controller: passwordController,
                  obscureText: true,
                  onTextChanged: (value) {
                    setState(() {
                      passwordText = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Confirm Password TextField
                MyTextField(
                  prefixIcon: Icons.lock_outline,
                  hintText: "Input password again",
                  labelText: "Confirm password",
                  controller: confirmController,
                  obscureText: true,
                  onTextChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: registerUser,
                  height: 45,
                  color: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          )),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
