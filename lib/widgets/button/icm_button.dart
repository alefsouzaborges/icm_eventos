import 'package:flutter/material.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';

class ICMButton extends StatefulWidget {
  final String title;
  final Function()? onPressed;
  const ICMButton({super.key, required this.title, required this.onPressed});

  @override
  State<ICMButton> createState() => _ICMButtonState();
}

class _ICMButtonState extends State<ICMButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: widget.onPressed,
        child: IcmText(
          title: widget.title,
        ),
      ),
    );
  }
}
