import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/http/httpBlog.dart';
import 'package:blog_app/model/blogModel.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:http/http.dart' as http;

class Addblog extends StatefulWidget {
  const Addblog({Key? key}) : super(key: key);

  @override
  _AddblogState createState() => _AddblogState();
}

class _AddblogState extends State<Addblog> {
  File? _image;
  // String baseurl = 'http://10.0.2.2:5000';
  final _fromkey = GlobalKey<FormState>();
  String title = '';
  String catagory = '';
  String description = '';

  final storage = new FlutterSecureStorage();

  //
  @override
  void initState() {
    super.initState();
    _image = null;
  }

  //method to open image from gallery
  _imageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  //method to open image from camera
  _imageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  //
  Future<bool> blogPost_() async {
    var token = await storage.read(key: 'token');
    print(token);
    print("hello");
    // try {
      var postUri = Uri.parse(baseurl + "blog/post");
      var request = new http.MultipartRequest("POST", postUri);
      print(request);
      //Header....
      request.headers['Authorization'] = 'Bearer ${token}';
      request.fields['title'] = title;
      request.fields['catagory'] = catagory;
      request.fields['description'] = description;
      // image
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
      http.StreamedResponse response = await request.send();
      print(response);
      final respStr = await response.stream.bytesToString();
      var jsonData = jsonDecode(respStr);
      print(jsonData);
      if (jsonData != null) {
        return true;
      }
      return false;
    // } catch (e) {
    //   return false;
    // }
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
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          child: Center(
            child: Form(
              key: _fromkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: _image == null
                            ? const AssetImage('images/samishan.jpg')
                                as ImageProvider
                            : FileImage(_image!),
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => bottomSheet());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 140, top: 110),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  MdiIcons.camera,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                       key: Key('title'),
                      onSaved: (val) {
                        title = val!;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Title cannot be empty";
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Title'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.title,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                       key: Key('catagory'),
                      onSaved: (val) {
                        catagory = val!;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Catagory cannot be empty";
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Catagory'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.select_all,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      key: Key('description'),
                      onSaved: (val) {
                        description = val!;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Description cannot be empty";
                        }
                      },
                      minLines: 4,
                      // keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        label: Text('Description'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                       key: Key('Post'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40)),
                      onPressed: () async {
                        if (_fromkey.currentState!.validate()) {
                          _fromkey.currentState!.save();
                          // _fromkey.currentState!.reset();
                          // Blogmodel blog = Blogmodel(
                          //   title: title,
                          //   catagory: catagory,
                          //   description: description);
                          // print(_image);
                          // if (_image != null) {
                          //   // Httpblog().blogInfo(blog , _image);
                          var a = await blogPost_();
                          if (a) {
                            MotionToast.success(description: "Post")
                                .show(context);
                            print('posted sucessfully');
                          }
                          //  print("Something went wrong");
                        //   } else {
                        //     // print("Something went wrong");
                        //   }
                        }
                      },
                      child: Text(
                        "Post",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  //
  Widget bottomSheet() {
    return Container(
      height: 105,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            'Choose profile photo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _imageFromCamera();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _imageFromGallery();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
