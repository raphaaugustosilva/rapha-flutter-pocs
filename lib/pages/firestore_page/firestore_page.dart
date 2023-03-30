import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste/domain/entities/tarjeta_entity.dart';
import 'package:teste/presenters/firestore_presenter.dart';
import 'package:teste/pages/components/app_is_error_component.dart';
import 'package:teste/pages/components/app_is_loading_component.dart';
import 'package:teste/pages/firestore_page/firestore_detail_page.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  final FirestorePresenter presenter = FirestorePresenter();
  bool isLoading = false;
  bool isError = false;

  late Future futureInitListeningToCollection;
  @override
  void initState() {
    futureInitListeningToCollection = presenter.listenToCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Stream Coleção Tarjetas"), titleTextStyle: const TextStyle(fontSize: 10)),
      body: FutureBuilder(
        future: futureInitListeningToCollection,
        builder: (context, snapshot) {
          return (snapshot.connectionState != ConnectionState.done)
              ? const Center(child: AppIsLoadingComponent())
              : isLoading
                  ? const Center(child: AppIsLoadingComponent())
                  : Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => [isError = false, isLoading = true]);
                              isError = !await presenter.postTest();
                              setState(() => isLoading = false);
                            },
                            child: const Text("Fazer POST"),
                          ),
                          if (isError) AppIsErrorComponent(presenter.errorDetailText),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot<TarjetaEntity>>(
                              stream: presenter.tarjetaCollectionStream,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<TarjetaEntity>> snapshot) {
                                if (snapshot.hasError) return const Text('Algo deu errado');

                                if (snapshot.connectionState == ConnectionState.waiting) return const Text("Carregando");

                                return ListView.separated(
                                  separatorBuilder: (context, index) => const Divider(color: Colors.black),
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    //DocumentSnapshot document = snapshot.data!.docs[index];
                                    //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                    TarjetaEntity tarjetaEntity = snapshot.data!.docs[index].data();

                                    return GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => FirestoreDetailPage(firestoreDocumentId: tarjetaEntity.id ?? "")),
                                      ),
                                      child: ListTile(
                                        title: Text(tarjetaEntity.nome ?? ""),
                                        subtitle: Text("Status: ${tarjetaEntity.status}"),
                                        trailing: const Icon(Icons.arrow_forward),
                                        //title: Text(data['nome']),
                                        //subtitle: Text("Status: ${data['status']}"),
                                        //trailing: const Icon(Icons.arrow_forward),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
