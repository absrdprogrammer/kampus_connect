import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kampus_connect/widgets/my_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController universityNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String fullNameUser = '';
  String universityName = '';
  String emailUser = '';
  String passwordUser = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 40, right: 15),
        child: ListView(
          children: [
            Center(
              child: Stack(children: [
                Container(
                  width: 130.0,
                  height: 130.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        image: AssetImage("assets/images/hello-image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.white),
                        color: Colors.blue),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  MyTextField(
                    prefixIcon: Icons.person_2_outlined,
                    hintText: "Input Your Username",
                    labelText: "Username",
                    controller: fullNameController,
                    obscureText: false,
                    onTextChanged: (value) {
                      setState(() {
                        fullNameUser = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    prefixIcon: CupertinoIcons.building_2_fill,
                    hintText: "Input Your University",
                    labelText: "University",
                    controller: fullNameController,
                    obscureText: false,
                    onTextChanged: (value) {
                      setState(() {
                        fullNameUser = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    prefixIcon: Icons.email_outlined,
                    hintText: "Input Your Email",
                    labelText: "Email",
                    controller: fullNameController,
                    obscureText: false,
                    onTextChanged: (value) {
                      setState(() {
                        fullNameUser = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    prefixIcon: Icons.lock_outline,
                    hintText: "Input Your Password",
                    labelText: "Password",
                    controller: fullNameController,
                    obscureText: false,
                    onTextChanged: (value) {
                      setState(() {
                        fullNameUser = value;
                      });
                    },
                  ),
                  const SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      )),
                      const Gap(20),
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {},
                        child: const Text('Update'),
                      )),
                    ],
                  )
                ],
              ),
              
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
