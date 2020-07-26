import 'package:flutter/material.dart';
import 'package:shop_app/providers/order_provider.dart';
import './screens/splash_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './screens/auth_screen.dart';
import './providers/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductsProvider prod;
    Order order;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider(prod == null ? [] : prod.items),
          update: (ctx, auth, previousProducts) => ProductsProvider(
            previousProducts == null ? [] : previousProducts.items,
            auth.token,
            auth.userId,
          ),
        ),
        // ChangeNotifierProvider.value(
        //   value: ProductsProvider(),
        // ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<AuthProvider, Order>(
          create: (ctx) => Order(order == null ? [] : order.orders),
          update: (ctx, auth, previousOrders) => Order(
            previousOrders == null ? [] : previousOrders.orders,
            auth.token,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.deepOrange,
            fontFamily: "roboto",
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            PorductDetailsScreen.routeName: (ctx) => PorductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProducts.routeName: (ctx) => EditProducts(),
            // OrdersScreen.routeName: (ctx) => OrdersScreen(),
          },
        ),
      ),
    );
  }
}
