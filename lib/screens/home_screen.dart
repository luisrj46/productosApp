import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductsServices>(context);

    if (productServices.isloading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productServices.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productServices.productSelect =
                productServices.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productServices.products[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
