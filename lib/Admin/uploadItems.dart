import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Common/constant.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfodescriptionTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.pinkAccent),
        ),
        title: Text('e-Shop',
            style: TextStyle(
                fontSize: 45.0, color: Colors.white, fontFamily: "Signatra")),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminShiftOrders()));
            },
            icon: Icon(
              Icons.border_color,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SplashScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
      ),
      body: getAdminHomeScreen(),
    );
  }

  getAdminHomeScreen() {
    return Container(
      color: kBackgroundColor.withOpacity(0.10),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.shop_two,
            color: Colors.green,
            size: 200,
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0))),
            child: Text(
              "Add New Items",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              takeImage();
            },
          )
        ]),
      ),
    );
  }

  takeImage() {
    return showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              'Item Image',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Capture With Camera',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: capturePhotowithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  'Select From Gallery',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  capturePhotowithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 680, maxHeight: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.pinkAccent),
        ),
        title: Text('New Product',
            style: TextStyle(
                fontSize: 30.0, color: Colors.white, fontFamily: "Signatra")),
        leading: IconButton(
            onPressed: clearInfo,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          TextButton(
              onPressed: uploading ? null : uploadImageandSavedImage,
              child: Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 320,
            width: MediaQuery.of(context).size.width * 0.10,
            child: Center(
                child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                          file,
                        ),
                        fit: BoxFit.cover)),
              ),
            )),
          ),
          //),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _shortInfodescriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: "Short Info", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                    hintText: "Title", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _priceTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Price", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: "Description", border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearInfo() {
    setState(() {
      file = null;
      _shortInfodescriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageandSavedImage() async {
    setState(() {
      uploading = true;
    });
    String imagedownloadUrl = await uploadItemImage(file);
    saveItemInfo(imagedownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Item");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemRef = Firestore.instance.collection("items");
    itemRef.document(productId).setData({
      "shortInfo": _shortInfodescriptionTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "thumbnailUrl": downloadUrl,
      "status": "available",
      "price": int.parse(_priceTextEditingController.text),
      "title": _titleTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
    });
    setState(() {
      file = null;
      uploading = true;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _shortInfodescriptionTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }
}
