import 'package:flutter/material.dart';
import './screens/product_list_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoreManager API',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ProductListScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
