// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    Key? key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          leading: Consumer<Product>(
            builder: (context, prod, child) => IconButton(
              onPressed: () => prod.toggleFavorite(),
              icon: Icon(
                prod.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Savatga qo'shildi"),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  action: SnackBarAction(
                    label: "Bekor qilish",
                    onPressed: () {
                      cart.removeSingleItem(product.id, isCartButton: true);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: product.id),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
