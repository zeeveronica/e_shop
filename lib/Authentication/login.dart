import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authenication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _passwordvisible = false;
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment
                    .bottomRight, // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  Colors.indigoAccent,
                  Colors.pinkAccent.withOpacity(0.3)
                ], // red to yellow
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            // color: kBackgroundColor.withOpacity(0.10),
            // height: double.infinity,
            // width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  SizedBox(height: 150),
                  Image.asset(
                    "images/login.png",
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                  Form(
                      key: _formkey,
                      child: Column(children: [
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
                        )
                      ])),
                  elevatedbutton(
                      name: "login",
                      press: () {
                        _emailTextEditingController.text.isNotEmpty &&
                                _passwordTextEditingController.text.isNotEmpty
                            ? loginUser()
                            : showDialog(
                                context: context,
                                builder: (c) {
                                  return ErrorAlertDialog(
                                      message:
                                          "Please give Correct Password or Email");
                                });
                      }),
                  SizedBox(height: 30),
                  Button(
                    name: "I'm Admin",
                    press: () {
                      print('vero');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminSignInPage()));
                    },
                  ),
                ]))));
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "Authenticating Please wait... ");
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StoreHome()));
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
