import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthService implements ChangeNotifier {

  var logger = Logger();
  late User user;
  bool _authenticating = false;
  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;

  set authenticating(bool value) { 
    _authenticating = value;
    notifyListeners();
  }

  // GETTERS TOKEN 
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token') ?? '';
  }

  // GETTERS TOKEN 
  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    return await storage.delete(key: 'token');
  }

  // LOGIN METHOD
  Future login(String email, String password) async {
    authenticating = true;
    var url = Uri.parse('${Environment.apiURL}/auth/login');
    // logger.d("url $url");

    final body  = {
      'email': email,
      'password': password
    };
    var response = await http.post(
      url, 
      body: jsonEncode(body),
      headers: { 'Content-Type': 'application/json'}
    );
    // logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');
    authenticating = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await saveToken(loginResponse.token);
      return true;
    }
    if (response.statusCode == 401 || response.statusCode == 400) {
      // final loginResponse = response.body;
      return false;
    }
  }

  // REGISTER METHOD
  Future register( String userName, String email, String password ) async{

    authenticating = true;
    var url = Uri.parse('${Environment.apiURL}/users/register');
    final body  = {
      'name': userName,
      'email': email,
      'password': password
    };
    var response = await http.post(
      url, 
      body: jsonEncode(body),
      headers: { 'Content-Type': 'application/json'}
    );
    // logger.d('Response status: ${response.statusCode}');
    logger.d('Response body: ${response.body}');
    authenticating = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await saveToken(loginResponse.token);
      return {'state': true, 'message': null};
    }
    if (response.statusCode == 401 || response.statusCode == 400) {
      // logger.d('Response body: ${json.decode(response.body)['error']}');
      return {'state': false, 'message': json.decode(response.body)['error']};
    }
  }

  Future<bool> checkToken() async {
    final token = await _storage.read(key: 'token');
    // logger.d('token: $token');
    if ( token == null ) return false;

    var url = Uri.parse('${Environment.apiURL}/auth/token-renew');
    var response = await http.get(
      url, 
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token
      }
    );
    // logger.d('Response status: ${response.statusCode}');
    // logger.d('Response body: ${response.body}');
    authenticating = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await saveToken(loginResponse.token);
      return true;
    }
    else {
      // final loginResponse = response.body;
      return false;
    }
  }


  Future saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
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