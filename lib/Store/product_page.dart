import 'package:e_shop/Common/constant.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityofItems = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.only(top: 5.0, left: 10),
          //padding: EdgeInsets.only(top: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          color: kBackgroundColor.withOpacity(0.10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.itemModel.thumbnailUrl,
                      height: 340,
                      width: 340,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: SizedBox(
                        height: 1.0,
                        width: double.infinity,
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 15.0, left: 10, bottom: 10),
                  //child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemModel.title,
                        style: boldTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.itemModel.longDescription,
                        // style: largeTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹" + widget.itemModel.price.toString(),
                        style: largeTextStyle,
                      ),
                    ],
                  ),
                ),
                //),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 60),
                  // child: Center(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      color: kBackgroundColor,
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
