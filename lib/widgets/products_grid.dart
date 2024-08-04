// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';
import 'product_grid_item.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    Key? key,
    required this.showOnlyFavorites,
  }) : super(key: key);

  final bool showOnlyFavorites;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future _productFuture;
  @override
  void initState() {
    super.initState();
    _productFuture = getProducts();
  }

  Future getProducts() async {
    return Provider.of<Products>(context, listen: false)
        .getProductFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return Consumer<Products>(
              builder: (context, productData, child) {
                final products = widget.showOnlyFavorites
                    ? productData.favorites
                    : productData.list;
                return products.isEmpty
                    ? const Center(
                        child: Text("Mahsulotlar mavjud emas"),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider<Product>.value(
                            value: products[index],
                            child: const ProductGridItem(),
                          );
                        },
                      );
              },
            );
          } else {
            return const Center(
              child: Text("Xatolik yuz berdi"),
            );
          }
        }
      },
    );
  }
}
