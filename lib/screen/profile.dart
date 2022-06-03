import 'dart:convert';

import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:blog_app/screen/updateProfile.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = new FlutterSecureStorage();
  // String baseurl = 'http://192.168.1.73:5000';
  // String baseurl = 'http://172.25.1.220:5000';
  // String baseurl = 'http://10.0.2.2:5000';

  final _formKey = GlobalKey<FormState>();
  String oldpassword = '';
  String newpassword = '';

  var userData;
  Future getUser() async {
    var token = await storage.read(key: 'token');
    var res = await http.get(Uri.parse(baseurl + 'profile/user'), headers: {
      'Authorization': 'Bearer $token',
    });
    var data = jsonDecode(res.body);
    userData = data['_id'];
    print(userData);
    return data;
  }

  // var userid;
  getUserId() async {
    var data = await parseToken();
    var userid = data['userId'];
    return userid;
  }

  // show followers
  Future getFollowers() async {
    var userId = await getUserId();
    var res = await http.get(Uri.parse(baseurl + 'show/followings/' + userId));
    var data = jsonDecode(res.body);
    // print(data.length);
    return data;
  }

  // show followers
  Future getFollowing() async {
    var userId = await getUserId();
    var res = await http.get(Uri.parse(baseurl + 'show/followers/' + userId));
    var data = jsonDecode(res.body);
    // print(data.length);
    return data;
  }

  // change password

  Future<bool> changePass(String oldpassword, String passowrd) async {
    var token = await storage.read(key: 'token');
    var res = await http.put(Uri.parse(baseurl + 'change/password'), body: {
      'oldpassword': oldpassword,
      'password': passowrd
    }, headers: {
      'Authorization': 'Bearer $token',
    });

    var data = jsonDecode(res.body) as Map;
    if (data['message'] == 'Password update sucessfully') {
      MotionToast.success(description: "Password update sucessfully")
          .show(context);
      return true;
    } else if (data['message'] == 'Password must be more that 6 charector') {
      MotionToast.error(description: "Password must be more that 6 charector")
          .show(context);
      return false;
    } else if (data['message'] ==
        'Old password and new password is too similar') {
      MotionToast.error(
              description: "Old password and new password is too similar")
          .show(context);
      return false;
    }
    MotionToast.error(description: "Old password not match").show(context);
    return false;
  }
  var userId;
  Future token() async {
    final userData = await parseToken();
    userId = userData['userId'];
    // print("Userid" + userid);
    return userId;
  }

  Future getPost() async {
    var res = await http.get(Uri.parse(baseurl+'myblog/${userId}'));
    var data = jsonDecode(res.body);
    print('data ${data.length}');
    return data;
  }

  @override
  void initState() {
    super.initState();
    getUser().then((responce) {
      setState(() {
        return responce;
      });
    });
    getUserId().then((responce) {
      setState(() {
        return responce;
      });
    });
    getFollowers().then((responce) {
      setState(() {
        return responce;
      });
    });
    getFollowing().then((responce) {
      setState(() {
        return responce;
      });
    });
    token().then((responce) {
      setState(() {
        return responce;
      });
    });
    getPost().then((responce) {
      setState(() {
        return responce;
      });
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: sideBar(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("sBlog", style: TextStyle(fontSize: 22)),
              Text(
                "App",
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: getUser(),
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.data != null
                ? SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration:
                            BoxDecoration(color: Colors.blueGrey.shade900),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: snapshot.data['image'] != null
                                    ? CircleAvatar(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: 0,
                                              top: 130,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .size,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: updateProfile(
                                                              data: snapshot
                                                                  .data)));
                                                },
                                                child: Icon(
                                                  MdiIcons.pen,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  padding: EdgeInsets.all(14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        backgroundImage: NetworkImage(baseurl +
                                            '${snapshot.data['image']}'),
                                        radius: 100,
                                      )
                                    : CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            AssetImage('images/man.png')),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  '${snapshot.data['username']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 28),
                                ),
                              ),
                              Text(
                                '${snapshot.data['email']}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  right: -40.0,
                                                  top: -40.0,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          onSaved: (val) {
                                                            oldpassword = val!;
                                                          },
                                                          validator: (val) {
                                                            if (val == null ||
                                                                val.isEmpty) {
                                                              return 'enter oldpassword';
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Old password'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          onSaved: (val) {
                                                            newpassword = val!;
                                                          },
                                                          validator: (val) {
                                                            if (val == null ||
                                                                val.isEmpty) {
                                                              return 'enter newpassword';
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'New password'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          child:
                                                              Text("Submitß"),
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              _formKey
                                                                  .currentState!
                                                                  .save();
                                                              var a = await changePass(
                                                                  oldpassword,
                                                                  newpassword);
                                                              if (a) {
                                                                MotionToast.success(
                                                                        description:
                                                                            "Password update sucessfully")
                                                                    .show(
                                                                        context);
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Text("Change password"),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                         FutureBuilder(
                                           future: getPost(),
                                           builder: (context ,AsyncSnapshot snapshot){
                                            return snapshot.hasData ?
                                              Text(
                                            "${snapshot.data.length}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ):
                                           Text(
                                            "0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          );
                                           }),
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: getFollowers(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          return snapshot.hasData
                                              ? Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${snapshot.data!.length}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "Following",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Text('');
                                        }),
                                    FutureBuilder(
                                        future: getFollowing(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          return snapshot.hasData
                                              ? Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${snapshot.data!.length}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "Followers",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Text('');
                                        })
                                  ],
                                ),
                              ),
                              snapshot.data['bio'] == null
                                  ? Text('')
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'About',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '${snapshot.data['bio']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                height: 1.4),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    child: SizedBox(
                                      height: 35,
                                      width: 85,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.size,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: updateProfile(
                                                        data: snapshot.data)));
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> updateProfile()));
                                          },
                                          child: Icon(MdiIcons.pen)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    child: SizedBox(
                                      height: 35,
                                      width: 85,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          onPressed: () {
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ()));
                                          },
                                          child: Icon(MdiIcons.trashCan)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );

    // return FutureBuilder(
    //     future: getUser(),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       return snapshot.hasData
    //           ? Scaffold(
    //               drawer: Drawer(
    //                 child: sideBar(),
    //               ),
    //               appBar: AppBar(
    //                 backgroundColor: Colors.blueGrey.shade900,
    //                 title: Center(
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text("Blog", style: TextStyle(fontSize: 22)),
    //                       Text(
    //                         "App",
    //                         style: TextStyle(fontSize: 22, color: Colors.blue),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               body: SafeArea(
    //                 child: Container(
    //                   decoration:
    //                       BoxDecoration(color: Colors.blueGrey.shade900),
    //                   child: Center(
    //                     child: Column(
    //                       children: [
    //                         Padding(
    //                           padding:
    //                               const EdgeInsets.symmetric(vertical: 12.0),
    //                           child: snapshot.data['image'] != null
    //                               ? CircleAvatar(
    //                                   child: Stack(
    //                                     children: [
    //                                       Positioned(
    //                                         right: 0,
    //                                         top: 130,
    //                                         child: ElevatedButton(
    //                                           onPressed: () {},
    //                                           child: Icon(
    //                                             MdiIcons.pen,
    //                                             color: Colors.white,
    //                                             size: 35,
    //                                           ),
    //                                           style: ElevatedButton.styleFrom(
    //                                             shape: CircleBorder(),
    //                                             padding: EdgeInsets.all(14),
    //                                           ),
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                   backgroundImage: NetworkImage(
    //                                       '${baseurl}/${snapshot.data['image']}'),
    //                                   radius: 100,
    //                                 )
    //                               : CircleAvatar(
    //                                   radius: 100,
    //                                   backgroundImage:
    //                                       AssetImage('images/man.png')),
    //                         ),
    //                         Padding(
    //                           padding:
    //                               const EdgeInsets.symmetric(vertical: 10.0),
    //                           child: Text(
    //                             '${snapshot.data['username']}',
    //                             style: TextStyle(
    //                                 fontSize: 38, color: Colors.white),
    //                           ),
    //                         ),
    //                         Text(
    //                           '${snapshot.data['email']}',
    //                           style:
    //                               TextStyle(fontSize: 18, color: Colors.white),
    //                         ),
    //                         Padding(
    //                           padding:
    //                               const EdgeInsets.symmetric(vertical: 40.0),
    //                           child: Row(
    //                             children: [
    //                               Expanded(
    //                                 child: Column(
    //                                   children: [
    //                                     Text(
    //                                       "18",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 24,
    //                                           fontWeight: FontWeight.bold),
    //                                     ),
    //                                     Text(
    //                                       "Posts",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 18),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Column(
    //                                   children: [
    //                                     Text(
    //                                       "999",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 24,
    //                                           fontWeight: FontWeight.bold),
    //                                     ),
    //                                     Text(
    //                                       "Followers",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 18),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Column(
    //                                   children: [
    //                                     Text(
    //                                       "9",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 24,
    //                                           fontWeight: FontWeight.bold),
    //                                     ),
    //                                     Text(
    //                                       "Following",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 18),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 10.0, vertical: 2.0),
    //                               child: SizedBox(
    //                                 height: 35,
    //                                 width: 85,
    //                                 child: ElevatedButton(
    //                                     style: ButtonStyle(
    //                                         backgroundColor:
    //                                             MaterialStateProperty.all(
    //                                                 Colors.green)),
    //                                     onPressed: () {
    //                                       Navigator.push(
    //                                           context,
    //                                           PageTransition(
    //                                               type: PageTransitionType.size,
    //                                               alignment:
    //                                                   Alignment.bottomCenter,
    //                                               child: updateProfile(data: snapshot.data)));
    //                                       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> updateProfile()));
    //                                     },
    //                                     child: Icon(MdiIcons.pen)),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 10.0, vertical: 2.0),
    //                               child: SizedBox(
    //                                 height: 35,
    //                                 width: 85,
    //                                 child: ElevatedButton(
    //                                     style: ButtonStyle(
    //                                         backgroundColor:
    //                                             MaterialStateProperty.all(
    //                                                 Colors.red)),
    //                                     onPressed: () {
    //                                       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ()));
    //                                     },
    //                                     child: Icon(MdiIcons.trashCan)),
    //                               ),
    //                             ),
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             )
    //           : CircularProgressIndicator();
    //     });
  }
}
