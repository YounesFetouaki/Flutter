import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreHelper {
  static final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  static Future<void> addProduct(Product product) async {
    await _productsCollection.doc(product.id).set(product.toMap());
  }

  static Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }

  static Stream<List<Product>> get productsStream {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
