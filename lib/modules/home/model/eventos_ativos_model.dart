class EventosAtivosModel {
  int? id;
  String? nomeEvento;
  bool? isIninterrupta;
  String? horaInicial;
  String? horaFinal;
  bool? status;

  EventosAtivosModel({this.id, this.nomeEvento, this.isIninterrupta, this.horaInicial, this.horaFinal, this.status});

  EventosAtivosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeEvento = json['nome_evento'];
    isIninterrupta = json['is_ininterrupta'];
    horaInicial = json['hora_inicial'];
    horaFinal = json['hora_final'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome_evento'] = this.nomeEvento;
    data['is_ininterrupta'] = this.isIninterrupta;
    data['hora_inicial'] = this.horaInicial;
    data['hora_final'] = this.horaFinal;
    data['status'] = this.status;
    return data;
  }
}
