import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';




class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {

    Widget _image = new Container(
      height: double.infinity,
      width: double.infinity,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage("assets/1.jpg"),
          AssetImage("assets/2.jpg"),
          AssetImage("assets/3.jpg"),
        ],
        autoplay: true,
        dotSize: 5,
        dotBgColor: Colors.transparent,
      ),

    );
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Container(
          child: _image,
        ),
      ),
    );
  }
}
