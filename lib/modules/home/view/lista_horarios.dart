// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/widgets/button/icm_button.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/input/icm_input_text.dart';
import 'package:icm_eventos/widgets/line/icm_line.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

import '../controller/homeController.dart';

class ListaHorariosPage extends StatefulWidget {
  const ListaHorariosPage({super.key});

  @override
  State<ListaHorariosPage> createState() => _ListaHorariosPageState();
}

class _ListaHorariosPageState extends State<ListaHorariosPage> {
  List<String> horarios = [];
  String eventoId = '';
  String horarioSelecionado = '';
  int idHorarioSelecionado = 0;
  final homeController = Get.put(HomeController());
  TextEditingController nomeController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    eventoId = Get.parameters['evento_id'].toString();
    await homeController.getDetalhesEvento(eventoId);
  }

  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: 'Horários'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ICMLine(),
                SizedBox(height: 10),
                IcmText(
                  title: 'Digite seu nome...',
                  fontSize: 15,
                  textColor: Colors.white,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ICMInputText(
                    title: 'nome do membro',
                    controller: nomeController,
                  ),
                  SizedBox(height: 10),
                  IcmText(
                    title: 'Selecione um horário para oração',
                    fontSize: 15,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  _renderHorarios(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomMenu: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        child: ICMButton(
          title: 'Salvar',
          onPressed: () async {
            if (nomeController.text.isEmpty) {
              Get.defaultDialog(
                title: 'Dados faltantes',
                titleStyle: TextStyle(
                  color: const Color.fromARGB(255, 63, 63, 63),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                content: Column(
                  children: [
                    Container(
                      child: IcmText(
                        title: 'Por favor, informe o nome',
                        fontSize: 15,
                        textColor: const Color.fromARGB(255, 93, 93, 93),
                      ),
                    ),
                    SizedBox(height: 10),
                    ICMButton(
                      title: 'Voltar',
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
              );
            } else {
              await homeController.atualizarMembroDetalhe(idHorarioSelecionado.toString(), nomeController.text, context);
              await homeController.getDetalhesEvento(eventoId);
              nomeController.text = '';
              idHorarioSelecionado = 0;
              horarioSelecionado = '';
            }
          },
        ),
      ),
    );
  }

  _renderHorarios() {
    return Obx(
      () {
        return Column(
          children: [
            Wrap(
              spacing: 10,
              children: List.generate(homeController.eventosDetalhes.length, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 3, color: horarioSelecionado == homeController.eventosDetalhes[index]['horario'] ? Colors.green : Colors.transparent),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: homeController.eventosDetalhes[index]['status'] == true ? Colors.white : Colors.red,
                    child: InkWell(
                      onTap: homeController.eventosDetalhes[index]['status'] == true
                          ? () {
                              setState(() {
                                idHorarioSelecionado = homeController.eventosDetalhes[index]['id'];
                                horarioSelecionado = homeController.eventosDetalhes[index]['horario'].toString();
                              });
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(),
                        width: 80,
                        height: 60,
                        child: IcmText(
                          title: homeController.eventosDetalhes[index]['horario'].toString(),
                          textColor: homeController.eventosDetalhes[index]['status'] == true ? Color.fromARGB(255, 86, 86, 86) : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
