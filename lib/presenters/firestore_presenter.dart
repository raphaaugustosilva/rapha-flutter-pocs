import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste/domain/entities/tarjeta_entity.dart';

class FirestorePresenter {
  FirestorePresenter();

  late Stream<QuerySnapshot<TarjetaEntity>> tarjetaCollectionStream;
  String errorDetailText = "";

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

  Future<bool> postTest() async {
    String endpointUrlTest = "https://294b-189-4-78-35.ngrok.io";
    errorDetailText = "";

    Map<String, dynamic> payload = {'type': 'MAIL', 'subject': 'Rapha', 'message': 'Hello Word'};

    try {
      var response = await http.post(
        Uri.parse("$endpointUrlTest/test-sse"),
        headers: {'Content-Type': 'application/json', 'Accept-Language': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode > 299) throw Exception("${response.statusCode} - ${response.reasonPhrase}");
      log("RESULTADO POST: ${response.statusCode.toString()}");
      return true;
    } catch (e) {
      errorDetailText = "ERRO AO FAZER POST. ${e.toString()}";
      log(errorDetailText);
      return false;
    }
  }
}
