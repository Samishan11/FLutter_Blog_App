import 'dart:convert';
import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/blogdetail.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:blog_app/screen/updateBlog.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
class Mypost extends StatefulWidget {
  const Mypost({ Key? key }) : super(key: key);

  @override
  _MypostState createState() => _MypostState();
}

class _MypostState extends State<Mypost> {
  final storage = new FlutterSecureStorage();

var userId;
  Future token() async {
    final userData = await parseToken();
    userId = userData['userId'];
    // print("Userid" + userid);
    return userId;
  }

  Future getPost() async {
    // var userid = 2;
    var res = await http.get(Uri.parse(baseurl+'myblog/${userId}'));
    var data = jsonDecode(res.body);
    print('data ${data.length}');
    return data;
  }
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


  void initState() {
    super.initState();
    getPost().then((value) {
      setState(() {
        return value;
      });
    });
    token().then((value) {
      setState(() {
        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: sideBar()),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Blog", style: TextStyle(fontSize: 22)),
            Text(
              "App",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: Scrollbar(

          child: FutureBuilder(
              future: getPost(),
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData ?
                
                    Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      snapshot.data[index]['image'] != null
                                          ? Image(
                                              image: NetworkImage(
                                                  baseurl+"${snapshot.data[index]['image']}"),
                                              height: 300,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset("images/samisahn.jpg"),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            snapshot.data[index]['user']
                                                        ['image'] !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        baseurl+'${snapshot.data[index]['user']['image']}'))
                                                : CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'images/samishan.jpg')),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.blueGrey,
                                                ),
                                                Text(
                                                    ' ${snapshot.data[index]['date']}'),
                                              ],
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.orangeAccent),
                                              onPressed: () {},
                                              child: Text(
                                                "${snapshot.data[index]['catagory']}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                            '${snapshot.data[index]['title']}',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blueGrey.shade600,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 6),
                                        child: Text(
                                          '${snapshot.data[index]['description']}',
                                          style: TextStyle(fontSize: 14),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child: Blogdetail(
                                                              data:
                                                                  snapshot.data[
                                                                      index])));
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary:
                                                      Colors.lightBlueAccent),
                                              child: Text("View"),
                                            ),
                                          ),
                                         Row(children: [
                                           Row(
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
                                                        data: snapshot.data[index]['_id'])));
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
                                      deteleBlog(snapshot.data[index]['_id'])
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
                                         ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}