// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacies Map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Kept a different color (Teal) as a code change
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        useMaterial3: true,
        primarySwatch: Colors.deepOrange
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const SplashPage(),
        '/home': (ctx) => const HomePage(),
      },
    );
  }
}
