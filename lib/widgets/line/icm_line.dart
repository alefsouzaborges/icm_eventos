import 'package:flutter/material.dart';

class ICMLine extends StatefulWidget {
  const ICMLine({super.key});

  @override
  State<ICMLine> createState() => _ICMLineState();
}

class _ICMLineState extends State<ICMLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 0.5,
      color: Colors.white,
    );
  }
}
