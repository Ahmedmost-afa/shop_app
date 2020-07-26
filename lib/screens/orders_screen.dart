import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';


class OrdersScreen extends StatefulWidget {
  //static const routeName = "/orders";
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        isLoading = true;
      });
     await Provider.of<Order>(context , listen: false).fetchAndSetOrders();
     setState(() {
       isLoading = false;
     });
    } );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx , i) => OrderItemWidget(ordersData.orders[i]),
      ) ,
    );
  }
}