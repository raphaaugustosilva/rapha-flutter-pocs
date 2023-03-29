import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste/domain/entities/tarjeta_entity.dart';

class FirestoreDetailPresenter {
  FirestoreDetailPresenter();

  late final Stream<DocumentSnapshot<TarjetaEntity>> tarjetaDocumentStream;

  Future<void> listenToDocument(String documentId) async {
    try {
      tarjetaDocumentStream = FirebaseFirestore.instance
          .collection('tarjetas')
          .doc(documentId)
          .withConverter<TarjetaEntity>(
            fromFirestore: (snapshot, _) => TarjetaEntity.fromJson(snapshot.data()!..addAll({"documentId": snapshot.id})),
            toFirestore: (tarjeta, _) => tarjeta.toJson(),
          )
          .snapshots();
    } catch (e) {
      log("ERRO no listenToDocument: $e");
    }
  }
}
