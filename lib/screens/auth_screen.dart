import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum authMode { Registr, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = "auth-screen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  authMode _authmode = authMode.Login;

  var _loading = false;

  Map<String, String> _authData = {
    "e": "",
    "p": "",
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Xatolik"),
          content: Text("$message"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });
      try {
        if (_authmode == authMode.Login) {
          await Provider.of<Auth>(context, listen: false).login(
            _authData["e"]!,
            _authData["p"]!,
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signup(
            _authData["e"]!,
            _authData["p"]!,
          );
        }
      } on HttpException catch (error) {
        print(error);
        var errorMessage = "Xatolik sodir bo'ldi";
        if (error.message.contains("EMAIL_EXISTS")) {
          errorMessage = "Email band";
        } else if (error.message.contains("INVALID_EMAIL")) {
          errorMessage = "To'g'ri email kiriting";
        } else if (error.message.contains("WEAK_PASSWORD")) {
          errorMessage = "Juda oson parol";
        } else if (error.message.contains("EMAIL_NOT_FOUND")) {
          errorMessage = "Bu email bilan foydalanuvchi topilmadi";
        } else if (error.message.contains("INVALID_PASSWORD")) {
          errorMessage = "Parol noto'g'ri";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        print(e);
        var errorMessage =
            "Kechirasiz xatolik sodir bo'ldi,qaytadan urinib ko'ring";
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _loading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authmode == authMode.Login) {
      setState(() {
        _authmode = authMode.Registr;
      });
    } else {
      setState(() {
        _authmode = authMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 150,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  //  border: OutlineInputBorder(),
                  labelText: "Email manzil",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos Emailni kiriting";
                  } else if (!value.contains("@")) {
                    return "Iltimos to'g'ri email kiriting";
                  }
                  return null;
                },
                onSaved: (email) {
                  _authData["e"] = email!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                onSaved: (parol) {
                  _authData["p"] = parol!;
                },
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos Parolni kiriting";
                  } else if (value.length < 5) {
                    return "Parol juda oson";
                  }
                  return null;
                },
                obscureText: true,
              ),
              _authmode == authMode.Registr
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: "Parolni tasdiqlash",
                          ),
                          validator: (confirmedPassword) {
                            if (_passwordController.text != confirmedPassword) {
                              // print(_passwordController);
                              // print(confirmedPassword);
                              return "Parollar bir biriga mos kelmadi";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 60,
              ),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.teal,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        setState(() {
                          _submit();
                        });
                      },
                      child: Text(
                        _authmode == authMode.Login
                            ? "Kirish"
                            : "Ro'yxatdan o'tish",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  _switchAuthMode();
                },
                child: Text(
                  _authmode == authMode.Login ? "Ro'yxatdan o'tish" : "Kirish",
                  style: const TextStyle(
                    color: Colors.teal,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
