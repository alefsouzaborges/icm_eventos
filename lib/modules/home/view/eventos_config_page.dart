// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/modules/home/controller/homeController.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/widgets/button/icm_button.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/input/icm_input_text.dart';
import 'package:icm_eventos/widgets/line/icm_line.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

class EventosConfigPage extends StatefulWidget {
  const EventosConfigPage({super.key});

  @override
  State<EventosConfigPage> createState() => _EventosConfigPageState();
}

class _EventosConfigPageState extends State<EventosConfigPage> {
  TextEditingController nomeEvento = TextEditingController();
  TextEditingController dataEvento = TextEditingController();
  final homeController = Get.put(HomeController());
  bool is_ininterrupta = false;
  String horaInicial = "06:00";
  String horaFinal = "18:00";

  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: 'Criar eventos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            ICMLine(),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IcmText(
                  title: 'Nome do evento',
                  textColor: Colors.white,
                ),
                SizedBox(height: 5),
                ICMInputText(controller: nomeEvento, title: 'Digite o nome do evento'),
                SizedBox(height: 5),
                IcmText(
                  title: 'digite a data do evento',
                  textColor: Colors.white,
                ),
                SizedBox(height: 5),
                ICMInputText(
                  controller: dataEvento,
                  title: 'Digite a data do evento',
                  inputDecoration: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, DataInputFormatter()],
                ),
                SizedBox(height: 5),
                CheckboxListTile(
                  value: is_ininterrupta,
                  checkColor: ICMColors.COR_PRINCIPAL,
                  activeColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (e) {
                    setState(() {
                      is_ininterrupta = e!;
                    });
                  },
                  title: IcmText(
                    title: 'Ininterrupta?',
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            if (!is_ininterrupta) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: IcmText(
                                title: 'Hora inicial',
                                textColor: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.sizeOf(context).width,
                              height: 80,
                              color: Colors.transparent,
                              child: _renderDropdown(
                                  value: horaInicial,
                                  onChanged: (e) {
                                    setState(() {
                                      horaInicial = e!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: IcmText(
                                  title: 'Hora final',
                                  textColor: Colors.white,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.sizeOf(context).width,
                                height: 80,
                                color: Colors.transparent,
                                child: _renderDropdown(
                                    value: horaFinal,
                                    onChanged: (e) {
                                      setState(() {
                                        horaFinal = e!;
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            SizedBox(height: 10),
            ICMButton(
                title: 'Adicionar evento',
                onPressed: () async {
                  if (nomeEvento.text.isNotEmpty && dataEvento.text.isNotEmpty) {
                    await homeController.criarEInserirEvento(
                      nome_evento: nomeEvento.text,
                      data_evento: dataEvento.text,
                      hora_inicial: horaInicial,
                      hora_final: horaFinal,
                      is_ininterrupta: is_ininterrupta,
                    );
                    Get.back();
                    Get.back();
                    Get.back();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: IcmText(title: 'Atenção'),
                              content: Text('O nome do evento não pode estar vazio.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Voltar'),
                                )
                              ],
                            ));
                  }
                })
          ],
        ),
      ),
    );
  }

  _renderDropdown({required Function(dynamic) onChanged, required String value}) {
    List<String> horarios = homeController.gerarHorariosDasSeisAsDezoito();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: ICMColors.COR_PRINCIPAL,
          items: horarios
              .map((horario) => DropdownMenuItem(
                    value: horario,
                    child: Text(horario),
                  ))
              .toList(), // Converte a lista em itens do dropdown
          padding: EdgeInsets.all(10),
          value: value,
          style: TextStyle(
            color: Colors.white,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  _renderEventos() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Adicionar os widgets dos eventos aqui
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      print('Clicou no evento ${index + 1}');
                      Get.toNamed('/horarios');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(),
                      width: MediaQuery.sizeOf(context).width,
                      height: 60,
                      child: IcmText(
                        title: 'Trombetas e festas',
                        textColor: Color.fromARGB(255, 86, 86, 86),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
