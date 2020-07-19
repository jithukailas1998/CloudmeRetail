import 'package:cloudmeretail/api.dart';
import 'package:cloudmeretail/filter.dart';
import 'package:cloudmeretail/otherlocation.dart';
import 'package:cloudmeretail/stockjson.dart';
import 'package:cloudmeretail/userlocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_beep/flutter_beep.dart';

class Stocks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stock(),
    );
  }
}

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> with SingleTickerProviderStateMixin {
  List<Variant> itemsToDisplay;
  List<Variant> itemsToDisplayLoc;
  NormalClass itemNormal;
  List<ColourMaster> itemCol;
  List<Location> itemLoc;
  List<Location> itemSize;
  List<Variant> dataSelected;
  List<Variant> dataSelect;
  final controller = TextEditingController();
  String barcode;
  String scanBarcode = '';
  List barCode = [];
  String result, counter = "Hey there !";
  bool showSpin = false;

  clear() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 2),
                  margin: const EdgeInsets.only(
                      left: 50.0, bottom: 0.0, top: 8, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (String text) async {
                      setState(() {
                        showSpin = true;
                      });
                      //getData(text);

                      //print(text.length);
                      barcode = controller.text;
                      //print("jithukailas"+barcode);

                      final data = await getData(barcode);
                      final colorData = await getItem();
                      //final locdata = await getItem();
                      print("Data Returned = $data");
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('barcode_id', barcode);
                      var locaa = prefs.getString('locat');
                      var bar = prefs.getString('barcode_id');
                      print("barcode" + bar);

                      print("location $locaa");
                      if (data.variant != null) {
                        setState(() {
                          dataSelected = data.variant.where((item) {
                            print("jk" + "${item.loccode}");
                            if (("${item.loccode}" ==
                                locaa)) //|| textColor == "All"))
                              return true;
                            return false;
                          }).toList();
                        });
                        setState(() {
                          dataSelect = data.variant.toList();
                        });
                      }

                      NormalClass normSelected = data.normal;
                      print("Normal $normSelected");
                      List<ColourMaster> color =
                          colorData.colourMaster.toList();
                      List<Location> loc = colorData.locations.toList();
                      List<Location> s = colorData.sizeMaster.toList();
                      setState(() {
                        //_stock = data;
                        if (true) {
                          itemsToDisplayLoc = dataSelected;
                          itemsToDisplay = dataSelect;
                          itemNormal = normSelected;
                          itemCol = color;
                          itemLoc = loc;
                          itemSize = s;
                        }
                      });
                      setState(() {
                        showSpin = false;
                      });
                      print("Item to be displayed = $itemsToDisplayLoc");
                      clear();
                    },
                    controller: controller,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Enter the Barcode",
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.only(left: 23.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                child: new IconButton(
                    icon: Image.asset(
                      "assets/barcode.png",
                      width: 70,
                      height: 70,
                    ),
                    onPressed: () async {
                      scanBarcodeNormal();
                      print("BarData" + scanBarcode);
                    }),
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 6.0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: Text("User Location"),
                ),
              ),
              Tab(
                child: Container(
                  child: Text("Other Locations"),
                ),
              )
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpin,
          child: TabBarView(
            children: <Widget>[
              UserLocation(
                  stockData: itemsToDisplayLoc,
                  colorDrop: itemCol,
                  sizeDrop: itemSize,
                  normalItem: itemNormal,
                  barcodedata: barcode),
              OtherLocation(
                  stockData: itemsToDisplay,
                  colorDrop: itemCol,
                  locData: itemLoc,
                  sizeDrop: itemSize,
                  normalItem: itemNormal),
            ],
          ),
        ),
      ),
    );
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      FlutterBeep.beep(false);
      //FlutterBeep.playSysSound(41);
      //FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);

      showSpin = true;
    });
    //getData(text);

    //print(text.length);
    barcode = barcodeScanRes;
    print("jithukailas" + barcode);

    final data = await getData(barcodeScanRes);
    final colorData = await getItem();
    //final locdata = await getItem();
    print("Data Returned = $data");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('barcode_id', barcode);
    var locaa = prefs.getString('locat');
    var bar = prefs.getString('barcode_id');
    print("barcode" + bar);

    print("location $locaa");
    if (data.variant != null) {
      setState(() {
        dataSelected = data.variant.where((item) {
          print("jk" + "${item.loccode}");
          if (("${item.loccode}" == locaa)) //|| textColor == "All"))
            return true;
          return false;
        }).toList();
      });
      setState(() {
        dataSelect = data.variant.toList();
      });
    }

    NormalClass normSelected = data.normal;
    print("Normal $normSelected");
    List<ColourMaster> color = colorData.colourMaster.toList();
    List<Location> loc = colorData.locations.toList();
    List<Location> s = colorData.sizeMaster.toList();
    setState(() {
      //_stock = data;
      if (true) {
        itemsToDisplayLoc = dataSelected;
        itemsToDisplay = dataSelect;
        itemNormal = normSelected;
        itemCol = color;
        itemLoc = loc;
        itemSize = s;
      }
    });
    setState(() {
      showSpin = false;
    });
    print("Item to be displayed = $itemsToDisplayLoc");
    clear();

    //print("Item to be displayed = $itemLoc");
  }
}
