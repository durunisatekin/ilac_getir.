import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print("Hata oluştu");
    }
  }
}
