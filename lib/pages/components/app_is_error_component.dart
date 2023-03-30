import 'package:flutter/material.dart';

class AppIsErrorComponent extends StatelessWidget {
  final String? errorText;
  const AppIsErrorComponent(this.errorText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        errorText ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
