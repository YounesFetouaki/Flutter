// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:latlong2/latlong.dart';
import '../models/pharmacy.dart';

class DetailPage extends StatelessWidget {
  final Pharmacy pharmacy;
  const DetailPage({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pharmacy.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(pharmacy.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (pharmacy.address.isNotEmpty) Text('Address: ${pharmacy.address}'),
          const SizedBox(height: 8),
          if (pharmacy.phone.isNotEmpty) Text('Phone: ${pharmacy.phone}'),
          const SizedBox(height: 12),
          Text('Coordinates: ${pharmacy.latitude}, ${pharmacy.longitude}'),
          const Spacer(),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Open on Map'),
                onPressed: () {
                  // Here we could navigate to the map and center on this pharmacy.
                  // For simplicity do a pop to home and show a snackbar.
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open on Map not implemented')));
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.directions),
              label: const Text('Directions'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Directions not implemented')));
              },
            ),
          ])
        ]),
      ),
    );
  }
}
