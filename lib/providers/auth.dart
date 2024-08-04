import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  static const ApiKey = "AIzaSyBDQvfjvUqReGu1LsjEA8QOsHgdW6AaMYQ";

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$ApiKey");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      final data = jsonDecode(response.body);
      if (data["error"] != null) {
        throw HttpException(data["error"]["message"]);
      }

      // _token = data["idToken"];
      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(
      //       data["expiresIn"],
      //     ),
      //   ),
      // );
      // _userId = data["localId"];
      // _autoLogout();
      notifyListeners();

      // final prefs = await SharedPreferences
      //     .getInstance(); //dastur va qurilmaning xotirasiga tunel
      // final userData = jsonEncode(
      //   {
      //     "token": _token!,
      //     "userId": _userId!,
      //     "expiryDate": _expiryDate!.toIso8601String(),
      //   },
      // );
      // prefs.setString("userdata", userData);

      // prefs.setString("userId", _userId!);
      // prefs.setString("token", _token!);
      // prefs.setString("expiryDate", _expiryDate!.toIso8601String());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    //  ` final url = Uri.parse(
    //       "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$ApiKey");
    //   final response = await http.post(
    //     url,
    //     body: jsonEncode(
    //       {
    //         "email": email,
    //         "password": password,
    //         "returnSecureToken": true,
    //       },
    //     ),
    //   );
    //   print(jsonDecode(response.body));`

    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    // final url = Uri.parse(
    //     "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$ApiKey");

    // final response = await http.post(
    //   url,
    //   body: jsonEncode(
    //     {
    //       "email": email,
    //       "password": password,
    //       "returnSecureToken": true,
    //     },
    //   ),
    // );
    // print(jsonDecode(response.body));
    return _authenticate(email, password, "signInWithPassword");
  }
}
