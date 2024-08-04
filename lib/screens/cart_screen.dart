// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_list_item.dart';
import 'orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Savatcha"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Umumiy:",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalPrice().toStringAsFixed(2)} ",
                        style: const TextStyle(
                          // fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: cart.items.isEmpty
                  ? const Center(
                      child: Text(
                        "Savatcha bo'sh",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cart.items.values.toList()[index];
                        return CartListItem(
                          id: cart.items.keys.toList()[index],
                          image: cartItem.image,
                          title: cartItem.title,
                          price: cartItem.price,
                          quantity: cartItem.quantity,
                        );
                      },
                    ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.items.isEmpty
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addToOrders(
                widget.cart.totalPrice(),
                widget.cart.items.values.toList(),
              );
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
              "Buyurtma qilish",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
    );
  }
}
