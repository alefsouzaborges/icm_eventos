import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';

class ICMModalLoad {
  static getModalLoad() {
    return Get.defaultDialog(
        title: '',
        titlePadding: EdgeInsets.zero,
        content: Container(
          child: Column(
            children: [
              IcmText(title: 'Aguardando...'),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ));
  }
}
