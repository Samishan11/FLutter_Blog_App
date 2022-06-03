import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Tryhome extends StatefulWidget {
  const Tryhome({Key? key}) : super(key: key);

  @override
  _TryhomeState createState() => _TryhomeState();
}

class _TryhomeState extends State<Tryhome> {
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
        scrollDirection: Axis.vertical,
        child:
         Container(
          constraints: new  BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            maxHeight: double.infinity
            ),
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width,
          child: Expanded(
            child: ListView.builder(
              itemCount: 5,
              // shrinkWrap: true,
              itemBuilder: (context, builder) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 288,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: Offset(0, 1),
                              )
                            ],
                            image: DecorationImage(
                              image: AssetImage("images/mountains-6540497.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 288,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.25)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/samishan.jpg'),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text(
                                        "Samishan Thapa",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "5 minute ago",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE5E5E5).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(27)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(MdiIcons.heart, color: Colors.white),
                                        Text(
                                          "2.1k",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE5E5E5).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(27)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(MdiIcons.comment,
                                            color: Colors.white),
                                        Text(
                                          "2.1k",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 27,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE5E5E5).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(27)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(MdiIcons.share, color: Colors.white),
                                        Text(
                                          "2.1k",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                
              },
              
            ),
          ),
        ),
      ),
    );
  }
}
