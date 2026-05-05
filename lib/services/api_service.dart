import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/analysis_result.dart';

class ApiService {
  // Para emulador Android:
  static const String baseUrl = 'https://guardian-sms-api.onrender.com';

  // Para celular físico, cambia la línea anterior por la IP de tu computadora:
  // static const String baseUrl = 'http://192.168.1.50:8000';

  Future<AnalysisResult> analyzeSms({
    required String cleanMessage,
  }) async {
    final Uri url = Uri.parse('$baseUrl/predict');

    final http.Response response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'clean_message': cleanMessage,
          }),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return AnalysisResult.fromJson(jsonBody);
    }

    throw Exception(
      'El servidor respondió con código ${response.statusCode}',
    );
  }
}
