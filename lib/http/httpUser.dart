import 'dart:convert';
import 'package:blog_app/Url/baseurl.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpUser {
  // String baseurl = 'http://192.168.1.73:5000/';
  // String baseurl = 'http://172.25.1.220:5000/';
  // String baseurl = 'http://10.0.2.2:5000/';
  String success = '';
  String token = '';
  final storage = new FlutterSecureStorage();

  // Register User
  Future<bool> registerUser(
      String username, String email, String password) async {
    Map<String, dynamic> register = {
      'username': username,
      'email': email,
      'password': password
    };
    try {
      print(username);
      print(email);
      print(password);
    final response =
        await post(Uri.parse(baseurl + 'register'), body: register);
    // print("hello");
    var data = jsonDecode(response.body) as Map;
    success = data['success'];
    if (response.statusCode == 200) {
      print(data);
      await storage.write(key: 'token', value: token);
      await storage.read(key: 'token');
      return true;
    }

    } catch (e) {
      print(e);
    }
    return false;
  }

  // Login user
  Future<bool> loginUser(String email, String password) async {
    Map<dynamic, String> login = {'email': email, 'password': password};
    print(email);
    print(password);
    try {
      final response = await post(Uri.parse(baseurl + 'login'), body: login);
      final data = jsonDecode(response.body) as Map;
      print(data);
      token = data['token'];
      print(token);
      if (response.statusCode == 200) {
        await storage.write(key: 'token', value: token);
        print(await storage.read(key: 'token'));
        return true;
      }
      print('object');
    } catch (e) {
      print(e);
    }
    return false;
  }
}
