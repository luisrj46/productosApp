import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  Product? product;

  ProductFormProvider(this.product);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
