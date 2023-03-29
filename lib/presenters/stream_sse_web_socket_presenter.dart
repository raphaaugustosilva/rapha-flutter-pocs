import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StreamSseWebSocketPresenter {
  StreamSseWebSocketPresenter();

  final List<String> resultList = [];
  Function(bool?, String?, bool?, String?)? _updatePageCallback;
  void setUpdatePageCallback(Function(bool?, String?, bool?, String?)? updatePageCallback) => _updatePageCallback = updatePageCallback;

  void updatePage({bool? isLoading, String? loadingText, bool? isError, String? errorText}) => _updatePageCallback?.call(isLoading, loadingText, isError, errorText);

  final String sseEndpointUrl = "https://294b-189-4-78-35.ngrok.io";

  Future<void> initSse() async {
    bool connected = false;
    EventSource? eventSource;
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      updatePage(isLoading: true, loadingText: "Esperando fechar conexão com SSE $sseEndpointUrl");

      eventSource = await EventSource.connect(
        Uri.parse("$sseEndpointUrl/test-sse"),
        method: "GET",
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': 'application/json',
        },
      );
      connected = true;
    } catch (e) {
      updatePage(isLoading: false, isError: true, errorText: "Erro ao conectar com SSE.\nDetalhes: $e");
    }

    if (connected) {
      try {
        updatePage(isLoading: true, loadingText: "Ligando listener...");
        eventSource?.listen((Event event) {
          log("New event:\n  event: ${event.event}\n  data: ${event.data}");

          var responseDecoded = jsonDecode(event.data!);
          resultList.add(responseDecoded['code']);

          updatePage();
        });
        updatePage(isLoading: false);
      } catch (e) {
        updatePage(isLoading: false, isError: true, errorText: "Erro ao ligar o listener com SSE.\nDetalhes: $e");
      }
    }
  }

  Future<void> initWebSocket() async {
    final wsUrl = Uri.parse('ws://localhost:10000');
    var channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen((message) {
      //var responseDecoded = jsonDecode(event.data!);
      //resultList.add(responseDecoded['code']);
      resultList.add(message.toString());

      //_updatePageCallback?.call(false);
      updatePage(isLoading: false);

      //channel.sink.add('received!');
      //channel.sink.close(status.goingAway);
    });
  }

  Future<void> postTest() async {
    Map<String, dynamic> payload = {'type': 'MAIL', 'subject': 'Rapha', 'message': 'Hello Word'};

    try {
      var response = await http.post(
        Uri.parse("$sseEndpointUrl/test-sse"),
        headers: {'Content-Type': 'application/json', 'Accept-Language': 'application/json'},
        body: json.encode(payload),
      );
      log("RESULTADO POST: ${response.statusCode.toString()}");
    } catch (e) {
      log("ERRO AO FAZER POST. ${e.toString()}");
    }
  }
}
