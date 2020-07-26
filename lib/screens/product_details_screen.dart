import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class PorductDetailsScreen extends StatelessWidget {
  static const routeName = "./poduct-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProdct = Provider.of<ProductsProvider>(context , listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProdct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: loadedProdct.id,
                child: Image.network(
                  loadedProdct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              loadedProdct.title,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "\$${loadedProdct.price}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                loadedProdct.description,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
