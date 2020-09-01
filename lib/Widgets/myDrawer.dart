import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyDrawer extends StatelessWidget {
  final _drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10, top: 25),
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
          child: Column(
            children: [
              Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl)),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                style: TextStyle(
                    fontSize: 45.0,
                    color: Colors.white,
                    fontFamily: "Signatra"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment
                  .bottomRight, // 10% of the width, so there are ten blinds.
              colors: <Color>[
                Colors.pinkAccent.withOpacity(0.3),
                Colors.indigoAccent
              ], // red to yellow
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Column(
            children: [
              buildListTile(
                context,
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                "Home",
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StoreHome()));
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              buildListTile(
                context,
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                "My Orders",
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrders()));
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              buildListTile(
                context,
                Icon(
                  Icons.shopping_cart_sharp,
                  color: Colors.white,
                ),
                "My Carts",
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              buildListTile(
                context,
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                "Search",
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchProduct()));
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              buildListTile(
                context,
                Icon(
                  Icons.add_reaction_sharp,
                  color: Colors.white,
                ),
                "Add New Address",
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddAddress()));
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              buildListTile(
                context,
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                "Logout",
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticScreen()));
                },
              ),
            ],
          ),
        )
      ],
    ));
  }

  ListTile buildListTile(
      BuildContext context, Icon data, String title, Function Tap) {
    return ListTile(
        leading: data,
        tileColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        onTap: Tap);
  }
}
