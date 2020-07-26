import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_Grid.dart';
import '../widgets/badge.dart';

enum FilterOptions{
  All,
  Favourites
}

class ProductOverviewScreen extends StatefulWidget {
 
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        }); 
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
         centerTitle:  true,
         actions: [
           ShoppingCartBadge(),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue){
                  setState(() {
                       if(selectedValue == FilterOptions.Favourites){
                    _showOnlyFavourites = true;
                        }else{
                    _showOnlyFavourites = false;
                       }
                  });
               

              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) =>[
                PopupMenuItem(child: Text("only favourites"), value:FilterOptions.Favourites ,),
                PopupMenuItem(child: Text("All Products"), value: FilterOptions.All ,)
              ] ,
              ),
              
         ],
        // leading: shoppingCartBadge() ,
         
         ),
         drawer: AppDrawer(),

      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavourites),
    );
  }
}

