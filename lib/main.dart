import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_with_auth/screens/auth_screen.dart';
import 'package:shopping_app_with_auth/screens/splash_screen.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manage_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_details_screen.dart';
import 'theme/shopping_app_theme.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = ShoppingAppTheme.theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, auth, previousProducts) =>
              previousProducts!..SetParams(auth.token, auth.userId),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrders) =>
              previousOrders!..SetParams(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: authData.isAuth
                ? const HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (context, autoLoginSnapshot) {
                      if (autoLoginSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const splashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    },
                  ),
            routes: {
              HomeScreen.routeName: (context) => HomeScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
              ManageProductScreen.routeName: (context) => ManageProductScreen(),
              ProductDetailsScreen.routeName: (context) =>
                  ProductDetailsScreen(),
            },
            // initialRoute: HomeScreen.routeName,
          );
        },
      ),
    );
  }
}
