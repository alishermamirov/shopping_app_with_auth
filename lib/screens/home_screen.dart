import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/custom_cart.dart';
import '../widgets/main_drawer.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FiltersOption {
  All,
  Favorites,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shopping App"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FiltersOption.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text("Barchasi"),
                  value: FiltersOption.All,
                ),
                const PopupMenuItem(
                  child: Text("Sevimli"),
                  value: FiltersOption.Favorites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return CustomCart(
                count: cart.itemCount(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: ProductsGrid(
        showOnlyFavorites: _showOnlyFavorites,
      ),
    );
  }
}
