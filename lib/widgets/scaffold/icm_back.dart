import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../icm_text/icm_text.dart';

class ICMBack extends StatefulWidget {
  final String title;
  const ICMBack({super.key, required this.title});

  @override
  State<ICMBack> createState() => _ICMBackState();
}

class _ICMBackState extends State<ICMBack> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                size: 18,
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              width: 150,
              child: Image.asset(
                'assets/images/logo_icm.png',
                width: 250,
              ),
            ),
          ],
        ),
        IcmText(
          title: widget.title,
          textColor: Colors.white,
        )
      ],
    );
  }
}
