import 'package:flutter/material.dart';
import 'package:teste/pages/stream_sse_web_socket_page.dart';
import 'package:teste/pages/firestore_page/firestore_page.dart';
import 'package:teste/pages/analytics_page.dart';
import 'package:teste/pages/lifecycle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testes"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AnalyticsPage()),
              ),
              child: const Text("Analytics"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LifecyclePage()),
              ),
              child: const Text("Lifecycle"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const StreamSseWebSocketPage()),
              ),
              child: const Text("Stream"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FirestorePage()),
              ),
              child: const Text("Firestore"),
            ),
          ],
        ),
      ),
    );
  }
}
