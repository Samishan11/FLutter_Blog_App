import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:blog_app/Url/baseurl.dart';
import 'package:blog_app/model/blogModel.dart';
import 'package:blog_app/screen/blog.dart';
import 'package:blog_app/screen/sideBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:http/http.dart' as http;

class Updateblog extends StatefulWidget {
  final data;
  const Updateblog({Key? key, @required this.data}) : super(key: key);

  @override
  _UpdateblogState createState() => _UpdateblogState();
}

class _UpdateblogState extends State<Updateblog> {
  File? _image;
  final _fromkey = GlobalKey<FormState>();

  // String baseurl = 'http://10.0.2.2:5000/';
  // String baseurl = 'http://192.168.1.54:5000/';
  // String baseurl = 'http://172.25.1.220:5000';
  String token = '';
  final storage = new FlutterSecureStorage();

  Future<String> uploadblogImage(String filepath, String id) async {
    try {
      String url = baseurl + 'upload/blog/photo/' + id;
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      var token = await storage.read(key: 'token');
      request.headers.addAll({
        'Content-type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });
      // need a filename
      var filename = filepath.split('/').last;
      // adding the file in the request
      request.files.add(
        http.MultipartFile(
          'image',
          File(filepath).readAsBytes().asStream(),
          File(filepath).lengthSync(),
          filename: filename,
        ),
      );

      var response = await request.send();
      print(filepath + id);
      print(response);
      var responseString = await response.stream.bytesToString();
      print(responseString);
      if (response.statusCode == 200) {
        return "ok";
      }
    } catch (e) {
      print(e);
    }
    return 'something went wrong';
  }

  // update blog
  void updateblogInfo(Blogmodel blog, File? file) async {
    String s = '';
    Map<String, dynamic> blogdata = {
      'title': blog.title,
      'catagory': blog.catagory,
      'description': blog.description
    };
    var token = await storage.read(key: 'token');
    // print(token);
    try {
      var blogid = widget.data['_id'];

      var response = await http.put(
          Uri.parse(baseurl + 'blog/update/${blogid}'),
          body: blogdata,
          headers: {
            'Authorization': 'Bearer $token',
          });
      // print(response);
      if (response.statusCode == 201) {
        widget.data['_id'];
        if (file != null) {
          s = await uploadblogImage(file.path, widget.data['_id']);
          if (s == "ok") {
            print(s);
            print('successfully post blog');
          } else {
            print("shaj");
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //
  String title = '';
  String catagory = '';
  String description = '';

  Future<bool> updateBlog_() async {
    var token = await storage.read(key: 'token');
    var id = widget.data['_id'];
    // try {
    var postUri = Uri.parse(baseurl + "blog/update/${id}");
    var request = new http.MultipartRequest("PUT", postUri);
    print(request);
    //Header....
    request.headers['Authorization'] = 'Bearer ${token}';
    request.fields['title'] = title;
    request.fields['catagory'] = catagory;
    request.fields['description'] = description;
    // image
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
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
  void initState() {
    super.initState();
    _image = null;
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    // hello();
    String title1 = '${widget.data['title']}';
    String catagory1 = '${widget.data['catagory']}';
    String description1 = '${widget.data['description']}';

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
                            ? NetworkImage(baseurl + '${widget.data['image']}')
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
                       key:Key('title'),
                      // controller: TextEditingController(text: '$title1'),
                      initialValue: '${widget.data['title']}',
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
                       key:Key('catagory'),
                      // controller: TextEditingController(text: '$catagory1'),
                       initialValue: '${widget.data['catagory']}',
                      onSaved: (val) {
                        catagory = val!;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Catagory cannot be empty";
                        }
                      },
                      decoration: InputDecoration(
                        label: Text('Catagory'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.select_all,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(12.0),
                    child: TextFormField(
                       key:Key('description'),
                      // controller: TextEditingController(text: '$description1'),
                       initialValue: '${widget.data['description']}',
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
                      decoration:  InputDecoration(
                        label: Text('Description'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      key:Key('Update'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40)),
                      onPressed: ()async {
                        if (_fromkey.currentState!.validate()) {
                          _fromkey.currentState!.save();
                          _fromkey.currentState!.reset();
                          // Blogmodel blog = Blogmodel(
                          //     title: title,
                          //     catagory: catagory,
                          //     description: description);
                          // // print(_image);
                          // if (_image != null) {
                           var a =await updateBlog_();
                           if(a){
                              MotionToast.success(
                                    description: "Update Sucessfully")
                                .show(context);
                            // updateblogInfo(blog, _image);
                            setState(() {});
                           }
                        //   } else {
                        //     print("Something went wrong");
                        //   }
                        }
                      },
                      child: Text(
                        "Update",
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
