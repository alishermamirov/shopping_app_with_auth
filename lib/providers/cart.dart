import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemCount() {
    return _items.length;
  }

  double totalPrice() {
    double price = 0.0;
    _items.forEach(
      (key, value) {
        price += value.price * value.quantity;
      },
    );
    return price;
  }

  void addToCart(String productId, String title, double price, String image) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          quantity: currentProduct.quantity + 1,
          price: currentProduct.price,
          image: currentProduct.image,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          quantity: 1,
          price: price,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId, {bool isCartButton = false}) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          quantity: currentProduct.quantity - 1,
          price: currentProduct.price,
          image: currentProduct.image,
        ),
      );
      notifyListeners();
    } else if (isCartButton) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
