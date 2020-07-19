import 'package:cloudmeretail/sales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';


class MyApp extends StatelessWidget {
  MyApp({this.transId});
  final String transId;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(
        barcodes: [
          BarCodeItem(
            description: "Code39 with text",
            image: BarCodeImage(
              params: Code39BarCodeParams(
                transId,
                withText: true,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.barcodes});
  final List<BarCodeItem> barcodes;
  final String title = "BarCode";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: widget.barcodes.map((element) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: element.image,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        child: MaterialButton(
          color: Colors.blueGrey,
          onPressed: () {
//            Navigator.of(context, rootNavigator: true).push(
//              CupertinoPageRoute<bool>(
//                fullscreenDialog: true,
//                builder: (BuildContext context) => Sale(),
//              ),
//            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Sale()),
            );
          },
          child:  new Text("New Sale",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}

class BarCodeItem {
  String description;
  BarCodeImage image;
  BarCodeItem({
    this.image,
    this.description,
  });
}