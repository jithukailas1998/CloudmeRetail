import 'package:cloudmeretail/queue.dart';
import 'package:cloudmeretail/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Sale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Sales(),
    );
  }
}

class Sales extends StatefulWidget {
  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  Material salesData(String image, String heading, Function onTap) {
    return Material(
      color: Colors.white70,
      elevation: 12,
      shadowColor: Colors.white30,
      borderRadius: BorderRadius.circular(30),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2, top: 6),
                        child: Image(
                          image: AssetImage(image),
                          width: 70,
                          height: 60,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        heading,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey,
                            fontSize: 17),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 35,
          mainAxisSpacing: 12,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          children: <Widget>[
            salesData(
              "assets/queue.png",
              "Queue",
              () => {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => QueueStock(),
                  ),
                )
              },
            ),
            salesData(
              "assets/stock.png",
              "Stock Check",
              () => {
                //Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Stocks()))

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Stocks()),
                // )
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => Stocks(),
                  ),
                )
              },
            )
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 120),
            StaggeredTile.extent(1, 120)
          ],
        ),
      ),
    );
  }
}

/*import 'package:cloud/queue.dart';
import 'package:cloud/stock.dart';
import 'package:flutter/material.dart';



class Sales extends StatefulWidget {
  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.blueGrey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {

                  },
                ),
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          color: Colors.white,
                          onPressed: () {},
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Sales',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),

              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 85.0,
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(75.0),topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 100.0,
                        child: ListView(children: [
                          _SalesData('assets/queue.png', 'Queue',()=>{
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Queue()
                            ))
                          }),
                          _SalesData('assets/stock.png', 'Stock Check',()=>{
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Stock()
                            ))
                          }),

                        ]))),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _SalesData(String imgPath, String Data,Function onTap) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(
                        children: [
                          Hero(
                              tag: imgPath,
                              child: Image(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.cover,
                                  height: 65.0,
                                  width: 50.0
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10)
                          ),
                          SizedBox(width: 10.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                    Data,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ]
                          )
                        ]
                    )
                ),
                IconButton(
                    icon: Icon(Icons.chevron_right),
                    color: Colors.black45,
                    onPressed: onTap,
                )
              ],
            )
        ));
  }
}*/
