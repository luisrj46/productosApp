import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firbaseToken = 'AIzaSyB0gEQzW1gE4qMM-c-5pvn5gw3xxrmBuRQ';

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firbaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedRes = json.decode(resp.body);

    print(decodedRes);
  }
}
