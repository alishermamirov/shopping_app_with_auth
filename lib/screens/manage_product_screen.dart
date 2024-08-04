import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const routeName = "/manage-product";
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getProductFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulatlarni boshqarish"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (context, products, child) {
                      return ListView.builder(
                        itemCount: products.list.length,
                        itemBuilder: (context, index) {
                          final product = products.list[index];
                          return ChangeNotifierProvider<Product>.value(
                            value: product,
                            child: const UserProductItem(),
                          );
                        },
                      );
                    },
                  ));
            } else {
              return const Center(
                child: Text("Xatolik sodir bo'ldi"),
              );
            }
          }),
    );
  }
}
