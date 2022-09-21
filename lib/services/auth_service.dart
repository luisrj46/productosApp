import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firbaseToken = 'AIzaSyB0gEQzW1gE4qMM-c-5pvn5gw3xxrmBuRQ';

  final storage = new FlutterSecureStorage();
  // si regresa null es que todo bien
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firbaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedRes = json.decode(resp.body);

    if (decodedRes.containsKey('idToken')) {
      // Write value
      await storage.write(key: 'token', value: decodedRes['idToken']);
      // return decodedRes['idToken'];
      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  // si regresa null es que todo bien
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firbaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedRes = json.decode(resp.body);

    if (decodedRes.containsKey('idToken')) {
      // Write value
      await storage.write(key: 'token', value: decodedRes['idToken']);

      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> hasToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
