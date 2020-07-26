import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.date});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  Order([  this._orders  , this.authToken ,  this.userId]);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> orderProducts, double total) async {
    final url = 'https://shop-dc55c.firebaseio.com/orders/$userId.json?auth=$authToken';
    var timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp
              .toIso8601String(), //it will make a fucking error if you do not put date to string
          'products': orderProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }),
      ); // post function
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: orderProducts,
            date: timeStamp,
          ));
      notifyListeners();
    } catch (error) {
      print('failed adding order');
      throw error;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-dc55c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if(extractedOrders == null){
      return;
    }
    extractedOrders.forEach((orderId, orderData) {

      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        date: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((prodItem) => CartItem(
                  id: prodItem['id'],
                  price: prodItem['price'],
                  quantity: prodItem['quantity'],
                  title: prodItem['title'],
                )).toList(),
            
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
