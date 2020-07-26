import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false
      
      });


  void _setFavouriteValue(bool newValue){
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toogleFavouriteStatus(String token , String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://shop-dc55c.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(isFavourite));

      if(response.statusCode >= 400){
        _setFavouriteValue(oldStatus);
        // isFavourite = oldStatus;
        // notifyListeners();
      }
    } catch (error) {
      _setFavouriteValue(oldStatus);
      // isFavourite = oldStatus;
      // notifyListeners();
    }
  }
}
