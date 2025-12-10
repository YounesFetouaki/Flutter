import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:atelier_produits/helpers/database_helper.dart';
import 'package:atelier_produits/models/product.dart';

void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for Linux/Windows/MacOS
    databaseFactory = databaseFactoryFfi;
  });

  test('Database helper inserts and retrieves product', () async {
    final product = Product(
      id: 't1',
      title: 'Test Product',
      description: 'Description',
      price: 10.0,
      imageUrl: 'http://test.com/image.png',
    );

    await DatabaseHelper.instance.insertProduct(product);

    final products = await DatabaseHelper.instance.getProducts();

    expect(products.length, greaterThanOrEqualTo(1));
    expect(products.first.id, 't1');
    expect(products.first.title, 'Test Product');
  });
}
