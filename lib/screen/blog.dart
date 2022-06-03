import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/http/httpLike.dart';
import 'package:blog_app/model/blogModel.dart';
import 'package:blog_app/screen/blogdetail.dart';
import 'package:blog_app/screen/detail.dart';
import 'package:blog_app/screen/login.dart';
import 'package:blog_app/screen/profile.dart';
import 'package:blog_app/screen/register.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:blog_app/utilities/toke.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:sensors_plus/sensors_plus.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  // carousel image
  final carousel_image = [
    "https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/10/05/14/39/sunset-3726030_960_720.jpg",
    "https://scontent.fktm3-1.fna.fbcdn.net/v/t1.6435-9/s1080x2048/163010005_1372219383115867_5653984754757638142_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=e3f864&_nc_ohc=dEkZ8_tpjHQAX9xfYvL&_nc_ht=scontent.fktm3-1.fna&oh=00_AT_HLZZKLLI3OxqbgRiCW7hKyl_C6kz3b0cMU5hhlXdHUQ&oe=61E057FD",
    "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/07/24/19/57/tiger-2535888_960_720.jpg"
  ];

// carousel class
  Widget carouselImages(String carousel, int index) => Container(
        height: 250,
        width: 350,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Image.network(
          carousel,
          fit: BoxFit.cover,
        ),
      );

  // get all blogs
  // List<Blogmodel> postList = [];

  var user = '';
  // String baseurl = 'http://192.168.1.73:5000';
  // String baseurl = 'http://172.25.1.220:5000';
  // String baseurl = 'http://192.168.1.54:5000';
  // String baseurl = 'http://10.0.2.2:5000';

  // Future<List<Blogmodel>> getPost() async {
  //   var res = await http.get(Uri.parse('http://10.0.2.2:5000/get/allblog'));
  //   var data = jsonDecode(res.body);
  //   print(data);
  //   print(data[1]['user']['email']);
  //   user = data[1]['user']['email'];
  //   if (res.statusCode == 200) {
  //     postList.clear();
  //     for (Map i in data) {
  //       postList.add(Blogmodel.fromJson(i as Map<String, dynamic>));
  //     }
  //     return data;
  //   } else {
  //     return data;
  //   }
  // }
bool isLoding = false;
  Future getPost() async {
    var res = await http.get(Uri.parse(baseurl + 'get/allblog'));
    var data = jsonDecode(res.body);
    // print(data.length);
 isLoding = true;

    return data;
  }

  final storage = new FlutterSecureStorage();

  //
  // proximity sensor start here

  bool _isNear = false;

  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void dispose() {
    super.dispose();

    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;

          print('tureee');
        if (_isNear == true) {
            Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context) => ProfilePage(),

            ),

          );

        }
      });
    });
  }

  //

  void initState() {
    super.initState();
    getPost().then((value) {
      setState(() {
        return value;
      });
    });
    listenSensor().then((value) {
      setState(() {
        return value;
      });
    });
    // 
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) async {
          if (event.y > 10 && event.y < 15) {
            await storage.delete(key: 'token');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          }
        },
      ),
    );
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
            Text("sBlog", style: TextStyle(fontSize: 22)),
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
          // isAlwaysShown: true,
          // child: Container(
          // child: Column(
          //   children: [
          //     CarouselSlider.builder(
          //       itemCount: carousel_image.length,
          //       itemBuilder: (context, index, realIndex) {
          //         final carousel = carousel_image[index];
          //         return carouselImages(carousel, index);
          //       },
          //       options: CarouselOptions(
          //           height: 250,
          //           autoPlay: true,
          //           autoPlayInterval: Duration(seconds: 3),
          //           // viewportFraction:1,
          //           enlargeCenterPage: true,
          //           enlargeStrategy: CenterPageEnlargeStrategy.height),
          //     ),
          //     // Blog items

          //   ],
          // ),
          child: FutureBuilder(
              future: getPost(),
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      isLoding == true ?
                                      snapshot.data[index]['image'] != null
                                          ? Hero(
                                              tag: snapshot.data[index]['_id'],
                                              child: Image(
                                                image: NetworkImage(baseurl +
                                                    "${snapshot.data[index]['image']}"),
                                                height: 300,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              "images/rami-al-zayat-w33-zg-dNL4-unsplash.jpg")
                                              : CircularProgressIndicator(),
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
                                                    backgroundImage:
                                                        NetworkImage(baseurl +
                                                            '${snapshot.data[index]['user']['image']}'))
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
                                                          child: DetailPage(
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

// searching data method
class DataSearch extends SearchDelegate<String> {
  var title;
  Future getPost() async {
    // var res = await http.get(Uri.parse(baseurl + 'get/allblog'));
    var res = await http.get(Uri.parse(baseurl + 'get/allblog'));
    var data = jsonDecode(res.body);
    // title = data[1]['title'];
    return data;
  }

  final data = [
    "Nepal",
    "laptop",
    "mobile",
    "bike",
    "country",
    "earth",
    "moon",
    "House",
    "Wine",
    "Beer",
    "Food"
  ];
  final recentData = ["samishan", "Nepal", "Wine", "Food"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // action for the search
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear_outlined))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //leading item for the app bar
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // show the result based on the selection
    return FutureBuilder(
        future: getPost(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return query == snapshot.data[index]['title']
                        ?
                        // Container(
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Center(
                        //               child: Text(
                        //             query,
                        //             style: TextStyle(
                        //                 fontSize: 20, color: Colors.blue),
                        //           )),
                        //         )
                        //       ],
                        //     ),
                        //   )
                        ListTile(
                            leading: Icon(Icons.photo),
                            title: Text(query),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: DetailPage(
                                          data: snapshot.data[index])));
                            },
                          )
                        :
                        // Container(
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Center(
                        //               child: Text(
                        //             "Not found",
                        //             style: TextStyle(
                        //                 fontSize: 20, color: Colors.blue),
                        //           )),
                        //         )
                        //       ],
                        //     ),
                        //   );
                        Text('');
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(getPost());
    // show suggestion when someone search for the blog
    // final suggestion = data;
    return FutureBuilder(
        future: getPost(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      //  query.isEmpty ?
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text(snapshot.data[index]['title']),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child:
                                      DetailPage(data: snapshot.data[index])));
                        },
                      )

                  // :
                  //  ListTile(
                  //   leading: Icon(Icons.photo),
                  //   title: Text(snapshot.data[2]['title']),
                  //   onTap: () {
                  //     showResults(context);
                  //   },
                  // )
                  )
              : Center(child: Text('No thing to show'));
        });
  }
}
