import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> getOrderfromFirebase() async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/orders.json");

    try {
      final List<Order> loadedOrders = [];
      final response = await http.get(url);
      if (response.statusCode == 200 && jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        data.forEach(
          (key, value) {
            loadedOrders.insert(
              0,
              Order(
                id: key,
                totalprice: value["totalprice"],
                date: DateTime.parse(value["date"]),
                products: (value["products"] as List<dynamic>)
                    .map(
                      (product) => CartItem(
                        id: product["id"],
                        title: product["title"],
                        quantity: product["quantity"],
                        price: product["price"],
                        image: product["image"],
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      }
      _items = loadedOrders;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToOrders(double totalPrice, List<CartItem> products) async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/orders.json");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "totalprice": totalPrice,
            "date": DateTime.now().toIso8601String(),
            "products": products
                .map(
                  (product) => {
                    "id": product.id,
                    "title": product.title,
                    "quantity": product.quantity,
                    "image": product.image,
                    "price": product.price,
                  },
                )
                .toList()
          },
        ),
      );

      final name = jsonDecode(response.body)["name"];
      _items.insert(
        0,
        Order(
          id: name,
          totalprice: totalPrice,
          date: DateTime.now(),
          products: products,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
