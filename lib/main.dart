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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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
