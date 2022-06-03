import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:blog_app/Url/baseurl.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Httpfollow {
  // String baseurl = 'http://172.25.1.220:5000/';
  // String baseurl = 'http://10.0.2.2:5000/';
    // String baseurl = 'http://192.168.1.54:5000/';

  // String token = '';
  String success = '';
  final storage = new FlutterSecureStorage();

  Future<bool> follow(String followingid) async {
    print(followingid);
    Map<String, dynamic> likebody = {'followingid': followingid};
    var token = await storage.read(key: 'token');
    try {
      final response = await post(Uri.parse(baseurl + 'follow/bloger'),
          body: likebody,
          headers: {
            'Authorization': 'Bearer $token',
          });
      var data = jsonDecode(response.body) as Map;
      print(data);
      success = data['success'];
      if (success.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }


}
