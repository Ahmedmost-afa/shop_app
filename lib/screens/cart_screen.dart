import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = './cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        elevation: 0,
        actions: [
          FlatButton(
          child: Text("Your Orders" , style: TextStyle(color: Colors.grey[200]),),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen()));
          },
        ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        child: cart.totalPrice > 0
                            ? Icon(Icons.tag_faces)
                            : Icon(Icons.sentiment_dissatisfied)),
                    label: Text('\$${cart.totalPrice}'),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  OrderButton(order: order, cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) => CartItemWidget(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.order,
    @required this.cart,
  }) : super(key: key);

  final Order order;
  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return FlatButton(
      child: isLoading ? CircularProgressIndicator() : Text(
        "Order Now",
        style: TextStyle(
          color:
              Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      autofocus: true,
      color: Theme.of(context).accentColor,
      onPressed: (widget.cart.totalPrice <= 0 || isLoading ) ? null : () async {
        // Provider.of<Order>(context , listen: false).addOrder(
        //   cart.items.values.toList(),
        //    cart.totalPrice
        //    );
        try {
            setState(() {
          isLoading = true;
        });
         await widget.order.addOrder(widget.cart.items.values.toList(), widget.cart.totalPrice);

          setState(() {
            isLoading = false;
          });

           widget.cart.clearCart();
       }
         catch (error) {
          scaffold.showSnackBar(SnackBar(
                    content: Text("Ordering Failed!!! Please try Again later")
                     ),
                    );
                    setState(() {
                      isLoading = false;
                    });
        }
      
           
      },
    );
  }
}
