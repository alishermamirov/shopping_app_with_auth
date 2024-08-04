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

  Future<void> toggleFavorite() async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        "https://shopping-app-8d541-default-rtdb.firebaseio.com/favorites/$id.json");
    try {
      final reponse = await http.put(
        url,
        body: jsonEncode({
          "isFavorite": isFavorite,
        }),
      );
      if (reponse.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
