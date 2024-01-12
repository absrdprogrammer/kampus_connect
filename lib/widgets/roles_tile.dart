import 'package:flutter/material.dart';
import 'package:kampus_connect/pages/login.dart';

class RolesTile extends StatelessWidget {
  final String title;
  final String imagePath;
  const RolesTile({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          )),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          leading: Image.asset(imagePath),
          trailing: const Icon(Icons.arrow_forward_sharp),
        ),
      ),
    );
  }
}
