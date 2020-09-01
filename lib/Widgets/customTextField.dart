import 'package:e_shop/Common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  final Function() press;
  final TextInputType keyboard;

  CustomTextField({
    Key key,
    this.controller,
    this.data,
    this.hintText,
    this.isObsecure,
    this.press,
    this.keyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(kDefaultPadding / 2),
      margin: EdgeInsets.all(kDefaultPadding / 2.5),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.pinkAccent.withOpacity(0.35),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: kPrimarycolor.withOpacity(0.35),
                width: 1,
              )),
          focusColor: Theme.of(context).primaryColor,
          suffixIcon: IconButton(
              icon: Icon(
                data,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: press),
          hintText: hintText,
        ),
        keyboardType: keyboard,
      ),
    );
  }
}
