// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import '../services/pharmacy_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // prefetch to ensure service works; store if wanted later
      await PharmacyService.fetchPharmacies();
      setState(() => _status = 'Loaded');
    } catch (e) {
      setState(() => _status = 'Failed to fetch data');
    }
    // short pause for UX then navigate
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const FlutterLogo(size: 88),
          const SizedBox(height: 18),
          Text('Pharmacies Map', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(_status),
        ]),
      ),
    );
  }
}
