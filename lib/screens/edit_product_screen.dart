import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class EditProducts extends StatefulWidget {
  static const routeName = "./edit-products";
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _isInit = true;
    bool isLoading = false;
  var initValues = {
    "title": '',
    "price": '',
    "description": '',
    "imageUrl": '',
  };



  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context , listen: false).findById(productId);
        initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
          //"imageUrl": _editedProduct.imageUrl,
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final _isvalid = _form.currentState.validate();
    if (!_isvalid) {
      return; //here the function will end , the code after that in the function will be dead
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
    await Provider.of<ProductsProvider>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
      await  showDialog(  //you should await it , if not I will not works
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Row(
                    children: [
                      Text("OOPS Its From us not you"),
                      Icon(Icons.sentiment_dissatisfied),
                    ],
                  ),
                  content: Text(
                      "Something went wrong , please contact us and try again later"),
                  actions: [
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ],
                ));
      } 
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit products"),
        elevation: 0,
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.grey[200]),
            ),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).accentColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues["title"],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["price"],
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (double.tryParse(value) == null) {
                          return "Please enter your product price";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a price greater than 0";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["description"],
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter your product description";
                        }
                        if (value.length < 10) {
                          return "please youe description should be more than 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  "Enter your image url",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return " please provide your product image";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return " please enter a valid image url";
                              }
                              if (!value.endsWith("jpg") &&
                                  !value.endsWith("png") &&
                                  value.endsWith("jpeg")) {
                                return " please enter a valid image url";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
