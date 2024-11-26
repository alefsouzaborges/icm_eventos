// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

import '../controller/homeController.dart';

class EventosResponsavelPage extends StatefulWidget {
  const EventosResponsavelPage({super.key});

  @override
  State<EventosResponsavelPage> createState() => _EventosResponsavelPageState();
}

class _EventosResponsavelPageState extends State<EventosResponsavelPage> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await homeController.getEventosAtivos();
  }

  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/eventos-config');
        },
        child: Icon(Icons.add_task),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: 'Lista de eventos'),
      ),
      body: Column(
        children: [
          _renderEventos(),
        ],
      ),
    );
  }

  _renderEventos() {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: homeController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : homeController.eventosAtivos.isEmpty
                  ? Center(
                      child: IcmText(
                        title: 'Nenhum evento cadastrado',
                        textColor: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: homeController.eventosAtivos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    print('Clicou no evento ${index + 1}');
                                    Get.toNamed('/eventos-responsavel-edit', arguments: {'evento': homeController.eventosAtivos[index]});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(),
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 60,
                                    child: IcmText(
                                      title: homeController.eventosAtivos[index]['nome_evento'] + ' - ' + homeController.eventosAtivos[index]['data_evento'],
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
      },
    );
  }
}
