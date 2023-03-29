import 'package:cloud_firestore/cloud_firestore.dart';

class TarjetaEntity {
  final String? id;
  final String? nome;
  final String? status;
  final String? dataUltimoStatus;
  TarjetaEntity({
    required this.id,
    required this.nome,
    required this.status,
    required this.dataUltimoStatus,
  });

  TarjetaEntity.fromJson(Map<String, Object?> json)
      : this(
          id: json['documentId'] as String?,
          nome: json['nome'] as String?,
          status: json['status'] as String?,
          dataUltimoStatus: json['data_ultimo_status'] == null ? null : DateTime.parse((json['data_ultimo_status']! as Timestamp).toDate().toString()).toString(),
        );

  Map<String, Object?> toJson() {
    return {
      'nome': nome,
      'status': status,
      'data_ultimo_status': dataUltimoStatus,
    };
  }
}
