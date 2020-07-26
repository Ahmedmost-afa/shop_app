import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _exipreDate;
  String _userId;
  Timer _authorTimer;

  bool get isAuth {
    return token !=
        null; //return token function in case it us not equal to null
  }

  String get token {
    if (_exipreDate != null &&
        _exipreDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
  String get userId{
    return _userId;
  }

// Future<void> _authenticate(String email , String password , String urlSegment) async{
//   final url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCajKkcnRlBD-PRjVaKr3zWEdmE2OQ0CU4";

//       final response = await http.post(url , body: json.encode({
//     'email' : email,
//     'password' : password,
//     'returnSecureToken' : true
//   }),
//   );
//   print(json.decode(response.body));
//   // final responseData = json.decode(response.body);
//   // if(responseData['error'] != null){
//   //   throw HttpException(responseData['error']['message']);
//   // }

// }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCajKkcnRlBD-PRjVaKr3zWEdmE2OQ0CU4";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCajKkcnRlBD-PRjVaKr3zWEdmE2OQ0CU4";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData["localId"];
      _exipreDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData["expiresIn"])),
      );
      //_autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate':_exipreDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

    Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
   _exipreDate = expiryDate;
    notifyListeners();
   // _autoLogout();
    return true;
  }

  // Future<void> logout() async{
  //   _token = null;
  //   _userId = null;
  //   _exipreDate = null;
  //   if(_authorTimer != null){
  //     _authorTimer.cancel();
  //     _authorTimer = null;
  //   }
  //   notifyListeners();
  //  final prefs = await SharedPreferences.getInstance();
  //   // prefs.remove('userData');
  //   prefs.clear();
  // }

  // void _autoLogout(){
  //   if(_authorTimer != null){
  //     _authorTimer.cancel();
  //   }
  //   final timeToExpire = _exipreDate.difference(DateTime.now()).inSeconds;
    
  //   _authorTimer =  Timer(Duration(seconds: timeToExpire) , logout);
  // }
}
