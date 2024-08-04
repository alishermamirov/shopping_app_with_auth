// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    Key? key,
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  void showDeletingDialog(BuildContext context, Function removeItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("O'chirilmoqda"),
          content: Text("Ushbu mahsulot savatdan o'chirilmoqda"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Bekor qilish")),
            ElevatedButton(
                onPressed: () {
                  removeItem();
                  Navigator.of(context).pop();
                },
                child: Text("O'chirish"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(id),
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: ScrollMotion(), children: [
        ElevatedButton(
          onPressed: () =>
              showDeletingDialog(context, () => cart.removeItem(id)),
          child: Text(
            "O'chirish",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.red,
          ),
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 0.4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                image,
              ),
            ),
            title: Text("$title  (x$quantity)"),
            subtitle:
                Text("Umumiy: \$${(quantity * price).toStringAsFixed(2)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => cart.removeSingleItem(id),
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2)),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  onPressed: () => cart.addToCart(id, title, price, image),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
