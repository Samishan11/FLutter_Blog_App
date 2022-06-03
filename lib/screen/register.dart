import 'package:blog_app/http/httpUser.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var title = "Blog App";
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  // register user
  Future<bool> registerData(
      String username, String email, String password) async {
    var responce = HttpUser().registerUser(username, email, password);
    return responce;
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 280,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "images/Mobile-login.jpg",
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 20),
                        child: TextFormField(
                          key: Key('username'),
                          onSaved: (val) {
                            username = val!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "username required"),
                          ]),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                            hintText: "enter your username",
                            hintStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40.0)),
                            ),
                            prefixIcon: Icon(
                              Icons.people,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextFormField(
                          key: Key('email'),
                          onSaved: (val) {
                            email = val!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "email required"),
                            EmailValidator(errorText: "invalid email")
                          ]),
                          keyboardType: TextInputType.emailAddress,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 20),
                        child: TextFormField(
                          key: Key('password'),
                          onSaved: (val) {
                            password = val!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "password required"),
                            MinLengthValidator(6,
                                errorText:
                                    "password must be more than 6 character")
                          ]),
                          decoration: const InputDecoration(
                            labelText: 'Password',
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
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        ElevatedButton(
                          key: Key('register'),
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
                              var res =
                                  await registerData(username, email, password);
                              if (res) {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                                MotionToast.success(
                                        description: "Register success")
                                    .show(context);
                               
                              } else {
                                MotionToast.error(
                                        description: "User Already Exist")
                                    .show(context);
                              }
                            }
                          },
                          child: Text(
                            "Sign-up",
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
                                //     builder: (context) => Login(),
                                //   ),
                                // );
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: Login()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
