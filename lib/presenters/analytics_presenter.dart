// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:developer';
import 'package:usage/usage_io.dart';
import 'package:path_provider/path_provider.dart';

class AnalyticsPresenter {
  Analytics? ga;
  Future<void> initAnalytics() async {
    //const String ua = "UA-106662449-4";
    const String ua = "355511827";

    Directory appDocDir = await getApplicationDocumentsDirectory();
    //ga = AnalyticsIO(ua, 'App Customers - Test', '3.0', documentDirectory: appDocDir);
    ga = AnalyticsIO(ua, 'one-app-dia-group-test', '4.0', documentDirectory: appDocDir);
  }

  Future<void> logEvent({required String category, required String action, String? label, int? value, Map<String, String>? parameters}) async {
    try {
      var a = await ga?.sendEvent(category, action, label: label, value: value, parameters: parameters);
      log(a);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
