import 'package:http/http.dart' as http;
import 'dart:convert';

class WooCommerceService {
  final String baseUrl = 'https://hayaku.me/wp-json/wc/v3';
  final String consumerKey = 'ck_a5894785668500c5f68c7a3db9bd78d1bd9274ee';
  final String consumerSecret = 'cs_70c3836e204c53464445897983f14b21a6f64a7a';

  // Function to fetch products from WooCommerce
  Future<List<dynamic>> fetchProducts() async {
    final url = Uri.parse(
        '$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Function to add a product to WooCommerce
  Future<void> addProduct(Map<String, dynamic> productData) async {
    final url = Uri.parse(
        '$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 201) {
      print('Product added successfully');
    } else {
      print('Failed to add product: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add product: ${response.statusCode}');
    }
  }

  // Function to remove a product from WooCommerce
  Future<void> removeProduct(int productId) async {
    final url = Uri.parse(
        '$baseUrl/products/$productId?consumer_key=$consumerKey&consumer_secret=$consumerSecret');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Product removed successfully');
    } else {
      throw Exception('Failed to remove product: ${response.statusCode}');
    }
  }
}
