// lib/models/pharmacy.dart
import 'package:latlong2/latlong.dart';

class Pharmacy {
  final String id;
  final String name;
  final String quartier;
  final String address;
  final String phone;
  final String openingHours;
  final String web;
  final String imageUrl;
  final double latitude;
  final double longitude;

  Pharmacy({
    required this.id,
    required this.name,
    required this.quartier,
    required this.address,
    required this.phone,
    required this.openingHours,
    required this.web,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  LatLng get latlng => LatLng(latitude, longitude);

  /// Expects ONE item from the "pharmacies" list (with an "id" + "fields")
  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    double _parseDouble(dynamic v) =>
        (v is num) ? v.toDouble() : double.parse(v.toString());

    return Pharmacy(
      id: json['id']?.toString() ?? '',
      name: fields['pharmacie']?.toString() ?? 'Pharmacie',
      quartier: fields['quartier']?.toString() ?? '',
      address: fields['adresse']?.toString() ?? '',
      phone: fields['contact']?.toString() ?? '',
      openingHours: fields['horaires_d_ouverture']?.toString() ?? '',
      web: fields['web']?.toString() ?? '',
      imageUrl: fields['image']?.toString() ?? '',
      latitude: _parseDouble(fields['latitude']),
      longitude: _parseDouble(fields['longitude']),
    );
  }
}
