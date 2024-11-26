import 'package:flutter/material.dart';

class IcmText extends StatefulWidget {
  final String title;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const IcmText({
    super.key,
    required this.title,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  State<IcmText> createState() => _IcmTextState();
}

class _IcmTextState extends State<IcmText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: widget.fontSize ?? 15,
        fontWeight: widget.fontWeight,
      ),
    );
  }
}
