import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  Future<Map<String, dynamic>> loadData() async {
    final data = await rootBundle.loadString('assets/data/app_data.json');
    return jsonDecode(data);
  }
}