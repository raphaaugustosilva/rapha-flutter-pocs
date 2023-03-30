import 'package:flutter/material.dart';

class AppIsLoadingComponent extends StatelessWidget {
  final String? loadingText;
  const AppIsLoadingComponent({super.key, this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (loadingText != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(loadingText ?? "", textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }
}
