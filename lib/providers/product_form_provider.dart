import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  Product? product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    product!.available = value;
    notifyListeners();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    print(product!.name);
    print(product!.available);
    print(product!.price);
    return formKey.currentState?.validate() ?? false;
  }
}
