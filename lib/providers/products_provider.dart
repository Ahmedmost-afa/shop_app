import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: "Laptop",
    //   description: "this is hp laptop",
    //   price: 22,
    //   imageUrl:
    //       "https://www.lenovo.com/medias/lenovo-laptop-ideapad-flex-5-15inch-front.png?context=bWFzdGVyfHJvb3R8MTMzODY2fGltYWdlL3BuZ3xoY2EvaDhhLzEwODAyMDgxMzk4ODE0LnBuZ3w3NThjNWVmMmY2NzliZDBkNmI4NTE3ZWFmNmY3N2M5NmQ1YzdlMzJkMGJmZjQ0YmY5ZGRhM2I4YjA3YWRlNjFm&w=480",
    // ),
    // Product(
    //   id: 'p2',
    //   title: "Mobile",
    //   description: "this is mobile phone",
    //   price: 10,
    //   imageUrl:
    //       "https://shop.orange.eg/content/images/thumbs/0001515_infinix-s4_550.jpeg",
    // ),
    // Product(
    //   id: 'p3',
    //   title: "Camera",
    //   description: "this is Camera",
    //   price: 10,
    //   imageUrl:
    //       "https://shams-stores.com/wp-content/uploads/2019/12/1566949680_1502489.jpg",
    // ),
    // Product(
    //   id: 'p4',
    //   title: "Fridge",
    //   description: "this is Fridge",
    //   price: 15,
    //   imageUrl:
    //       "https://cf.shopee.com.my/file/79e75b8c5d369183cb09afa73b7a58c7",
    // ),
  ];

  String authToken;
  String userId;
  
  ProductsProvider([this._items , this.authToken , this.userId]);

  List<Product> get items {
    return [..._items];
  }

  //function for distinguish between favourites case and all in product overvirew screen

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://shop-dc55c.firebaseio.com/products.json?auth=$authToken'; //the link of your database and /products for naming the folder in it

    try {
      final response = await http.post(
        url,
        body: json.encode({
          //using dart convert package for encoding json
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId' : userId,
        }),
      );

      // print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('error of adding product');
      throw error;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url = 'https://shop-dc55c.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
     // print(json.decode(response.body));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if(fetchedData == null){
        return;
      }
         url = 'https://shop-dc55c.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
       final favouriteResponse = await http.get(url); 
       final favouriteData = json.decode(favouriteResponse.body);
        final List<Product> loadedData = [];
      fetchedData.forEach((prodId, prodData) {
        loadedData.add(Product(
          id: prodId,
          title: prodData['title'],
           description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
       throw error.toString();
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    
      if (prodIndex >= 0) {
        final url = 'https://shop-dc55c.firebaseio.com/products/$id.json?auth=$authToken';
       // try {
         await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "price": newProduct.price,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
          }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        print("...");
      }
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-dc55c.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

     _items.removeWhere((prod) => prod.id == id);
      notifyListeners();

   final response =  await http.delete(url);
   if(response.statusCode >= 400){
     _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
       throw HttpException("Could not delete Product");
   }

      existingProduct = null;

  }
}
