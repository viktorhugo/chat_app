import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService implements ChangeNotifier {

  late User user;

  Future login(String email, String password) async {
    var url = Uri.parse('${Environment.apiURL}/auth/login');
    print(url);
    final body  = {
      'email': email,
      'password': password
    };
    var response = await http.post(
      url, 
      body: jsonEncode(body),
      headers: { 'Content-Type': 'application/json'}
    );

    if (response.statusCode == 200 ||response.statusCode == 201) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
    }
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future register( String userName, String email, String password ) async{

    var url = Uri.https(Environment.apiURL, 'users/register');
    final body  = {
      'userName': userName,
      'email': email,
      'password': password
    };
    var response = await http.post(url, body: jsonEncode(body));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

}