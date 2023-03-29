import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste/domain/entities/tarjeta_entity.dart';
import 'package:teste/presenters/firestore_detail_presenter.dart';

class FirestoreDetailPage extends StatefulWidget {
  final String firestoreDocumentId;
  const FirestoreDetailPage({super.key, required this.firestoreDocumentId});

  @override
  State<FirestoreDetailPage> createState() => _FirestoreDetailPageState();
}

class _FirestoreDetailPageState extends State<FirestoreDetailPage> {
  final FirestoreDetailPresenter presenter = FirestoreDetailPresenter();

  late Future futureInitListeningToDocument;
  @override
  void initState() {
    futureInitListeningToDocument = presenter.listenToDocument(widget.firestoreDocumentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stream doc. ${widget.firestoreDocumentId}"), titleTextStyle: const TextStyle(fontSize: 10)),
      body: FutureBuilder(
        future: futureInitListeningToDocument,
        builder: (context, snapshot) {
          return (snapshot.connectionState != ConnectionState.done)
              ? Center(child: makeIsLoading())
              : Center(
                  child: StreamBuilder<DocumentSnapshot<TarjetaEntity>>(
                    stream: presenter.tarjetaDocumentStream,
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<TarjetaEntity>> snapshot) {
                      if (snapshot.hasError) return const Text('Algo deu errado');
                      if (snapshot.connectionState == ConnectionState.waiting) return const Text("Carregando");

                      TarjetaEntity? tarjetaEntity = snapshot.data?.data();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Ouvindo modificações do documento ${widget.firestoreDocumentId} da coleção tarjetas",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                            child: Column(
                              children: [
                                makeDetailItem("Nome", tarjetaEntity?.nome ?? ""),
                                makeDetailItem("Status", tarjetaEntity?.status ?? ""),
                                makeDetailItem("Última Alteração", tarjetaEntity?.dataUltimoStatus ?? ""),
                                // makeDetailItem("Nome", snapshot.data?['nome']),
                                // makeDetailItem("Status", snapshot.data?['status']),
                                // makeDetailItem("Última Alteração", DateTime.parse(snapshot.data?['data_ultimo_status']?.toDate()?.toString() ?? "").toString()),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
        },
      ),
    );
  }

  Widget makeDetailItem(String label, String value) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget makeIsLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [CircularProgressIndicator()],
      ),
    );
  }
}
