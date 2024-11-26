import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/widgets/button/icm_button.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/logo_icm.png',
                  width: 200,
                ),
                IcmText(
                  title: 'Eventos',
                  textColor: Colors.white,
                )
              ],
            ),
            const SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              width: MediaQuery.sizeOf(context).width,
              child: ICMButton(
                title: 'Sou membro',
                // onPressed: () => Get.to(() => ListaEventosPage()),
                onPressed: () => Get.toNamed('/eventos'),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              width: MediaQuery.sizeOf(context).width,
              child: ICMButton(
                title: 'Responsável de grupo',
                onPressed: () => Get.toNamed('/login-responsavel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
