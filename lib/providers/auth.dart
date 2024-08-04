import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _autologoutTimer;
  static const ApiKey = "AIzaSyBDQvfjvUqReGu1LsjEA8QOsHgdW6AaMYQ";

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      //token mavjud
      return _token;
    }
    //token mavjud emas
    return null;
  }

  String? get userId {
    return _userId;
  }


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

      _token = data["idToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            data["expiresIn"],
          ),
        ),
      );
      _userId = data["localId"];
      // _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences
          .getInstance(); //dastur va qurilmaning xotirasiga tunel
      final userData = jsonEncode(
        {
          "token": _token!,
          "userId": _userId!,
          "expiryDate": _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString("userdata", userData);

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

  
  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userdata")) {
      return false;
    }
    final userData =
        jsonDecode(prefs.getString("userdata")!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      //token muddati tugagan
      return false;
    }
    //token muddati tugamagan
    _token = userData["token"];
    _userId = userData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_autologoutTimer != null) {
      _autologoutTimer!.cancel();
      _autologoutTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("userdata");
    prefs.clear();
  }

  void _autoLogout() {
    if (_autologoutTimer != null) {
      _autologoutTimer!.cancel();
    }
    final timerToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    _autologoutTimer = Timer(Duration(seconds: timerToExpiry), () {
      logout();
    });
    notifyListeners();
  }
}
