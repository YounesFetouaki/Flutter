import 'package:flutter/material.dart';
import '../models/product.dart';
import 'add_product_screen.dart';
import '../widgets/app_drawer.dart';
import './product_detail_screen.dart';
import '../helpers/database_helper.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = DatabaseHelper.instance.getProducts();
    });
  }

  void _navigateToAddProductScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProductScreen(),
      ),
    );

    if (result != null && result is Product) {
      // In this version, AddProductScreen handles insertion,
      // so we just need to refresh. If AddProductScreen returned the product
      // but didn't save (which was previous logic), we'd save here.
      // Current design: AddProductScreen saves, then returns.
      // Actually previous design only returned. We need to update AddProductScreen too.
      // But for list screen, let's assume we refresh.
       _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atelier 4.1: SQLite'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
               return Center(child: Text('No products added yet!'));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) => Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(products[i].imageUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  title: Text(
                    products[i].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    products[i].description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: products[i],
                    );
                  },
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        Text('\$${products[i].price}'),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.error),
                          onPressed: () async {
                            await DatabaseHelper.instance
                                .deleteProduct(products[i].id);
                            _refreshProducts();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product deleted!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddProductScreen(context),
      ),
    );
  }
}
