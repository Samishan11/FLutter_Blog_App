import 'dart:convert';

import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/screen/Profile.dart';
import 'package:blog_app/screen/addBlog.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/login.dart';
import 'package:blog_app/screen/myPost.dart';
import 'package:blog_app/screen/register.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class sideBar extends StatefulWidget {
  const sideBar({Key? key}) : super(key: key);

  @override
  _sideBarState createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  final storage = new FlutterSecureStorage();

  var username;
  var image;
  var userid;
  // token() async {
  //   var userData = await parseToken();
  //   username = userData['username'];
  //   userid = userData['userId'];
  //   image = userData['image'];
  //   // print(userData);
  //   return userData;
  // }
  // String baseurl = 'http://192.168.1.73:5000';
  // String baseurl = 'http://172.25.1.220:5000';
  // String baseurl = 'http://10.0.2.2:5000';
  // String baseurl = 'http://192.168.1.54:5000';

  Future getUser() async {
    var token = await storage.read(key: 'token');
    var res = await http.get(Uri.parse(baseurl + 'profile/user'), headers: {
      'Authorization': 'Bearer $token',
    });
    var data = jsonDecode(res.body);
    username = data['username'];
    userid = data['userId'];
    image = data['image'];
    // print(data);
    return data;
  }

  @override
  void initState() {
    super.initState();
    // token().then((responce) {
    //   setState(() {
    //     return responce;
    //   });
    // });
    getUser().then((responce) {
      setState(() {
        return responce;
      });
    });
    // print(getUser());
  }

  logout() async {
    await storage.delete(key: 'token');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
    print("logout");
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                      ),
                      child: Column(
                        children: [
                          image != null
                              ? CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                      baseurl + snapshot.data['image']))
                              : CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage('images/man.png')),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "${snapshot.data['username']}",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                child: SizedBox(
                                  height: 28,
                                  width: 90,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent)),
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => ProfilePage()));
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.size,
                                              alignment: Alignment.topCenter,
                                              child: ProfilePage()));
                                    },
                                    child: Text(
                                      "Profile",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 6.0, vertical: 4.0),
                              //     child: SizedBox(
                              //       height: 30,
                              //       width: 60,
                              //       child: ElevatedButton(
                              //           style: ButtonStyle(
                              //               backgroundColor:
                              //                   MaterialStateProperty.all(Colors.red)),
                              //           onPressed: () {},
                              //           child: Icon(MdiIcons.trashCan)),
                              //     )),
                            ],
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      hoverColor: Colors.red,
                      focusColor: Colors.yellow,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlogPage()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_a_photo),
                      title: const Text('Add Blog'),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Addblog()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category_sharp),
                      title: const Text('Catagory'),
                      onTap: () {
                        Text("data");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category_sharp),
                      title: const Text('My Post'),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Mypost()));
                        Text("data");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Signin'),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Login()));
                        Text("data");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.app_registration_outlined),
                      title: const Text('Signup'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                        Text("data");
                        Text("data");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        setState(() {
                          logout();
                        });

                        Text("data");
                        Text("data");
                      },
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  value: 0.5,
                ),
              );
      },
    );
  }
}
