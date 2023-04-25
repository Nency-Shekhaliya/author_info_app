import 'dart:convert';
import 'dart:typed_data';

import 'package:author_info_app/helpers/firebasedatastore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  String? authorname;
  String? Bookname;
  Uint8List? imagebytes;

  galleryimage() async {
    ImagePicker Picker = ImagePicker();
    XFile? image =
        await Picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    imagebytes = await image!.readAsBytes();
  }

  GlobalKey<FormState> insertkey = GlobalKey<FormState>();
  GlobalKey<FormState> updatekey = GlobalKey<FormState>();
  TextEditingController authornamecontrtoller = TextEditingController();
  TextEditingController authorbookcontrtoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Books",
          style: GoogleFonts.aclonica(letterSpacing: 5),
        ),
        backgroundColor: Colors.lightGreen.shade200,
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream:
            Firebasedatastore_helper.firebasedatastore_helper.featchallrecord(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
            if (data == null) {
              return Center(
                child: Text("No data Available"),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> alldata =
                  data.docs;
              return GridView.builder(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                itemCount: alldata.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 160,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade50,
                          border: Border.all(
                              color: Colors.lightGreen.shade300, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(
                              base64Decode(alldata[index].data()['image']),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightGreen.shade300, width: 2),
                          color: Colors.lightGreen.shade50,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  alldata[index].data()['Name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.aclonica(fontSize: 12),
                                ),
                                Text(
                                  "${alldata[index].data()['bookname']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              elevation: 10,
                              onSelected: (val) async {
                                if (val == "edit") {
                                  authornamecontrtoller.text =
                                      alldata[index]['Name'];
                                  authorbookcontrtoller.text =
                                      alldata[index]['bookname'];
                                  alldata[index]['image'];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        backgroundColor: Colors.green.shade50,
                                        title: Text(
                                          "Author Details",
                                          style: GoogleFonts.aclonica(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        content: Form(
                                          key: updatekey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  galleryimage();
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.green.shade50,
                                                  foregroundImage:
                                                      (alldata[index].data()[
                                                                  'image'] ==
                                                              null)
                                                          ? null
                                                          : MemoryImage(
                                                              base64Decode(
                                                                  alldata[index]
                                                                          .data()[
                                                                      'image']),
                                                            ),
                                                  child: (alldata[index].data()[
                                                              'image'] ==
                                                          null)
                                                      ? Text(
                                                          alldata[index]
                                                              .data()[
                                                                  'bookname']
                                                              .name[0],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : null,
                                                  radius: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Author Name:",
                                                    style: GoogleFonts.alegreya(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller:
                                                    authornamecontrtoller,
                                                keyboardType:
                                                    TextInputType.name,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onSaved: (val) {
                                                  authorname = val;
                                                },
                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return "Please enter title";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText: "Enter Name",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Author Book:",
                                                    style: GoogleFonts.alegreya(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller:
                                                    authorbookcontrtoller,
                                                keyboardType:
                                                    TextInputType.name,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onSaved: (val) {
                                                  Bookname = val;
                                                },
                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return "Please enter book-name";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText: "Enter Book Name",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  authorname = null;
                                                  Bookname = null;
                                                  imagebytes = null;
                                                });
                                                authornamecontrtoller.clear();
                                                authorbookcontrtoller.clear();
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancle",
                                                style: GoogleFonts.aclonica(
                                                    color: Colors.green),
                                              )),
                                          OutlinedButton(
                                              onPressed: () async {
                                                if (updatekey.currentState!
                                                    .validate()) {
                                                  updatekey.currentState!
                                                      .save();
                                                  Map<String, dynamic>
                                                      updetedrecord = {
                                                    "Name": authorname,
                                                    "bookname": Bookname,
                                                    "image": base64Encode(
                                                        imagebytes!),
                                                  };
                                                  await Firebasedatastore_helper
                                                      .firebasedatastore_helper
                                                      .updaterecored(
                                                          data: updetedrecord,
                                                          id: alldata[index]
                                                              .id);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          content: Text(
                                                              "Add successfully")));
                                                  Navigator.pop(context);

                                                  setState(() {
                                                    authorname = null;
                                                    Bookname = null;
                                                    imagebytes = null;
                                                  });
                                                  authornamecontrtoller.clear();
                                                  authorbookcontrtoller.clear();
                                                }
                                              },
                                              child: Text(
                                                "Update",
                                                style: GoogleFonts.aclonica(
                                                    color: Colors.green),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  await Firebasedatastore_helper
                                      .firebasedatastore_helper
                                      .deleterecored(id: alldata[index].id);
                                }
                              },
                              iconSize: 20,
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: Text("Edit"),
                                    value: "edit",
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: "delete",
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.6),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            insertdata();
          },
          backgroundColor: Colors.lightGreen.shade200,
          child: Icon(Icons.add)),
    );
  }

  insertdata() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.green.shade50,
          title: Text(
            "Author Details",
            style: GoogleFonts.aclonica(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: insertkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    galleryimage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(Icons.camera_alt_outlined),
                    radius: 40,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Author Name:",
                      style: GoogleFonts.alegreya(fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: authornamecontrtoller,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    authorname = val;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter title";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Name",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Author Book:",
                      style: GoogleFonts.alegreya(fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authorbookcontrtoller,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    Bookname = val;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter book-name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Book Name",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    authorname = null;
                    Bookname = null;
                    imagebytes = null;
                  });
                  authornamecontrtoller.clear();
                  authorbookcontrtoller.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancle",
                  style: GoogleFonts.aclonica(color: Colors.green),
                )),
            OutlinedButton(
                onPressed: () async {
                  if (insertkey.currentState!.validate()) {
                    insertkey.currentState!.save();
                    Map<String, dynamic> record = {
                      "Name": authorname,
                      "bookname": Bookname,
                      "image": base64Encode(imagebytes!),
                    };
                    await Firebasedatastore_helper.firebasedatastore_helper
                        .insertdata(data: record);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        content: Text("Add successfully")));
                    Navigator.pop(context);

                    setState(() {
                      authorname = null;
                      Bookname = null;
                      imagebytes = null;
                    });
                    authornamecontrtoller.clear();
                    authorbookcontrtoller.clear();
                  }
                },
                child: Text(
                  "Add",
                  style: GoogleFonts.aclonica(color: Colors.green),
                )),
          ],
        );
      },
    );
  }
}
