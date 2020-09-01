import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Common/constant.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
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
                      child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
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
        ),
        drawer: MyDrawer(),
        body: Container(
          color: kBackgroundColor.withOpacity(0.10),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true, delegate: SearchBoxDelegate()),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('items')
                    .limit(15)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapShot) {
                  return !dataSnapShot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapShot.data.documents[index].data);
                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapShot.data.documents.length,
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductPage(itemModel:model)));
      },
      splashColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 6),
        child: Container(
          height: 180,
          width: width,
          child: Row(
            children: [
              Image.network(
                model.thumbnailUrl,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child:
                            Text(model.title, style: TextStyle(fontSize: 14)),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child: Text(model.shortInfo,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black38)),
                      )
                    ]),
                  ),
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Container(
                      height: 40,
                      width: 43,
                      color: Colors.green,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "50%",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            "OFF",
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white),
                          )
                        ],
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(
                                r"Original price:₹",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                (model.price + model.price).toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(
                                "New price:",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                              Text(
                                "₹",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.red),
                              ),
                              Text(
                                (model.price).toString(),
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                  Flexible(child: Container()),
                ],
              ))
            ],
          ),
        ),
      ));
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
