import 'dart:io';
import 'dart:convert';
import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/model/blogModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Httpblog {
  // String baseurl = 'http://10.0.2.2:5000/';
    // String baseurl = 'http://192.168.1.54:5000/';
  // String baseurl = 'http://172.25.1.220:5000/';
  String token = '';
  final storage = new FlutterSecureStorage();

  // add blog image
  Future<String> uploadblogImage(String filepath, String id) async {
    try {
      String url = baseurl + 'upload/blog/photo/' + id;
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      var token = await storage.read(key: 'token');
      request.headers.addAll({
        'Content-type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });
      // need a filename
      var filename = filepath.split('/').last;
      // adding the file in the request
      request.files.add(
        http.MultipartFile(
          'image',
          File(filepath).readAsBytes().asStream(),
          File(filepath).lengthSync(),
          filename: filename,
        ),
      );

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      // print(responseString);
      if (response.statusCode == 200) {
        return "ok";
      }
    } catch (e) {
      print(e);
    }
    return 'something went wrong';
  }

  // add blog
  void blogInfo(Blogmodel blog, File? file) async {
    String s = '';
    Map<String, dynamic> blogdata = {
      'title': blog.title,
      'catagory': blog.catagory,
      'description': blog.description
    };
    var token = await storage.read(key: 'token');
    // print(token);
    try {
      var response = await http
          .post(Uri.parse(baseurl + 'blog/post'), body: blogdata, headers: {
        'Authorization': 'Bearer $token',
      });
      // print(response);
      if (response.statusCode == 201) {
        if (file != null) {
          var jsonData = jsonDecode(response.body) as Map;
          // print(jsonData);
          s = await uploadblogImage(file.path, jsonData['_id']);
          if (s == "ok") {
            print('successfully post blog');
            // print(file.path);

          } else {
            // Fluttertoast.showToast(msg: "afdssad");
            print("shaj");
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

}
