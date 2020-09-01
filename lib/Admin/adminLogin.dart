import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     iconTheme: IconThemeData(color: Colors.pinkAccent),
      //     title: Text('e-Shop',
      //         style: TextStyle(
      //             fontSize: 65.0,
      //             color: Colors.pinkAccent,
      //             fontFamily: "Signatra")),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     centerTitle: true),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _passwordvisible = false;
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //     iconTheme: IconThemeData(color: Colors.pinkAccent),
        //     title: Text('e-Shop',
        //         style: TextStyle(
        //             fontSize: 65.0,
        //             color: Colors.pinkAccent,
        //             fontFamily: "Signatra")),
        //     backgroundColor: Colors.transparent,
        //     elevation: 0,
        //     centerTitle: true),
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
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  SizedBox(height: 120),
                  Image.asset(
                    "images/admin.png",
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text('Admin',
                      style: TextStyle(
                          fontSize: 55.0,
                          color: Colors.pinkAccent,
                          fontFamily: "Signatra")),
                  Form(
                      key: _formkey,
                      child: Column(children: [
                        CustomTextField(
                          controller: _adminTextEditingController,
                          data: Icons.nature_people,
                          hintText: "id",
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
                        _adminTextEditingController.text.isNotEmpty &&
                                _passwordTextEditingController.text.isNotEmpty
                            ? loginAdmin()
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
                    name: "I'm not Admin",
                    press: () {
                      print('vero');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthenticScreen()));
                    },
                  ),
                ]))));
  }

  loginAdmin() {
    Firestore.instance.collection("admin").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your id is not correct"),
          ));
        } else if (result.data['Password'] !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your password is not correct"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Dear Admin" + result.data['Name']),
          ));
          setState(() {
            _adminTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UploadPage()));
        }
      });
    });
  }
}
