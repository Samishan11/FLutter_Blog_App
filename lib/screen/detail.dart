import 'dart:convert';

import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/http/httpComment.dart';
import 'package:blog_app/http/httpFollow.dart';
import 'package:blog_app/http/httpLike.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/updateBlog.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';

class DetailPage extends StatefulWidget {
  final data;
  DetailPage({Key? key, @required this.data}) : super(key: key);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // String baseurl = 'http://192.168.1.73:5000';
  // String baseurl = 'http://172.25.1.220:5000';
  // String baseurl = 'http://10.0.2.2:5000';
  // String baseurl = 'http://192.168.1.54:5000';

  final storage = new FlutterSecureStorage();

  var id;
  Future token() async {
    final userData = await parseToken();
    id = userData['userId'];
    // print("Userid" + id);
    return id;
  }

  // delete blog
  Future deteleBlog(String blogid) async {
    print(blogid);
    final response =
        await http.delete(Uri.parse(baseurl + "blog/delete/${blogid}"));
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      // print(data);
      return response;
    } else {
      print('err');
    }
  }

  // comment
  String comment = '';
  final formkey = GlobalKey<FormState>();
  Future<bool> commentPost(String comment, String blog) async {
    var res = Httpcomment().comment(comment, blog);
    return res;
  }

  // get comments
  getComment() async {
    var blog = widget.data['_id'];
    var res = await http.get(Uri.parse(baseurl + "show/comment/${blog}"));
    var data = jsonDecode(res.body);
    // print(data);
    return data;
  }

  // delete comment
  Future deteleComment(String commentid) async {
    var token = await storage.read(key: 'token');
    // print(commentid);
    final response = await http.delete(
        Uri.parse(baseurl + "delete/comment/${commentid}"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      // print(data);
      return response;
    } else {
      print('err');
    }
  }

  //  like
  Future<bool> likeBlog(String blogid) {
    var res = Httplike().like(blogid);
    return res;
  }

  // unlike
  Future unlikeBlog(String likeid) async {
    var token = await storage.read(key: 'token');
    // print(likeid);
    final response = await http.delete(
        Uri.parse(baseurl + "blog/unlike/${likeid}"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      // print(data);
      return response;
    } else {
      print('err');
    }
  }

// count blog like
  Future getLike() async {
    var blogid = widget.data['_id'];
    final response =
        await http.get(Uri.parse(baseurl + 'blog/like/count/${blogid}'));
    var jData = jsonDecode(response.body);
    return jData;
  }

// blog like filter
  Future filterLike() async {
    var blogid = widget.data['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse(baseurl + 'blog/like/filter/${blogid}'), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    return jData;
  }

  // follow
  Future<bool> follow(String followingid) {
    var res = Httpfollow().follow(followingid);
    return res;
  }

  // unfollow
  Future unfollow(String followid) async {
    var token = await storage.read(key: 'token');
    // print(likeid);
    final response = await http.delete(
        Uri.parse(baseurl + "unfollow/blogger/${followid}"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      // print(data);
      return response;
    } else {
      print('err');
    }
  }

  // filter follower
  Future filterFollower() async {
    var followingid = widget.data['user']['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse(baseurl + 'filter/follower/' + followingid), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    print(jData);
    return jData;
  }

  void initState() {
    super.initState();
    getComment().then((responce) {
      setState(() {
        return responce;
      });
    });
    token().then((responce) {
      setState(() {
        return responce;
      });
    });
    getLike().then((responce) {
      setState(() {
        return responce;
      });
    });
    filterLike().then((responce) {
      setState(() {
        return responce;
      });
    });
    filterFollower().then((responce) {
      setState(() {
        return responce;
      });
    });
  }

  void clearForm() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: widget.data['_id'],
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(
                              baseurl + "${widget.data['image']}"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: EdgeInsets.all(40.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(15, 15, 15, .5)),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 120.0),
                        Icon(
                          Icons.travel_explore,
                          color: Colors.white,
                          size: 40.0,
                        ),
                        Container(
                          width: 50.0,
                          child: new Divider(color: Colors.green),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          ' ${widget.data['title']} ',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                        // SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Container(
                                  child: Container(
                                    child: LinearProgressIndicator(
                                        backgroundColor:
                                            Color.fromRGBO(209, 224, 224, 0.2),
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.green)),
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(''))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 8.0,
                  top: 60.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                )
              ],
            ),
            //
            Container(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        FutureBuilder(
                            future: filterLike(),
                            builder: (context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ?
                                  //  snapshot.data['user'] == id?
                                  SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await unlikeBlog(
                                                  snapshot.data['_id']);
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              MdiIcons.heart,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          ),
                                          FutureBuilder(
                                              future: getLike(),
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                return snapshot.hasData
                                                    ? Text(
                                                        '${snapshot.data.length}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      )
                                                    : Text(
                                                        '0',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      );
                                              })
                                        ],
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await likeBlog(widget.data['_id']);
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            MdiIcons.heartOutline,
                                            size: 30,
                                          ),
                                        ),
                                        FutureBuilder(
                                            future: getLike(),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              return snapshot.hasData
                                                  ? Text(
                                                      '${snapshot.data.length}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      '0',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    );
                                            }),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                        ),
                                      ],
                                    );
                            })
                      ],
                    ),
                    Text(
                      '${widget.data['description']}',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.data['user']['image'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                baseurl + '${widget.data['user']['image']}'),
                            radius: 50,
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage('images/man.png'),
                            radius: 50,
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.data['user']['username']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.data['date']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    widget.data['user']['_id'] == id
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Updateblog(
                                                  data: widget.data)));
                                    });
                                  },
                                  child: Icon(Icons.edit)),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () {
                                    deteleBlog(widget.data['_id'])
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlogPage())))
                                        .catchError((err) => {print(err)});
                                  },
                                  child: Icon(Icons.delete)),
                            ],
                          )
                        : FutureBuilder(
                            future: filterFollower(),
                            builder: (context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent),
                                      onPressed: () {
                                        setState(() {
                                          unfollow(snapshot.data['_id']);
                                        });
                                      },
                                      child: Text('Unfollow'))
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          follow(widget.data['user']['_id']);
                                        });
                                      },
                                      child: Text('Follow'));
                            }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        )),
                      ]),
                    ),
                    // Container(
                    //     padding: EdgeInsets.symmetric(vertical: 16.0),
                    //     // width: MediaQuery.of(context).size.width,
                    //     child: ElevatedButton(
                    //       onPressed: () {},
                    //       child: Text("Comment Section",
                    //           style: TextStyle(color: Colors.white)),
                    //     )),
                    // commet here
                    Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: TextFormField(
                          onSaved: (val) {
                            comment = val!;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Empty comment cannot post';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Comment here",
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    //  Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                formkey.currentState!.save();
                                formkey.currentState!.reset();
                                await commentPost(comment, widget.data['_id']);
                                setState(() {});
                              }
                            },
                            child: Icon(Icons.comment)),
                      ),
                    ),
                    Container(
                      child: FutureBuilder(
                          future: getComment(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: snapshot.data[index]
                                                            ['user']['image'] !=
                                                        null
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(baseurl +
                                                                '${snapshot.data[index]['user']['image']}'),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            AssetImage(
                                                                'images/man.png')),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${snapshot.data[index]['comment']}',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              snapshot.data[index]['user']
                                                          ['_id'] ==
                                                      id
                                                  ? IconButton(
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        deteleComment(
                                                            snapshot.data[index]
                                                                ['_id']);
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons.delete))
                                                  : Text('')
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Text('No comment Yet');
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
