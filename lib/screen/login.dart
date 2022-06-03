import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blog_app/http/httpUser.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var title = "Blog App";
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
// login user
  Future<bool> login(String email, String password) async {
    var response = HttpUser().loginUser(email, password);
    return response;
  }

//notification
  void notify() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Logged in Successfully',
          body: 'body text/ content',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture:
              'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "images/Mobile-register.jpg",
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: Key('email'),
                          onSaved: (val) {
                            email = val!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "email required"),
                            EmailValidator(errorText: "invalid email")
                          ]),
                          decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40.0)),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                           key: Key('password'),
                          onSaved: (val) {
                            password = val!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "password required")
                          ]),
                          decoration: const InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40.0)),
                            ),
                            prefixIcon: Icon(
                              MdiIcons.key,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        ElevatedButton(
                           key: Key('login'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            // primary: Colors.blueGrey.shade800,
                            minimumSize: Size(150, 45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              var res = await login(email, password);
                              if (res) {
                                notify();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType
                                            .leftToRightWithFade,
                                        child: BlogPage()));
                                MotionToast.success(
                                        description: "Login success")
                                    .show(context);
                              } else {
                                MotionToast.error(
                                        description:
                                            "Email or password not match")
                                    .show(context);
                              }
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => RegisterPage(),
                                //   ),
                                // );
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: RegisterPage()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Or Login With"),
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                            )),
                          ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(MdiIcons.google,
                                  size: 36, color: Colors.green),
                            ),
                            Icon(MdiIcons.facebook,
                                size: 36, color: Colors.blue),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                MdiIcons.twitter,
                                size: 36,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
