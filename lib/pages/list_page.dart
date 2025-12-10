// lib/pages/list_page.dart
import 'package:flutter/material.dart';
import '../models/pharmacy.dart';
import '../services/pharmacy_service.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Pharmacy> all = [];
  List<Pharmacy> filtered = [];
  bool loading = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final list = await PharmacyService.fetchPharmacies();
      setState(() {
        all = list;
        filtered = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void onSearch(String q) {
    setState(() {
      query = q;
      filtered = all.where((p) => p.name.toLowerCase().contains(q.toLowerCase()) || p.address.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search by name or address',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final p = filtered[i];
          return ListTile(
            title: Text(p.name),
            subtitle: Text(p.address),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(pharmacy: p))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _load,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
