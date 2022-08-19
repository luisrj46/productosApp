import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  //
  final String _baseUrl = 'flutter-varios-968f4-default-rtdb.firebaseio.com';

  final List<Product> products = [];

  bool isloading = true;

  ProductsServices() {
    print("object");
    loadProducts();
  }
  //TODO
  Future loadProducts() async {
    final url = Uri.https(_baseUrl, 'Product.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productMap = json.decode(resp.body);

    productMap.forEach((key, value) {
      final tempProduc = Product.fromMap(value);
      tempProduc.id = key;
      products.add(tempProduc);
      print(products[0].name);
    });
  }

  //TODO: hacer fecht de productos
}
