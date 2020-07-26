import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItemWidget(this.id, this.productId, this.title, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right:10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog( 
          context: context , 
          builder: (ctx) => AlertDialog(
            title: Text("Are you shure ?"),
            content: Text("Do you want to remove this product from the cart ?"),
            actions: [
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                  child: Text("No"),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
          );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context , listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text("\$$price")),
              ),
            ),
            title: Text(title),
            subtitle: Text("Kindly Total is : \$${(price * quantity)}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
