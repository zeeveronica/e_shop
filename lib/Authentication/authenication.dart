import 'package:e_shop/Authentication/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/e_shop_logo.png",
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 0,
            ),
            Text('e-Shop',
                style: TextStyle(
                    fontSize: 65.0,
                    color: Colors.pinkAccent,
                    fontFamily: "Signatra")),
            SizedBox(
              height: 20,
            ),
            Button(
              name: "login",
              press: () {
                print('vero');
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              name: "register",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key key,
    this.name,
    this.press,
  }) : super(key: key);
  final String name;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: Size(260, 45),
            primary: Colors.black38,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            side: BorderSide(
                color: Colors.pinkAccent.withOpacity(0.35), width: 1)),
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
