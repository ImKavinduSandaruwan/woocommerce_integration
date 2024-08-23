import 'package:http/http.dart' as http;
import 'dart:convert';

class WooCommerceService {
  final String baseUrl = 'https://hayaku.me/wp-json/wc/v3/';
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
      throw Exception('Failed to load products');
    }
  }
}
