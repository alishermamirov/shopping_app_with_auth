import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import '../models/product.dart';
import '../services/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: '1',
    //   title: 'Laptop',
    //   description: 'High performance laptop with 16GB RAM and 512GB SSD.',
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    //   price: 1200.00,
    // ),
    // Product(
    //   id: '2',
    //   title: 'Smartphone',
    //   description: 'Latest model smartphone with 5G connectivity.',
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    //   price: 800.00,
    // ),
    // Product(
    //   id: '3',
    //   title: 'Wireless Headphones',
    //   description:
    //       'Noise-cancelling wireless headphones with long battery life.',
    //   imageUrl:
    //       'https://plus.unsplash.com/premium_photo-1683531060718-4dd0a8f2a692?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YWlycG9kfGVufDB8fDB8fHww',
    //   price: 150.00,
    // ),
  ];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _list.firstWhere((element) => element.id == id);
  }

  Future<void> getProductFromFirebase() async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products.json");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProduct = [];

        data.forEach(
          (key, value) {
            // final favoriteUrl = Uri.parse(
            //     "https://shopping-app-8d541-default-rtdb.firebaseio.com/favorites/$key.json");
            // final favoriteRespponse = await http.get(favoriteUrl);
            // var isFavorite = (jsonDecode(favoriteRespponse.body)
            //         as Map<String, dynamic>)["isFavorite"] ??
            //     false;
            // print(isFavorite);
            loadedProduct.add(
              Product(
                id: key,
                title: value["title"],
                description: value["description"],
                imageUrl: value["imageUrl"],
                price: value["price"],
                // isFavorite: isFavorite,
                // isFavorite: value["isFavorite"]
              ),
            );
          },
        );
        _list = loadedProduct;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            // "isFavorite": product.isFavorite,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)["name"];
      _list.add(
        Product(
          id: name,
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    int index = _list.indexWhere(
      (element) => element.id == updatedProduct.id,
    );
    if (index >= 0) {
      final url = Uri.parse(
          "https://shopping-app-8d541-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json");
      try {
        await http.patch(
          url,
          body: jsonEncode({
            "title": updatedProduct.title,
            "description": updatedProduct.description,
            "imageUrl": updatedProduct.imageUrl,
            "price": updatedProduct.price,
            // "isFavorite": updatedProduct.isFavorite,
          }),
        );
      } catch (e) {
        rethrow;
      }
      _list[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products/$id.json");
    try {
      final deletedProduct = _list.firstWhere((element) => element.id == id);
      final index = _list.indexWhere(
        (element) => element.id == id,
      );
      _list.removeWhere((element) => element.id == id);
      final response = await http.delete(url);
      print(response.statusCode);
      if (response.statusCode >= 400) {
        _list.insert(index, deletedProduct);
        throw HttpExceptions(message: "O'chirishda xatolik");
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
