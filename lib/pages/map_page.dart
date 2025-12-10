// lib/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../models/pharmacy.dart';
import '../services/pharmacy_service.dart';
import 'detail_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  List<Pharmacy> pharmacies = [];
  bool loading = true;
  String? error;

  LatLng? userLocation;
  Pharmacy? nearestPharmacy;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadPharmacies();
    await _getUserLocation();
    if (userLocation != null && pharmacies.isNotEmpty) {
      _computeNearestPharmacy();
    }
  }

  Future<void> _loadPharmacies() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final list = await PharmacyService.fetchPharmacies();
      setState(() {
        pharmacies = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  /// Ask for permission + get GPS position
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enable location services to use geolocation')),
      );
      return;
    }

    // Check & request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied forever')),
      );
      return;
    }

    // Get position
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

    // Center map on user
    _mapController.move(userLocation!, 14);
  }

  /// Find the pharmacy with the smallest distance to userLocation
  void _computeNearestPharmacy() {
    if (userLocation == null || pharmacies.isEmpty) return;

    final Distance distance = const Distance();
    Pharmacy nearest = pharmacies.first;
    double best = distance(userLocation!, pharmacies.first.latlng);

    for (final p in pharmacies.skip(1)) {
      final d = distance(userLocation!, p.latlng);
      if (d < best) {
        best = d;
        nearest = p;
      }
    }

    setState(() {
      nearestPharmacy = nearest;
    });
  }

  void _goToNearest() {
    if (nearestPharmacy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No nearby pharmacy found')),
      );
      return;
    }
    final LatLng target = nearestPharmacy!.latlng;
    _mapController.move(target, 16);

    showModalBottomSheet(
      context: context,
      builder: (_) => ListTile(
        title: Text(nearestPharmacy!.name),
        subtitle: Text(nearestPharmacy!.address),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailPage(pharmacy: nearestPharmacy!),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map')),
        body: Center(child: Text('Error: $error')),
      );
    }

    final defaultCenter = pharmacies.isNotEmpty
        ? pharmacies.first.latlng
        : const LatLng(31.6314, -8.0128);

    final center = userLocation ?? defaultCenter;

    final markers = <Marker>[
      // Pharmacies markers
      ...pharmacies.map((p) {
        final isNearest = nearestPharmacy != null && p.id == nearestPharmacy!.id;
        return Marker(
          width: 50,
          height: 50,
          point: p.latlng,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DetailPage(pharmacy: p)),
              );
            },
            child: Icon(
              Icons.location_on,
              size: 36,
              // nearest pharmacy shown as different color
              color: isNearest ? Colors.green : Colors.red,
            ),
          ),
        );
      }),

      // User marker
      if (userLocation != null)
        Marker(
          width: 40,
          height: 40,
          point: userLocation!,
          child: const Icon(Icons.my_location, size: 30),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: center,
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.webmapping',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Button: go to my location
          FloatingActionButton(
            heroTag: 'myLocation',
            onPressed: () async {
              await _getUserLocation();
              if (userLocation != null) {
                _mapController.move(userLocation!, 15);
                _computeNearestPharmacy();
              }
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          // Button: nearest pharmacy
          FloatingActionButton(
            heroTag: 'nearest',
            onPressed: _goToNearest,
            child: const Icon(Icons.local_hospital),
          ),
        ],
      ),
    );
  }
}
