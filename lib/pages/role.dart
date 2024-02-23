import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampus_connect/widgets/roles_tile.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          Text(
            "Choose your role",
            style: TextStyle(
              fontSize: 23,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
              child: ListView(
            children: const [
              RolesTile(
                  title: "Student",
                  imagePath: 'assets/images/student-image.png'),
                  RolesTile(
                  title: "Company",
                  imagePath: 'assets/images/company-image.png'),
              // RolesTile(
              //     title: "Lecturer",
              //     imagePath: 'assets/images/teacher-image.png'),
              // RolesTile(
              //     title: "Admin", imagePath: 'assets/images/admin-image.png')
            ],
          ))
        ]),
      )),
    );
  }
}
