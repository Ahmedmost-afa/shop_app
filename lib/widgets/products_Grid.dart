import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products = showFavs ? productData.favouriteItems 
                              : productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ) , 
      itemBuilder:(ctx, i) =>  ChangeNotifierProvider.value(
              value: products[i],
            child :  ProductItem(
                    // products[i].id ,
                    // products[i].title ,
                    // products[i].imageUrl 

                           )
      ),
      );
  }
}