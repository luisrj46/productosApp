import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductsServices>(context);
    final authService = Provider.of<AuthService>(context);

    if (productServices.isloading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
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
        onPressed: () {
          productServices.productSelect =
              Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
