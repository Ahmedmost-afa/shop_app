import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class ShoppingCartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_,cart ,ch) => Badge(
      position: BadgePosition.topRight(top: 0, right: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        cart.itemsCount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: ch,
    ),
    child: IconButton(
        icon: Icon(
        Icons.shopping_cart),
         onPressed: () {
           Navigator.of(context).pushNamed(CartScreen.routeName);
         }
          
         ),
    );
  }
}
  
