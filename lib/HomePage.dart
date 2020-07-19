import 'package:cloudmeretail/dashboard.dart';
import 'package:cloudmeretail/login.dart';
import 'package:cloudmeretail/purchase.dart';
import 'package:cloudmeretail/sales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _pages = [
    DashBoard(),
    Sale(),
    Purchase(),
  ];
  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.blueGrey, Colors.blueGrey])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        maxRadius: 50,
                        child: Image.asset(
                          "assets/logo.png",
                          width: 70,
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                      ),
                      Text(
                        "Cloud Me",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 20,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text("About Us"),
              ),
            ),
            InkWell(
              onTap: () {
                launch("mailto:info@cloudmesoft.com");
              },
              child: ListTile(
                leading: Icon(Icons.contact_phone),
                title: Text("Contact Us"),
              ),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => NormalScreen()));
              },
              leading: Icon(Icons.lock),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            //backgroundColor: Colors.yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            title: Text("Sales"),
            //backgroundColor: Colors.yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_two),
            title: Text("Purchase"),
            //backgroundColor: Colors.yellow
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
