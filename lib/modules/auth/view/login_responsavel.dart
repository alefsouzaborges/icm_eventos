import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/widgets/button/icm_button.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/input/icm_input_text.dart';
import 'package:icm_eventos/widgets/line/icm_line.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

class LoginResponsavelPage extends StatefulWidget {
  const LoginResponsavelPage({super.key});

  @override
  State<LoginResponsavelPage> createState() => _LoginResponsavelPageState();
}

class _LoginResponsavelPageState extends State<LoginResponsavelPage> {
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: 'Acesso'),
      ),
      body: Column(
        children: [
          ICMLine(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                IcmText(
                  title: 'Acesso restrito',
                  textColor: Colors.white,
                ),
                const SizedBox(height: 80),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IcmText(
                        title: 'Senha mestre',
                        textColor: Colors.white,
                      ),
                      Container(
                        child: ICMInputText(
                          isPassword: true,
                          title: 'Senha mestre',
                          controller: senhaController,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  width: MediaQuery.sizeOf(context).width,
                  child: ICMButton(
                    title: 'Entrar',
                    onPressed: () {
                      if (senhaController.text != '@icm2024@') {
                        Get.defaultDialog(
                          title: 'Erro no acesso',
                          titleStyle: TextStyle(
                            color: const Color.fromARGB(255, 63, 63, 63),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          content: Column(
                            children: [
                              Container(
                                child: IcmText(
                                  title: 'Senha incorreta!',
                                  fontSize: 15,
                                  textColor: const Color.fromARGB(255, 93, 93, 93),
                                ),
                              ),
                              SizedBox(height: 10),
                              ICMButton(title: 'Voltar', onPressed: () => Get.back())
                            ],
                          ),
                        );
                      } else {
                        Get.toNamed('/eventos-responsavel');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
