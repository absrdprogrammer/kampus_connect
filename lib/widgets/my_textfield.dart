import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final ValueChanged<String>? onTextChanged;
  final IconData prefixIcon; 

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.obscureText,
    required this.onTextChanged,
    required this.prefixIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      cursorColor: Colors.black,
      onChanged: onTextChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(
          letterSpacing: 1,
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          prefixIcon, 
          color: Colors.black,
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
