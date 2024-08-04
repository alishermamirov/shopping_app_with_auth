import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import '../models/product.dart';
import '../services/http_exception.dart';

class Products with ChangeNotifier {
  String? _authToken;
  String? _userId;
  void SetParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> _list = [];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _list.firstWhere((element) => element.id == id);
  }

  Future<void> getProductFromFirebase([bool filterbyUser = false]) async {
    final filterString =
        filterbyUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString");

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final List<Product> loadedProduct = [];
        final FavoriteUrl = Uri.parse(
            "https://shopping-app-8d541-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken");
        final favoriteReponse = await http.get(FavoriteUrl);
        print(favoriteReponse.body);
        final favoriteData = jsonDecode(favoriteReponse.body);

        data.forEach(
          (key, value) {
            loadedProduct.add(
              Product(
                id: key,
                title: value["title"],
                description: value["description"],
                imageUrl: value["imageUrl"],
                price: value["price"],
                isFavorite:
                    favoriteData == null ? false : favoriteData[key] ?? false,
              ),
            );
          },
        );
        _list = loadedProduct;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products.json?auth=$_authToken");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId": _userId,
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
          "https://shopping-app-8d541-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json?auth=$_authToken");
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
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken");
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
