import 'dart:async';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloudmeretail/FadeAnimation.dart';
import 'package:cloudmeretail/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';


void main() {
  runApp(new MaterialApp(
    title: "CloudMe Retail",
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
    routes: {
      '/first': (context) => SplashScreen(),
      '/second': (context) => HomeScreen(),

    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if(token == null){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => NormalScreen()));
    }
    else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => HomeScreen()));
    }

  }
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/splash.jpg'),
              fit: BoxFit.cover
          ) ,
        ),


        child: ClipRRect( // make sure we apply clip it properly
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: FadeAnimation(2, Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SizedBox(
                  width: 170.0,
                  child: ScaleAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "Cloud Me",
                      ],
                      textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                          fontFamily: "Canterbury"
                      ),
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.topCenter // or Alignment.topLeft
                  ),
                ),
                    //Text("Cloud Me",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),)
                  ],
                )
            ),
            ),
          ),
        ),

      ),
    );
  }
}