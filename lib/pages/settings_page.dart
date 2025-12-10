// lib/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: const [
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map Tile'),
          subtitle: Text('OpenStreetMap (default)'),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
          subtitle: Text('WebMapping app sample'),
        ),
      ]),
    );
  }
}
