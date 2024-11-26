import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ICMInputText extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final bool? isPassword;
  final TextInputType? inputDecoration;
  final List<TextInputFormatter>? inputFormatters;

  const ICMInputText({
    super.key,
    required this.controller,
    required this.title,
    this.isPassword,
    this.inputDecoration,
    this.inputFormatters,
  });

  @override
  State<ICMInputText> createState() => _ICMInputTextState();
}

class _ICMInputTextState extends State<ICMInputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputDecoration,
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      style: TextStyle(color: Colors.white),
      obscureText: widget.isPassword == true ? true : false,
      decoration: InputDecoration(
        // labelText: widget.title,
        hintText: widget.title,
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Color.fromARGB(111, 255, 255, 255)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      textInputAction: TextInputAction.done,
    );
  }
}
