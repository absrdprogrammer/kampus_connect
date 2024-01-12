import 'package:flutter/material.dart';
import 'package:kampus_connect/pages/login.dart';

class IdeasTile extends StatelessWidget {
  final String title;
  final String subTitle;
  Color? color;
  IdeasTile({super.key, required this.title, required this.subTitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(subTitle),
        ),
      ),
    );
  }
}
