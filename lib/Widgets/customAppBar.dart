import 'package:e_shop/Common/constant.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.pinkAccent),
      title: Text('e-Shop',
          style: TextStyle(
              fontSize: 55.0,
              color: Colors.pinkAccent,
              fontFamily: "Signatra")),
      backgroundColor: kBackgroundColor.withOpacity(0.10),
      elevation: 0,
      centerTitle: true,
      actions: [
        Stack(children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            icon: Icon(Icons.shopping_cart),
            color: Colors.pinkAccent,
          ),
          Positioned(
              child: Stack(
            children: [
              Icon(
                Icons.brightness_1,
                size: 20,
                color: Colors.green,
              ),
              Positioned(
                  top: 3.0,
                  bottom: 4.0,
                  left: 4.0,
                  child:
                      Consumer<CartItemCounter>(builder: (context, counter, _) {
                    return Text(
                      counter.count.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    );
                  }))
            ],
          ))
        ])
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
