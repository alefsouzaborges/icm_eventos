// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/utils/icm_colors.dart';
import 'package:icm_eventos/utils/icm_custom_scroll.dart';
import 'package:icm_eventos/widgets/icm_text/icm_text.dart';
import 'package:icm_eventos/widgets/scaffold/icm_back.dart';
import 'package:icm_eventos/widgets/scaffold/icm_scaffold.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../widgets/button/icm_button.dart';
import '../../../widgets/input/icm_input_text.dart';
import '../../../widgets/line/icm_line.dart';
import '../controller/homeController.dart';

class EventosResponsavelEditPage extends StatefulWidget {
  const EventosResponsavelEditPage({super.key});

  @override
  State<EventosResponsavelEditPage> createState() => _EventosResponsavelEditPageState();
}

class _EventosResponsavelEditPageState extends State<EventosResponsavelEditPage> {
  final homeController = Get.put(HomeController());
  List<Map<String, dynamic>> eventoSelecionado = [];
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataEvento = TextEditingController();

  @override
  void initState() {
    super.initState();
    final evento = Get.arguments['evento']; // Recebe o evento enviado via Get.arguments
    eventoSelecionado.add(evento); // Adiciona o evento à lista
    nomeController.text = eventoSelecionado[0]['nome_evento']; // Inicializa o nomeController com o nome do evento do eventoSelecionado
    dataEvento.text = eventoSelecionado[0]['data_evento']; // Inicializa o nomeController com o nome do evento do eventoSelecionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  init() async {
    await homeController.getEventoDetalhes(eventoSelecionado[0]['id']);
  }

  Future<pw.Font> _loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    final font = pw.Font.ttf(fontData);
    return font;
  }

  Future<pw.ImageProvider> _loadImage(String imagePath) async {
    final imageBytes = await rootBundle.load(imagePath);
    return pw.MemoryImage(imageBytes.buffer.asUint8List());
  }

  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();

    final regularFont = await _loadFont('assets/fonts/Roboto-Regular.ttf');
    final boldFont = await _loadFont('assets/fonts/Roboto-Bold.ttf');
    final imageLogo = await _loadImage('assets/images/logo_icm_original.png');

    // Cabeçalho do documento
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: 150,
                  height: 150,
                  child: pw.Image(imageLogo, fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  eventoSelecionado[0]['nome_evento'].toString(),
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(), // Adiciona bordas à tabela
            children: [
              // Cabeçalho com fundo cinza claro
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColor(0.9, 0.9, 0.9)),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Membro',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Horário',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              // Linhas dos dados
              ...homeController.eventosHorariosMarcados.map((evento) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        evento['membro'] ?? 'N/A',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        evento['horario'] ?? 'N/A',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return IcmScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ICMColors.COR_PRINCIPAL,
        title: ICMBack(title: eventoSelecionado[0]['nome_evento'] ?? ''),
      ),
      bottomMenu: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        child: ICMButton(
          title: 'Gerar relação de mebros',
          onPressed: () async {
            final pdf = await generatePdf();
            await Printing.sharePdf(
              bytes: await pdf.save(),
              filename: 'relatorio_eventos.pdf',
            );
          },
        ),
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
                  title: 'Digite um novo nome para o evento',
                  textColor: Colors.white,
                ),
                SizedBox(height: 5),
                ICMInputText(controller: nomeController, title: 'Digite o nome do evento'),
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
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ICMButton(
                    title: 'Alterar nome evento',
                    onPressed: () async {
                      if (nomeController.text.isNotEmpty && dataEvento.text.isNotEmpty) {
                        await homeController.atualizarNomeEvento(eventoSelecionado[0]['id'].toString(), nomeController.text, dataEvento.text);
                        Get.back();
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
                    }),
                SizedBox(width: 10),
                ICMButton(
                  title: 'Remover evento',
                  onPressed: () {
                    if (nomeController.text.isNotEmpty && dataEvento.text.isNotEmpty) {
                      Get.defaultDialog(
                        title: 'Confirmação',
                        middleText: 'Você realmente deseja deletar este evento?',
                        textConfirm: 'Sim',
                        textCancel: 'Não',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.black,
                        buttonColor: Colors.red,
                        onConfirm: () async {
                          await homeController.deletarEventoComDetalhes(eventoSelecionado[0]['id'].toString());
                          Get.back(); // Fecha o diálogo
                          Get.back(); // Retorna à página anterior
                          Get.back(); // Retorna à página anterior
                          Get.back(); // Retorna à página anterior
                        },
                        onCancel: () {
                          Get.back(); // Fecha o diálogo
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ICMLine(),
            SizedBox(height: 10),
            Expanded(child: _renderEventos())
          ],
        ),
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
              : homeController.eventosHorariosMarcados.isEmpty
                  ? Center(
                      child: IcmText(
                        title: 'Nenhum evento cadastrado',
                        textColor: Colors.white,
                      ),
                    )
                  : ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: homeController.eventosHorariosMarcados.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 80,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IcmText(
                                            title: 'Membro: ',
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          IcmText(
                                            title: homeController.eventosHorariosMarcados[index]['membro'] == '' ? 'Vago' : homeController.eventosHorariosMarcados[index]['membro'],
                                            textColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IcmText(
                                            title: 'Horario: ',
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          IcmText(
                                            title: homeController.eventosHorariosMarcados[index]['horario'].toString(),
                                            textColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 80)
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
