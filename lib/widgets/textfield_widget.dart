import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.maxLine,
      required this.hintText,
      required this.controller,
      required this.onTextChanged})
      : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController controller;
  final ValueChanged<String>? onTextChanged;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          onChanged: widget.onTextChanged,
          maxLines: widget.maxLine,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: widget.hintText,
          ),
        ));
  }
}
