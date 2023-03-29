import 'package:flutter/material.dart';
import 'package:teste/presenters/analytics_presenter.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsPresenter presenter = AnalyticsPresenter();
  final TextEditingController analyticsCategoryController = TextEditingController();
  final TextEditingController analyticsAcaoController = TextEditingController();
  final TextEditingController analyticsLabelController = TextEditingController();
  final TextEditingController analyticsValueController = TextEditingController();
  bool isLoading = false;
  String resultSend = "";
  late Future futureInitAnalytics;

  @override
  void initState() {
    futureInitAnalytics = presenter.initAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: FutureBuilder(
        future: futureInitAnalytics,
        builder: (context, snapshot) {
          return (snapshot.connectionState != ConnectionState.done)
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: analyticsCategoryController,
                        decoration: const InputDecoration(hintText: 'Categoria'),
                      ),
                      TextField(
                        controller: analyticsAcaoController,
                        decoration: const InputDecoration(hintText: 'Ação'),
                      ),
                      TextField(
                        controller: analyticsLabelController,
                        decoration: const InputDecoration(hintText: 'Label'),
                      ),
                      TextField(
                        controller: analyticsValueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Valor'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            resultSend = "Enviando . . .";
                            setState(() => isLoading = true);
                            await presenter.logEvent(
                              category: analyticsCategoryController.text,
                              action: analyticsAcaoController.text,
                              label: analyticsLabelController.text,
                              value: int.tryParse(analyticsValueController.text),
                            );
                            resultSend = "ENVIADO COM SUCESSO!";
                          } catch (e) {
                            resultSend = "ERRO: \n$e";
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                        child: const Text("Enviar dados para analytics"),
                      ),
                      if (isLoading) const CircularProgressIndicator(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLoading) const Text("Resultado:"),
                          Text(resultSend),
                        ],
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
