import 'package:flutter/material.dart';
import 'package:shop_app/providers/order_provider.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "\$${widget.order.amount}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            subtitle: Text(
              DateFormat("dd MM yyyy hh:mm").format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20 , vertical : 4),
                height: min(widget.order.products.length * 20.0 + 10, 100),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.bold),

                            ),
                            SizedBox(height: 10,),
                            Text(
                              "${prod.quantity}x ",
                              style: TextStyle(color: Colors.grey , fontWeight: FontWeight.bold),
                              
                            ),
                             Text(
                              " ${prod.price}",
                              style: TextStyle(color: Theme.of(context).accentColor , fontWeight: FontWeight.bold),
                              
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ))
        ],
      ),
    );
  }
}
