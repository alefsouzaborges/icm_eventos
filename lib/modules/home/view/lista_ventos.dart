// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/line/icm_line.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';

import '../controller/homeController.dart';

class ListaEventosPage extends StatefulWidget {
  const ListaEventosPage({super.key});

  @override
  State<ListaEventosPage> createState() => _ListaEventosPageState();
}

class _ListaEventosPageState extends State<ListaEventosPage> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: 'Eventos'),
      ),
      body: Column(
        children: [
          ICMLine(),
          SizedBox(height: 10),
          IcmText(
            title: 'Para qual evento deseja se cadastrar?',
            fontSize: 15,
            textColor: Colors.white,
          ),
          SizedBox(height: 10),
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
                                    // Implementar a ação para o evento clicado
                                    print('Clicou no evento ${homeController.eventosAtivos[index]['nome_evento']}');
                                    Get.toNamed('/horarios', parameters: {'evento_id': homeController.eventosAtivos[index]['id'].toString()});
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
                                      // fontSize: 13,
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
