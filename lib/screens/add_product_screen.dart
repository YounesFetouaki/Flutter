import 'package:flutter/material.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredPrice = double.tryParse(_priceController.text) ?? 0.0;
    final enteredImageUrl = _imageUrlController.text;

    if (enteredTitle.isEmpty || enteredPrice <= 0 || enteredDescription.isEmpty) {
      return;
    }

    final newProduct = Product(
      id: DateTime.now().toString(),
      title: enteredTitle,
      description: enteredDescription,
      price: enteredPrice,
      imageUrl: enteredImageUrl.isEmpty
          ? 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg'
          : enteredImageUrl,
    );

    Navigator.of(context).pop(newProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Price'),
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Image URL'),
              controller: _imageUrlController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Product'),
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
