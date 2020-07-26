import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshData(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productData, _) => ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (_, i) => UserProductItem(
                                productData.items[i].id,
                                productData.items[i].title,
                                productData.items[i].imageUrl,
                              )),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProducts.routeName);
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        foregroundColor: Colors.grey[200],
      ),
    );
  }
}
