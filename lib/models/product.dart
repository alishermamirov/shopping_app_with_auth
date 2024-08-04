import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String? token, String? userId) async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    print(isFavorite);
    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token");
    try {
      final reponse = await http.patch(
        url,
        body: jsonEncode({
          "$id": isFavorite,
        }),
      );

      if (reponse.statusCode >= 400) {
        isFavorite = oldFavorite;
      }
      notifyListeners();
      print(reponse.statusCode);
    } catch (error) {
      print(error);
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
