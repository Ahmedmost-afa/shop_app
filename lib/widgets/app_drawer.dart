import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import '../screens/orders_screen.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello Friend!" , style: TextStyle(color: Colors.grey),),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen()));
                
            },
          ),
           ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Mnage Products"),
            onTap: () {
             Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
                
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: const Icon(Icons.exit_to_app),
          //   title: const Text("Logout"),
          //   onTap: () {
          //   Navigator.of(context).pop();
          //   Provider.of<AuthProvider>(context , listen: false).logout();
                
          //   },
          // ),
        ],
      ),
    );
  }
}
