import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:atelier_produits/main.dart';

void main() {
  testWidgets('App loads and displays products', (WidgetTester tester) async {
    // Mock the network images to avoid HTTP errors
    await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MyApp());

        // Verify that the title is displayed
        expect(find.text('Atelier 1: Produits'), findsOneWidget);

        // Verify that the sample products are displayed
        expect(find.text('Red Shirt'), findsOneWidget);
        expect(find.text('Trousers'), findsOneWidget);

        // Verify floating action button exists
        expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
