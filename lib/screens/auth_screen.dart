import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import '../providers/auth_provider.dart';

enum AuthMode { SignUp, LogIn }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-4 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: Text(
                        "Shop",
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Antone',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LogIn;
  Map<String, dynamic> _authData = {'email': '', 'password': ''};

  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<Size> _heightAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  //start submit function
  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.LogIn) {
        //login

        await Provider.of<AuthProvider>(context, listen: false)
            .logIn(_authData['email'], _authData['password']);
      } else {
        //signUp
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
        setState(() {
          _isLoading = false;
        });
      }
    } on HttpException catch (_) {
      setState(() {
        _isLoading = false;
      });
      return _showErrorDialog("This Email is Invalid");
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      return _showErrorDialog("Something Wrong try again later");
    }

    //  on HttpException catch(error){
    //     var errorMessage = "Authentication Failed";
    //     if(error.toString().contains('EMAIL_EXISTS')){
    //       errorMessage = "This is Account Is Already Exists";
    //     }else if (error.toString().contains('INVALID_EMAIL')){
    //         errorMessage = "Please write a valid email";
    //     }else if (error.toString().contains('WEAK_PASSWORD')){
    //         errorMessage = "Your Password is too weak";
    //     }else if (error.toString().contains('EMAIL_NOT_FOUND') || error.toString().contains('INVALID_PASSWORD')){
    //         errorMessage = "This is Email or password is wrong";
    //     }
    //   return  _showErrorSnackbar(errorMessage);
    // }catch(error){
    //    const errorMessage = "Please Try again later";
    //   return _showErrorSnackbar(errorMessage);
    // }
  }
  //end submit function

  //start switch auth mode function
  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
      _controller.reverse();
    }
  }
  //end switch auth mode

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "password"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return "password should be more than 5 charcter";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: "confirm password"),
                      obscureText: true,
                      validator: _authMode == AuthMode.SignUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return "passwords are not match";
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                            _authMode == AuthMode.LogIn ? "LogIn" : "signUp"),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                FlatButton(
                  child: Text(
                      "GO TO ${_authMode == AuthMode.LogIn ? 'SIGNUP' : 'LOGIN'}"),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
