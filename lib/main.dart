import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blog_app/screen/Profile.dart';
import 'package:blog_app/screen/addBlog.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/getstart.dart';
import 'package:blog_app/screen/login.dart';
import 'package:blog_app/screen/register.dart';
import 'package:blog_app/screen/try.dart';
import 'package:blog_app/screen/updateProfile.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: const Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            importance: NotificationImportance.High,
            enableVibration: true)
      ]);
  runApp(mainApp());
}

class mainApp extends StatelessWidget {
  mainApp({Key? key}) : super(key: key);

  // var id;
  token() async {
    final storage = new FlutterSecureStorage();
    var tok = await storage.read(key: 'token');
    if (tok != null) {
      // id = tok;
      print(tok);
      return true;
    }
    return false;
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: token(),
        builder: (context, AsyncSnapshot snapshot) {
          // print(snapshot.data);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: snapshot.data == true ? BlogPage() : GetstartPage(),
          );
        });
  }
}
