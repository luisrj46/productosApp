import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  //
  final String _baseUrl = 'flutter-varios-968f4-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  Product? productSelect;

  bool isloading = true;
  bool isSaving = false;

  File? newPictureFile;

  final storage = FlutterSecureStorage();

  ProductsServices() {
    loadProducts();
  }
  //TODO
  Future<List<Product>> loadProducts() async {
    isloading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'Product.json',
        {'auth': await storage.read(key: 'token') ?? ''});
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
    final url = Uri.https(_baseUrl, 'Product/${product.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);

    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Product.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: product.toJson());
    final decodeData = jsonDecode(resp.body);
    product.id = decodeData['name'];

    products.add(product);
    print(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    productSelect!.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dghficsa2/image/upload?upload_preset=productApp');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);

    return decodedData['secure_url'];
  }
}
