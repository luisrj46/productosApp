import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  //
  final String _baseUrl = 'flutter-varios-968f4-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  Product? productSelect;

  bool isloading = true;
  bool isSaving = false;

  ProductsServices() {
    loadProducts();
  }
  //TODO
  Future<List<Product>> loadProducts() async {
    isloading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'Product.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productMap = json.decode(resp.body);

    productMap.forEach((key, value) {
      final tempProduc = Product.fromMap(value);
      tempProduc.id = key;
      products.add(tempProduc);
    });

    isloading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //producto nuevo
      await createProduct(product);
    } else {
      // actualizar producto
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Product/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);

    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Product.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = jsonDecode(resp.body);
    product.id = decodeData['name'];

    products.add(product);
    print(product);
    return product.id!;
  }
}
