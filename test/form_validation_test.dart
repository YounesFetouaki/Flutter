import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:atelier_produits/screens/add_product_screen.dart';

void main() {
  testWidgets('Form shows validation error on empty submit', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: AddProductScreen()));

        // Tap the save icon without entering text
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(); // Rebuild the widget

        // Verify validation error messages
        expect(find.text('Please provide a value.'), findsOneWidget); // Title error
        expect(find.text('Please enter a price.'), findsOneWidget); // Price error
        expect(find.text('Please enter a description.'), findsOneWidget); // Description error
    });
  });

   testWidgets('Form shows validation error on invalid URL', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: AddProductScreen()));

        // Enter invalid URL
        await tester.enterText(find.byType(TextFormField).at(3), 'invalid_url');
        
        // Tap the save icon
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(); // Rebuild the widget

        // Verify URL validation error
        expect(find.text('Please enter a valid URL.'), findsOneWidget);
    });
  });
}
