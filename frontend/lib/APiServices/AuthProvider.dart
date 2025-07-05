import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zego_zimkit/zego_zimkit.dart';

import 'APIBaseUrl.dart';
class AuthProvider with ChangeNotifier{
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? _username;
  String? _id;
  final String baseUrl = APIBaseUrl.baseUrl;


  bool get isAuthenticated => _token != null;

  String? get token => _token;
  String? get id => _id;
  String? get username => _username;

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      List<dynamic> userData = jsonDecode(response.body);

      String token = userData[0];
      String userId = userData[1];

      print('Token: $token');
      print('User ID: $userId');
      _token = userData[0];
      _id = userData[1];
      _username = username;
      await ZIMKit().disconnectUser();
      await ZIMKit()
          .connectUser(
        id: _id!,
        name: username,
      );
      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'username', value: _username);
      await _storage.write(key: 'id', value: _id);
      notifyListeners();
    }else{
      print("Login Failed!!");
      throw Exception('Login failed!!!!!!!!!!!!!!!');
    }
  }

  Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email' : '$username@gmail.com',
      }),
    );

    if(response.statusCode == 200){
      List<dynamic> userData = jsonDecode(response.body);
      String token = userData[0];
      String userId = userData[1];
      print(userData);
      print('Token: $token');
      print('User ID: $userId');
      _token = userData[0];
      _id = userData[1];
      _username = username;
      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'username', value: _username);
      await _storage.write(key: 'id', value: _id);
      notifyListeners();
    }else{
      print("Registration Failed!!");
      throw Exception('Registration failed!!!!!!!!!!!!!!!');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}getUserProfile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('${baseUrl}updateUserProfile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> logout() async {
    _token = null;
    _username = null;
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'id');
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'jwt_token');
    _username = await _storage.read(key: 'username');
    _id = await _storage.read(key: 'id');
    notifyListeners();
  }

}