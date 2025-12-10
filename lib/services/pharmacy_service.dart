// lib/services/pharmacy_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pharmacy.dart';

class PharmacyService {
  static const String _url =
      "https://api.jsonbin.io/v3/b/658212f71f5677401f10889b";

  static Future<List<Pharmacy>> fetchPharmacies() async {
    final uri = Uri.parse(_url);
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load pharmacies (HTTP ${resp.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);

    // ✅ record is an object with a "pharmacies" list
    final record = data['record'] as Map<String, dynamic>;
    final List pharmaciesJson = record['pharmacies'] as List;

    return pharmaciesJson
        .map((item) => Pharmacy.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
