import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:teste/pages/components/app_is_error_component.dart';
import 'package:teste/pages/components/app_is_loading_component.dart';
import 'package:teste/presenters/stream_sse_web_socket_presenter.dart';

class StreamSseWebSocketPage extends StatefulWidget {
  const StreamSseWebSocketPage({super.key});

  @override
  State<StreamSseWebSocketPage> createState() => _StreamSseWebSocketPageState();
}

class _StreamSseWebSocketPageState extends State<StreamSseWebSocketPage> {
  final StreamSseWebSocketPresenter presenter = StreamSseWebSocketPresenter();

  late Future futureInitSse;
  bool _isLoading = false;
  String? _loadingText;

  bool _isError = false;
  String? _errorText;

  @override
  void initState() {
    futureInitSse = presenter.initSse();
    //futureInitSse = presenter.initWebSocket();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      presenter.setUpdatePageCallback((isLoading, loadingText, isError, errorText) {
        if (isLoading != null) _isLoading = isLoading;
        _loadingText = loadingText ?? "";

        if (isError != null) _isError = isError;
        _errorText = errorText ?? "";

        setState(() {});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stream")),
      body: FutureBuilder(
        future: futureInitSse,
        builder: (context, snapshot) {
          return (snapshot.connectionState != ConnectionState.done)
              ? Center(child: AppIsLoadingComponent(loadingText: _loadingText))
              : Center(
                  child: _isError
                      ? AppIsErrorComponent(_errorText)
                      : _isLoading
                          ? AppIsLoadingComponent(loadingText: _loadingText)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async => await presenter.postTest(),
                                  child: const Text("Fazer POST"),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) => const Divider(color: Colors.black),
                                      itemCount: presenter.resultList.length,
                                      itemBuilder: (BuildContext ctx, int index) {
                                        return Text(presenter.resultList[index]);
                                      },
                                    ),
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
