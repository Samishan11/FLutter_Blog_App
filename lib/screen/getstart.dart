import 'package:blog_app/screen/login.dart';
import 'package:blog_app/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GetstartPage extends StatefulWidget {
  const GetstartPage({Key? key}) : super(key: key);

  @override
  State<GetstartPage> createState() => _GetstartPageState();
}

class _GetstartPageState extends State<GetstartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Container(
          height: MediaQuery.of(context).size.height*1.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                height: 450,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("images/work-4997565.png"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Welcome",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                    fontFamily: 'RobotoSlab',
                    color: Colors.black,
                  )),
              SizedBox(height: 40),
              Text(
                  "App allows you to read the blogs, post your own blogs and build your own profile",
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 17,
                      decoration: TextDecoration.none,
                      fontFamily: 'Lato',
                      color: Colors.grey),
                  textAlign: TextAlign.center),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: StadiumBorder(),
                          minimumSize: Size(100, 40)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RegisterPage()));
                      },
                      child: Text('Get Started')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                          shape: StadiumBorder(),
                          minimumSize: Size(100, 40)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(children: <Widget>[
              //     Expanded(
              //         child: Divider(
              //       color: Colors.black,
              //     )),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text("Or via social media" ,style: TextStyle(fontSize: 16),),
              //     ),
              //     Expanded(
              //         child: Divider(
              //       color: Colors.black,
              //     )),
              //   ]),
              // ),
              
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Icon(MdiIcons.google, size: 36, color: Colors.green),
              //     ),
              //     Icon(Icons.facebook, size: 36, color: Colors.blue),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Icon(
              //         MdiIcons.twitter,
              //         size: 36,
              //         color: Colors.redAccent,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
            ),
        ),
      )
    );
  }
}
