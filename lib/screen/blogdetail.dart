import 'package:blog_app/http/httpComment.dart';
import 'package:blog_app/http/httpLike.dart';
import 'package:blog_app/screen/comment.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:blog_app/screen/updateBlog.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'blog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Blogdetail extends StatefulWidget {
  final data;
  const Blogdetail({Key? key, @required this.data}) : super(key: key);

  @override
  _BlogdetailState createState() => _BlogdetailState();
}

class _BlogdetailState extends State<Blogdetail> {
  // void lol(){
  //   print(widget.data);
  // }

  // delete user
  String baseurl = 'http://172.25.1.220:5000/';
  // String baseurl = 'http://10.0.2.2:5000/';
  
  final storage = new FlutterSecureStorage();

// delete blog
  Future deteleBlog(String blogid) async {
    // var token = await storage.read(key: 'token');
    // String tok = 'Bearer $token';
    // String id = widget.data['_id']
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

  //  like
  Future<bool> likeBlog(String blogid) {
    var res = Httplike().like(blogid);
    return res;
  }

  //  unlike
  // Future unlike(String blogid) async {
  //   // var blogid = widget.data['_id'];
  //   var token = await storage.read(key: 'token');
  //   final response = await http
  //       .delete(Uri.parse(baseurl + 'blog/unlike/${blogid}'), headers: {
  //     'Authorization': 'Bearer $token',
  //   });
  //   var jData = jsonDecode(response.body);
  //   if (response.statusCode == 201) {
  //     print(jData);
  //     return response;
  //   }
  // }
  Future unlikeBlog(String likeid) async {
    var token = await storage.read(key: 'token');
    print(likeid);
    final response = await http.delete(
        Uri.parse(baseurl + "blog/unlike/${likeid}"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      print(data);
      return response;
    } else {
      print('err');
    }
  }

// blog/like/count
  bool likes = false;
  Future getLike() async {
    var blogid = widget.data['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse(baseurl + 'blog/like/count/${blogid}'), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    likes = true;
    print(likes);
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
    print(jData);
    return jData;
  }

  // comment
  String comment = '';
  final formkey = GlobalKey<FormState>();
  //
  Future<bool> commentPost(String comment, String blog) async {
    var res = Httpcomment().comment(comment, blog);
    return res;
  }

  // get comment

  getComment() async {
    var blog = widget.data['_id'];
    var res = await http.get(Uri.parse(baseurl + "show/comment/${blog}"));
    print(res);
    var data = jsonDecode(res.body);

    return data;
  }

  // delete comment
  Future deteleComment(String commentid) async {
    var token = await storage.read(key: 'token');
    print(commentid);
    final response = await http.delete(
        Uri.parse(baseurl + "delete/comment/${commentid}"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) ;
    if (response.statusCode == 201) {
      print(data);
      return response;
    } else {
      print('err');
    }
  }

  var id;
  Future token() async {
    final userData = await parseToken();
    id = userData['userId'];
    print("Userid" + id);
    return id;
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
  }

  @override
  Widget build(BuildContext context) {
    print("Data" + widget.data['user']['_id']);
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
              Text("Blog", style: TextStyle(fontSize: 22)),
              Text(
                "App",
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity,
            ),
            child: Column(
              children: [
                Image.network("${baseurl}/${widget.data['image']}"),
                // title and detail of the blog
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "${widget.data['title']}",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    // like blog
                    // likes == false ?
                    FutureBuilder(
                        future: filterLike(),
                        builder: (context, AsyncSnapshot snapshot) {
                          return snapshot.hasData
                              ?
                              //  snapshot.data['user'] == id?
                               Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                         await unlikeBlog(snapshot.data['_id']);
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
                                      builder: (context,AsyncSnapshot snapshot){
                                      return snapshot.hasData?
                                      Text(
                                      '${snapshot.data.length}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ) :
                                    Text(
                                      '0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    );
                                    })
                                  ],
                                )
                              : 
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                            await likeBlog(widget.data['_id']);
                                            setState(() {
                                            });
                                      },
                                      icon: Icon(
                                        MdiIcons.heartOutline,
                                        size: 30,
                                      ),
                                    ),
                                    
                                ],
                              );
                              // :
                              //  IconButton(
                              //     onPressed: () async {
                              //           await likeBlog(widget.data['_id']);
                              //     },
                              //     icon: Icon(
                              //       MdiIcons.heartOutline,
                              //       // color: Colors.red,
                              //       size: 30,
                              //     ),
                              //   );
                        })
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "${widget.data['description']}",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                // image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        "${baseurl}/${widget.data['image']}",
                        width: 180,
                      ),
                      Image.network(
                        "${baseurl}/${widget.data['image']}",
                        width: 180,
                      ),
                    ],
                  ),
                ),
                // user detail and blog
                // user image
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: widget.data['user']['image'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                "${baseurl}/${widget.data['user']['image']}"),
                            radius: 60,
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage("images/samishan.jpg"),
                            radius: 60,
                          )),
                // username
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "${widget.data['user']['username']}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                // post date of the blog
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "Post at: ${widget.data['date']}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // edit and delete blog

                id == widget.data['user']['_id']
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 2.0),
                              child: SizedBox(
                                height: 30,
                                width: 70,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green)),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Updateblog(
                                                        data: widget.data)));
                                      });
                                    },
                                    child: Icon(MdiIcons.pen)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 2.0),
                              child: SizedBox(
                                height: 30,
                                width: 70,
                                child: ElevatedButton(
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
                                    child: Icon(MdiIcons.trashCan)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(''),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 40),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      color: Colors.black,
                    )),
                  ]),
                ),
                // Comment section
                // CommentSection()
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Comment Section",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Form(
                        key: formkey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
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

                                  var res = await commentPost(
                                      comment, widget.data['_id']);
                                  if (res) {
                                    MotionToast.success(
                                            description: "Comment Post")
                                        .show(context);
                                  } else {
                                    MotionToast.error(
                                            description: "Something went wrong")
                                        .show(context);
                                  }
                                  setState(() {});
                                }
                              },
                              child: Icon(MdiIcons.comment)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "All comments",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      // Show comments
                      Container(
                          height: 1000,
                          constraints:
                              BoxConstraints(maxHeight: double.infinity),
                          child: FutureBuilder(
                            future: getComment(),
                            builder: (context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 12),
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
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: snapshot.data[index]
                                                                  ['user']
                                                              ['image'] !=
                                                          null
                                                      ? CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'http://${baseurl}/${snapshot.data[index]['user']['image']}'),
                                                        )
                                                      : CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'images/samishan.jpg')),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${snapshot.data[index]['comment']}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                snapshot.data[index]['user']['_id'] == id ?
                                                IconButton(
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      deteleComment(snapshot
                                                          .data[index]['_id']);
                                                      setState(() {});
                                                    },
                                                    icon: Icon(MdiIcons
                                                        .trashCanOutline))
                                                        : Text('')
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : CircularProgressIndicator();
                            },
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
