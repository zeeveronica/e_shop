import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  File _imageFile;
  String userImageUrl = '';
  bool _passwordvisible = false;
  bool _isObsecure = true;
  bool cpasswordvisible = false;
  bool _cisObsecure = true;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment
                .bottomRight, // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Colors.indigoAccent,
              Colors.pinkAccent.withOpacity(0.3)
            ], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              InkWell(
                  onTap: _selectImagePick,
                  child: CircleAvatar(
                      radius: _screenwidth * 0.15,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _imageFile == null ? null : FileImage(_imageFile),
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo_outlined,
                              size: _screenwidth * 0.15,
                              color: Colors.grey,
                            )
                          : null)),
              SizedBox(height: 10),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameTextEditingController,
                        data: Icons.people,
                        hintText: "Enter Your Name",
                        isObsecure: false,
                        keyboard: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: _emailTextEditingController,
                        data: Icons.email,
                        hintText: "Enter Your Email",
                        isObsecure: false,
                        keyboard: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        controller: _passwordTextEditingController,
                        isObsecure: _isObsecure,
                        data: _passwordvisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        press: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordvisible = !_passwordvisible;
                            _isObsecure = !_isObsecure;
                          });
                        },
                        hintText: "Enter Your Password",
                        keyboard: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: _cPasswordTextEditingController,
                        isObsecure: _cisObsecure,
                        data: cpasswordvisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        press: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            cpasswordvisible = !cpasswordvisible;
                            _cisObsecure = !_cisObsecure;
                          });
                        },
                        hintText: "Confirm Password",
                        keyboard: TextInputType.text,
                      ),
                    ],
                  )),
              elevatedbutton(
                  name: "singup",
                  press: () {
                    uploadandSavedImage();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImagePick() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadandSavedImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "please Select an image file..");
          });
      // }
    } else {
      _nameTextEditingController.text.isNotEmpty &&
              _emailTextEditingController.text.isNotEmpty &&
              _passwordTextEditingController.text.isNotEmpty &&
              _cPasswordTextEditingController.text.isNotEmpty
          ? _passwordTextEditingController != _cPasswordTextEditingController
              ? uploadToStorage()
              : displayMessage("Password Don't Match")
          : displayMessage("Please fill up complete Form");
    }
  }

  displayMessage(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg);
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registering, Please wait.....',
          );
        });
    String ImageFilename = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(ImageFilename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInformation(firebaseUser).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    }
  }

  Future saveUserInformation(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "name": _nameTextEditingController.text.trim(),
      "email": fUser.email,
      "url": userImageUrl,
      EcommerceApp.userCartList: ['garbageValue']
    });
    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ['garbageValue']);
  }
}

class elevatedbutton extends StatelessWidget {
  const elevatedbutton({
    Key key,
    this.name,
    this.press,
  }) : super(key: key);
  final String name;
  final Function() press;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(260, 45),
            primary: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
        onPressed: press,
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Signatra",
              letterSpacing: 3),
        ));
  }
}
