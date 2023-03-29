import 'dart:developer';
import 'package:flutter/material.dart';

class LifecyclePage extends StatefulWidget {
  const LifecyclePage({super.key});

  @override
  State<LifecyclePage> createState() => _LifecyclePageState();
}

class _LifecyclePageState extends State<LifecyclePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TESTE LIFECYCLE")),
      body: const Center(child: Text("TESTE DE LIFECYCLE")),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('AppLifecycleState: $state');

    // switch (state) {
    //   case AppLifecycleState.detached:
    //     print("ENTROU detached");
    //     break;

    //   case AppLifecycleState.inactive:
    //     print("ENTROU inactive");
    //     break;

    //   case AppLifecycleState.paused:
    //     print("ENTROU paused");
    //     break;

    //   case AppLifecycleState.resumed:
    //     print("ENTROU resumed");
    //     break;

    //   default:
    // }
  }
}
