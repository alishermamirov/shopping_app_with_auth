import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static const routeName = "/product-details";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Narxi:",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (context, cart, child) {
                final isAddedToCart = cart.items.containsKey(productId);
                if (isAddedToCart) {
                  return ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                    label: const Text(
                      "Savatga borish",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.green,
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green)),
                  );
                }
                return ElevatedButton.icon(
                  onPressed: () => cart.addToCart(productId, product.title,
                      product.price, product.imageUrl),
                  label: const Text(
                    "Savatga qo'shish",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
