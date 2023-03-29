import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste/domain/entities/tarjeta_entity.dart';

class FirestorePresenter {
  FirestorePresenter();

  late Stream<QuerySnapshot<TarjetaEntity>> tarjetaCollectionStream;

  Future<void> listenToCollection() async {
    try {
      tarjetaCollectionStream = FirebaseFirestore.instance
          .collection('tarjetas')
          .withConverter<TarjetaEntity>(
            fromFirestore: (snapshot, _) => TarjetaEntity.fromJson(snapshot.data()!..addAll({"documentId": snapshot.id})),
            toFirestore: (tarjeta, _) => tarjeta.toJson(),
          )
          .snapshots();
    } catch (e) {
      log("ERRO no listenToCollection: $e");
    }
  }
}
