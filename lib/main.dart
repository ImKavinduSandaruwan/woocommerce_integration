import 'package:flutter/material.dart';
import 'woocommerce_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WooCommerce Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final WooCommerceService _service = WooCommerceService();
  late Future<List<dynamic>> _products;

  @override
  void initState() {
    super.initState();
    _products = _service.fetchProducts();
  }

  void _addProduct() async {
    Map<String, dynamic> newProductData = {
      'name': 'New Product',
      'type': 'simple',
      'regular_price': '29.99',
      'description': 'This is a new product',
      'short_description': 'A short description of the new product',
      'sku': 'NP001',
      'manage_stock': true,
      'stock_quantity': 100,
      'categories': [
        {'id': 15} // Ensure this category ID exists in WooCommerce
      ],
      'images': [
        {'src': 'https://i.imgur.com/example.jpg'} // Replace with a valid image URL
      ],
    };

    try {
      await _service.addProduct(newProductData);
      setState(() {
        _products = _service.fetchProducts(); // Refresh the product list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  void _removeProduct(int productId) async {
    try {
      await _service.removeProduct(productId);
      setState(() {
        _products = _service.fetchProducts(); // Refresh the product list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct, // Add a product
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<dynamic> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price']}'),
                  leading: Image.network(
                    product['images'][0]['src'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeProduct(product['id']); // Remove a product
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
