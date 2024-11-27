import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icm_eventos/widgets/modal/icm_modal_load.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  static final cliente = Supabase.instance.client; // Supabase client
  RxBool isLoading = false.obs;

  RxList eventosAtivos = RxList([]);
  RxList eventosHorariosMarcados = RxList([]);
  RxList eventosDetalhes = RxList([]);

  Future<void> criarEInserirEvento({
    required String nome_evento,
    required String data_evento,
    required bool is_ininterrupta,
    required String hora_inicial,
    required String hora_final,
  }) async {
    try {
      ICMModalLoad.getModalLoad();

      final response = await cliente.from('Eventos').insert({
        'nome_evento': nome_evento,
        'data_evento': data_evento,
        'is_ininterrupta': is_ininterrupta,
        'hora_inicial': is_ininterrupta ? '00:00' : hora_inicial,
        'hora_final': is_ininterrupta ? '00:00' : hora_final,
        'status': true,
      }).select('id');

      if (response.isNotEmpty) {
        final String eventoId = response.first['id'].toString();
        print('Evento inserido com sucesso! ID: $eventoId');

        if (is_ininterrupta) {
          await criarRegistrosEventoDetalhes(eventoId);
        } else {
          await criarRegistrosEventoDetalhesPorHorario(eventoId, hora_inicial, hora_final);
        }
      } else {
        print('Nenhum ID retornado para o evento inserido.');
      }
      Get.back();
    } catch (e) {
      Get.back();
      print('Erro ao inserir evento: $e');
    }
  }

  Future<void> criarRegistrosEventoDetalhes(String eventoId) async {
    try {
      // Gerar a lista de horários
      List<String> horarios = gerarHorarios();

      // Criar os detalhes com o campo 'ordem' sequencial
      List<Map<String, dynamic>> detalhes = horarios.asMap().entries.map((entry) {
        int index = entry.key; // Índice do horário na lista
        String horario = entry.value; // Valor do horário
        return {
          'id_evento': eventoId,
          'horario': horario,
          'membro': '',
          'ordem': index + 1, // A ordem começa de 1
          'status': true,
        };
      }).toList();

      // Inserir os detalhes na tabela Eventos_detalhes
      await cliente.from('Eventos_detalhes').insert(detalhes);

      // Atualizar os registros padrão após a criação
      atualizarRegistrosPadraoEventoDetalhes(eventoId);

      print('Registros criados em Eventos_detalhes com sucesso!');
    } catch (e) {
      print('Erro ao criar registros em Eventos_detalhes: $e');
    }
  }

  List<String> gerarHorarios() {
    List<String> horarios = ['00:00']; // Começa com 00:00
    for (int hora = 0; hora < 24; hora++) {
      for (int minuto = 0; minuto < 60; minuto += 15) {
        // Evita adicionar 00:00 novamente durante o loop
        if (!(hora == 0 && minuto == 0)) {
          String horaFormatada = hora.toString().padLeft(2, '0');
          String minutoFormatado = minuto.toString().padLeft(2, '0');
          horarios.add('$horaFormatada:$minutoFormatado');
        }
      }
    }
    horarios.add('00:00'); // Adiciona 00:00 no final
    return horarios;
  }

  Future<void> criarRegistrosEventoDetalhesPorHorario(String eventoId, String horarioInicial, String horarioFinal) async {
    try {
      // Gerar os horários no intervalo fornecido
      List<String> horarios = gerarHorariosPorIntervalo(horarioInicial, horarioFinal);

      // Criar os detalhes com o campo 'ordem' sequencial
      List<Map<String, dynamic>> detalhes = horarios.asMap().entries.map((entry) {
        int index = entry.key; // Índice do horário na lista
        String horario = entry.value; // Valor do horário
        return {
          'id_evento': eventoId,
          'horario': horario,
          'membro': '',
          'ordem': index + 1, // A ordem começa de 1
          'status': true,
        };
      }).toList();

      // Inserir os detalhes na tabela Eventos_detalhes
      await cliente.from('Eventos_detalhes').insert(detalhes);

      // Atualizar os registros padrão após a criação
      atualizarRegistrosPadraoEventoDetalhes(eventoId);

      print('Registros criados em Eventos_detalhes com sucesso para o intervalo!');
    } catch (e) {
      print('Erro ao criar registros em Eventos_detalhes para o intervalo: $e');
    }
  }

  Future<void> atualizarRegistrosPadraoEventoDetalhes(String eventoId) async {
    try {
      // Lista de horários fixos para atualização
      List<Map<String, dynamic>> horariosAtualizar = [
        {'horario': '06:00', 'membro': 'MADRUGADA', 'status': false},
        {'horario': '06:15', 'membro': 'MADRUGADA', 'status': false},
        {'horario': '19:30', 'membro': 'CULTO', 'status': false},
        {'horario': '19:45', 'membro': 'CULTO', 'status': false},
        {'horario': '20:00', 'membro': 'CULTO', 'status': false},
      ];

      for (var horario in horariosAtualizar) {
        // Atualiza cada registro correspondente ao id_evento e horário
        final response = await cliente
            .from('Eventos_detalhes')
            .update({
              'membro': horario['membro'],
              'status': horario['status'],
            })
            .eq('id_evento', eventoId)
            .eq('horario', horario['horario']);

        if (response == null || response.isEmpty) {
          print('Nenhum registro encontrado para o horário ${horario['horario']} com id_evento $eventoId');
        } else {
          print('Registro atualizado com sucesso para o horário ${horario['horario']}');
        }
      }
    } catch (e) {
      print('Erro ao atualizar registros em Eventos_detalhes: $e');
    }
  }

  List<String> gerarHorariosPorIntervalo(String horarioInicial, String horarioFinal) {
    List<String> horarios = [];
    int horaInicial = int.parse(horarioInicial.split(':')[0]);
    int minutoInicial = int.parse(horarioInicial.split(':')[1]);
    int horaFinal = int.parse(horarioFinal.split(':')[0]);
    int minutoFinal = int.parse(horarioFinal.split(':')[1]);

    for (int hora = horaInicial; hora <= horaFinal; hora++) {
      for (int minuto = (hora == horaInicial ? minutoInicial : 0); minuto < 60; minuto += 15) {
        if (hora == horaFinal && minuto > minutoFinal) break;

        String horaFormatada = hora.toString().padLeft(2, '0');
        String minutoFormatado = minuto.toString().padLeft(2, '0');
        horarios.add('$horaFormatada:$minutoFormatado');
      }
    }

    return horarios;
  }

  List<String> gerarHorariosDasSeisAsDezoito() {
    List<String> horarios = [];
    for (int hora = 6; hora <= 18; hora++) {
      for (int minuto = 0; minuto < 60; minuto += 15) {
        String horaFormatada = hora.toString().padLeft(2, '0');
        String minutoFormatado = minuto.toString().padLeft(2, '0');
        horarios.add('$horaFormatada:$minutoFormatado');
      }
    }
    return horarios;
  }

  Future<List<Map<String, dynamic>>> getEventosAtivos() async {
    try {
      isLoading.value = true;
      final response = await cliente.from('Eventos').select('*').eq('status', true);

      if (response.isNotEmpty) {
        print('Eventos ativos recuperados com sucesso!');
        eventosAtivos.value = response;
        isLoading.value = false;
        return List<Map<String, dynamic>>.from(response);
      } else {
        print('Nenhum evento ativo encontrado.');
        eventosAtivos.value = [];
        isLoading.value = false;
        return [];
      }
    } catch (e) {
      print('Erro ao recuperar eventos ativos: $e');
      isLoading.value = false;
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDetalhesEvento(String eventoId) async {
    try {
      final response = await cliente.from('Eventos_detalhes').select('*').eq('id_evento', eventoId);

      if (response.isNotEmpty) {
        print('Detalhes do evento recuperados com sucesso!');

        // Verificar se o horário '00:00' está presente na lista
        bool contem00 = response.any((e) => e['horario'] == '00:00');

        if (contem00) {
          // Separar os dois '00:00' da lista
          Map<String, dynamic>? primeiro00 = response.firstWhere((e) => e['horario'] == '00:00');
          Map<String, dynamic>? ultimo00 = response.lastWhere((e) => e['horario'] == '00:00');

          // Filtrar os registros que não são '00:00'
          List<Map<String, dynamic>> restantes = response.where((e) => e['horario'] != '00:00').toList();

          // Organizar os registros restantes por horário
          restantes.sort((a, b) {
            String horarioA = a['horario'];
            String horarioB = b['horario'];
            return horarioA.compareTo(horarioB); // Ordena por horário crescente
          });

          // Adicionar o primeiro '00:00' no início e o último '00:00' no final
          List<Map<String, dynamic>> detalhesOrganizados = [];

          detalhesOrganizados.add(primeiro00);
          detalhesOrganizados.addAll(restantes);
          if (ultimo00 != primeiro00) detalhesOrganizados.add(ultimo00); // Evita duplicação do '00:00' se for o mesmo

          eventosDetalhes.value = detalhesOrganizados;

          // Retorna a lista organizada com '00:00' no início e no final
          return List<Map<String, dynamic>>.from(detalhesOrganizados);
        } else {
          // Se '00:00' não estiver presente, retorna a lista normal
          eventosDetalhes.value = response;
          return List<Map<String, dynamic>>.from(response);
        }
      } else {
        print('Nenhum detalhe encontrado para o evento com ID: $eventoId');
        return [];
      }
    } catch (e) {
      print('Erro ao recuperar detalhes do evento: $e');
      return [];
    }
  }

  Future<void> atualizarMembroDetalhe(String id, String novoMembro, BuildContext context) async {
    try {
      final response = await cliente.from('Eventos_detalhes').update({'membro': novoMembro, 'status': false}) // Atualiza o campo 'membro'
          .eq('id', id); // Filtra pelo ID do evento detalhe

      if (response != null && response.isNotEmpty) {
        print('Membro atualizado com sucesso!');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Sucesso!',
          desc: 'Horário confirmado com sucesso!',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      } else {
        AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Sucesso!',
          desc: 'Horário confirmado com sucesso!',
          btnCancelOnPress: () {
            Get.back();
            Get.back();
            Get.back();
          },
          btnOkOnPress: () {
            Get.back();
            Get.back();
            Get.back();
          },
        )..show();
        print('Nenhum registro encontrado para o ID: $id');
      }
    } catch (e) {
      print('Erro ao atualizar o membro do evento detalhe: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEventoDetalhes(int eventoId) async {
    try {
      isLoading.value = true; // Indica que a carga está em progresso
      final response = await cliente
          .from('Eventos_detalhes') // Nome da tabela
          .select('id, horario, membro') // Seleciona apenas os campos necessários
          .eq('id_evento', eventoId)
          .order('ordem', ascending: false); // Filtro pelo evento_id fornecido

      if (response.isNotEmpty) {
        print('Detalhes do evento recuperados com sucesso!');
        isLoading.value = false;
        eventosHorariosMarcados.value = response;
        return List<Map<String, dynamic>>.from(response); // Converte a resposta para lista de mapas
      } else {
        print('Nenhum detalhe encontrado para o evento.');
        isLoading.value = false;
        return [];
      }
    } catch (e) {
      print('Erro ao recuperar detalhes do evento: $e');
      isLoading.value = false;
      return [];
    }
  }

  Future<void> atualizarNomeEvento(String eventoId, String novoNomeEvento, String dataEvento) async {
    try {
      ICMModalLoad.getModalLoad();
      final response = await cliente.from('Eventos').update({'nome_evento': novoNomeEvento, 'data_evento': dataEvento}) // Atualiza o campo 'nome_evento'
          .eq('id', eventoId); // Filtra pelo ID do evento

      if (response != null && response.isNotEmpty) {
        print('Nome do evento atualizado com sucesso!');
      } else {
        print('Nenhum registro encontrado para o ID do evento: $eventoId');
      }
      Get.back();
      Get.back();
      Get.back();
    } catch (e) {
      print('Erro ao atualizar o nome do evento: $e');
    }
  }

  Future<bool> deletarEvento(String eventoId) async {
    try {
      final response = await cliente.from('Eventos').delete().eq('id', eventoId);

      if (response != null && response.isNotEmpty) {
        print('Evento deletado com sucesso!');
        return true;
      } else {
        print('Nenhum evento encontrado para o ID: $eventoId');
        return false;
      }
    } catch (e) {
      print('Erro ao deletar o evento: $e');
      return false;
    }
  }

  Future<void> deletarDetalhesEvento(String eventoId) async {
    try {
      final response = await cliente.from('Eventos_detalhes').delete().eq('id_evento', eventoId);

      if (response != null && response.isNotEmpty) {
        print('Detalhes do evento deletados com sucesso!');
      } else {
        print('Nenhum detalhe encontrado para o Evento ID: $eventoId');
      }
    } catch (e) {
      print('Erro ao deletar os detalhes do evento: $e');
    }
  }

  Future<void> deletarEventoComDetalhes(String eventoId) async {
    final sucessoEvento = await deletarEvento(eventoId);

    if (sucessoEvento) {
      await deletarDetalhesEvento(eventoId);
    } else {
      print('Não foi possível deletar o evento principal. Os detalhes não serão deletados.');
    }
  }

  Future<List<Map<String, String>>> gerarIntervalosLocais(List<Map<String, dynamic>> eventosDetalhes) async {
    // Ordena a lista por horário
    eventosDetalhes.sort((a, b) => a['horario'].compareTo(b['horario']));

    List<Map<String, String>> intervalos = [];

    for (int i = 0; i < eventosDetalhes.length - 1; i += 2) {
      String horarioInicio = eventosDetalhes[i]['horario'];
      String horarioFim = eventosDetalhes[i + 1]['horario'];
      String membroInicio = eventosDetalhes[i]['membro'] ?? '';
      String membroFim = eventosDetalhes[i + 1]['membro'] ?? '';

      // Concatena os horários e os membros
      String intervalo = '$horarioInicio a $horarioFim';
      String membros = membroInicio.isNotEmpty && membroFim.isNotEmpty
          ? '$membroInicio / $membroFim'
          : membroInicio.isNotEmpty
              ? membroInicio
              : membroFim;

      intervalos.add({'intervalo': intervalo, 'membros': membros});
    }

    // Verifica se sobrou um horário sem par
    if (eventosDetalhes.length % 2 != 0) {
      final ultimo = eventosDetalhes.last;
      intervalos.add({'intervalo': '${ultimo['horario']} a ...', 'membros': ultimo['membro'] ?? ''});
    }

    return intervalos;
  }

  Future<List<Map<String, dynamic>>> buscarEventosDetalhes(String eventoId) async {
    try {
      final response = await cliente.from('Eventos_detalhes').select('horario, membro').eq('id_evento', eventoId).order('horario', ascending: true).then((value) => value);

      if (response != null && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        print('Nenhum detalhe encontrado para o evento.');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar eventos detalhes: $e');
      return [];
    }
  }

  void gerarRelatorioIntervalos(String eventoId) async {
    final eventosDetalhes = await buscarEventosDetalhes(eventoId);

    if (eventosDetalhes.isNotEmpty) {
      final intervalos = await gerarIntervalosLocais(eventosDetalhes);

      for (var intervalo in intervalos) {
        print('Intervalo: ${intervalo['intervalo']}');
        print('Membros: ${intervalo['membros']}');
      }
    } else {
      print('Nenhum detalhe encontrado para o evento.');
    }
  }
}
