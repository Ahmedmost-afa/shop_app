import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(PorductDetailsScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  product.toogleFavouriteStatus(
                      authData.token, authData.userId);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context)
                    .hideCurrentSnackBar(); //for avoid the conflict when add multible items quickly
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Added to the cart"),
                  duration: Duration(seconds: 4),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.undoSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

//product.isFavourite ? Icons.favorite :
