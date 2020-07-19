import 'dart:async';
import 'package:cloudmeretail/api.dart';
import 'package:cloudmeretail/barcode.dart';
import 'package:cloudmeretail/queueJson.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
import 'package:flutter_beep/flutter_beep.dart';

class Queues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: QueueStock());
  }
}

class Item {
  const Item(this.name);
  final int name;
}

class QueueStock extends StatefulWidget {
  @override
  _QueueStockState createState() => _QueueStockState();
}

class _QueueStockState extends State<QueueStock> {
  int selectedUser;

  var controller = TextEditingController();
  var controll = TextEditingController();
  var priceController = TextEditingController();
  var percentController = TextEditingController();
  String barcode;
  String scanBarcode = '';
  List barCode = [];
  String result, counter = "Hey there !";
  bool showSpin = false;
  List<Queue> queueItem;
  List<Queue> itemDataDisplay = [];
  double grossTotal;
  double finalTotal;
  double vatTotal;
  double taxTotal;
  double unitTotal;
  double unitPrice;
  double unitVat;
  double discountRate = 0.00;
  double disPrice = 0;
  double dis = 0.00;
  double vatDis = 0.00;
  bool disable = true;
  bool disable2 = true;
  String finalDate = '';
  String finalTime = '';
  String fullDT = '';
  int price = 0;
  int n = 0;

  var p;
  clear() {
    controller.clear();
  }

  clear4() {
    controll.clear();
  }

  clear1() {
    priceController.clear();
  }

  clear2() {
    percentController.clear();
  }

  Future<void> error() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Failed',
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Discount cannot applied'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _showMyDialog(double x) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Success',
  //           style: TextStyle(color: Colors.green),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Discount of Rs${x} is applied'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  getCurrentDate() async {
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);
    var formattedTime = "${dateParse.hour}:${dateParse.minute}";

    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    var full =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";

    setState(() {
      finalDate = formattedDate.toString();
      finalTime = formattedTime.toString();
      fullDT = full.toString();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('date', finalDate);
    prefs.setString('time', finalTime);
  }

  int selectedRadio = 0;
  @override
  void initState() {
    super.initState();
  }

  calculateTotalValues() {
    double _finalTotal = 0;
    double _vatTotal = 0;
    double _taxTotal = 0;
    double _grossTotal = 0;

    if (itemDataDisplay.length == 0) {
      setState(() {
        finalTotal = 0;
        discountRate = 0;
        vatTotal = 0;
        taxTotal = 0;
        grossTotal = 0;
      });
      return;
    }
    print("Debug : Recalculating Totals");

    itemDataDisplay.forEach((element) {
      double _unitPrice = element.price.toDouble();
      int _n = element.quantity;

      double _elementGross =
          (_unitPrice / (1 + int.parse((element.vat)) / 100) * _n);
      double _elementTax =
          ((_unitPrice / (1 + int.parse((element.vat)) / 100) * _n) -
              discountRate);
      double _elementVat = ((_unitPrice * _n -
              (element.price / (1 + int.parse((element.vat)) / 100) * _n)) -
          vatDis);
      double _elementTotal = (_elementTax + _elementVat);

      _finalTotal += _elementTotal;
      _vatTotal += _elementVat;
      _taxTotal += _elementTax;
      _grossTotal += _elementGross;
    });

    setState(() {
      finalTotal = _finalTotal;
      vatTotal = _vatTotal;
      taxTotal = _taxTotal;
      grossTotal = _grossTotal;
    });
  }

  Future<bool> press() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you really want to exit"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: press,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          leading: Icon(Icons.add_shopping_cart),
          backgroundColor: Colors.blueGrey,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 1),
                  margin: const EdgeInsets.only(
                      left: 30.0, bottom: 2.0, top: 3, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (String text) async {
                      //getData(text);
                      //print(text.length);
                      var barcode = controller.text;
                      final List<Queue> queue = await queueBuster(barcode);
                      print("Data Returned = $queue");
                      setState(() {
                        for (var data in queue) {
                          itemDataDisplay.add(data);
                        }
                        //Re Calculate total

                        print("Queue" + "$itemDataDisplay");
                      });
                      calculateTotalValues();
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
        ),
        body: Container(
            child: itemDataDisplay == null
                ? Center(
                    child: Text("Hai"),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (cont, index) => Divider(
                            color: Colors.black,
                          ),
                          itemCount: itemDataDisplay == null
                              ? 0
                              : itemDataDisplay.length,
                          itemBuilder: (conte, index) {
                            //calculateTotalValues();

                            Queue nDataList = itemDataDisplay[index];
                            int count = index;
                            count = count + 1;
                            return Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  color: Colors.red,
                                  child: Icon(Icons.delete),
                                ),
                                onDismissed: (direction) {
                                  //Re Calcuate after Removing
                                  setState(() {
                                    itemDataDisplay.removeAt(index);
                                    print("New List $itemDataDisplay");
                                  });
                                  calculateTotalValues();
                                },
                                direction: DismissDirection.endToStart,
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          40.0))),
                                          backgroundColor: Colors.blueGrey,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext contex) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    width: 300,
                                                    color: Colors.blueGrey,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Text("Edit Price",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10)),
                                                  Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .transparent,
                                                          blurRadius: 10.0,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    width: 300,
                                                    child: new TextFormField(
                                                      textInputAction:
                                                          TextInputAction.go,
                                                      onFieldSubmitted:
                                                          (String text) async {
                                                        setState(() {
                                                          nDataList.price =
                                                              int.parse(controll
                                                                  .text);
                                                          calculateTotalValues();
                                                        });
                                                      },
                                                      controller: controll,
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                              fillColor:
                                                                  Colors.white,
                                                              hintText: nDataList
                                                                  .price
                                                                  .toStringAsFixed(
                                                                      2),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                    thickness: 2,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // int vv = alert(
                                                      //     nDataList.quantity);
                                                      // print("gvfhsavgh $vv");
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 45,
                                                      color: Colors.blueGrey,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Text(
                                                        "Edit Quantity",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10)),
                                                  // Column(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .center,
                                                  //   children: <Widget>[
                                                  //     Text(
                                                  //       'Callback from the counter control: ${nDataList.quantity}',
                                                  //     ),
                                                  //     Counter(
                                                  //       initialValue:
                                                  //           nDataList.quantity,
                                                  //       minValue: 1,
                                                  //       maxValue: 100,
                                                  //       step: 1,
                                                  //       decimalPlaces: 0,
                                                  //       onChanged: (value) {
                                                  //         setState(() {
                                                  //           nDataList.quantity =
                                                  //               value;
                                                  //           // _defaultValue =
                                                  //           //     value;
                                                  //           // _counter = value;
                                                  //         });
                                                  //       },
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      IconButton(
                                                          iconSize: 30,
                                                          color: Colors.white,
                                                          icon: new Icon(Icons
                                                              .remove_circle),
                                                          onPressed: () {
                                                            setState(() {
                                                              int _n = nDataList
                                                                  .quantity;
                                                              _n = _n > 1
                                                                  ? _n - 1
                                                                  : 1;

                                                              nDataList
                                                                  .quantity = _n;
                                                            });
                                                          }),
                                                      new Text(
                                                        nDataList.quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 18),
                                                      ),
                                                      new IconButton(
                                                        icon: new Icon(
                                                            Icons.add_circle),
                                                        onPressed: () {
                                                          setState(() {
                                                            nDataList
                                                                .quantity++;
                                                            // int _n = nDataList
                                                            //     .quantity;
                                                            // _n++;
                                                            // nDataList.quantity =
                                                            //     _n;
                                                          });
                                                        },
                                                        iconSize: 30,
                                                        color: Colors.white,
                                                      ),
                                                      // FlatButton(
                                                      //   child: Text('+'),
                                                      //   onPressed: () {
                                                      //     setState(() {
                                                      //       nDataList
                                                      //           .quantity++;
                                                      //       // int _n = nDataList
                                                      //       //     .quantity;
                                                      //       // _n++;
                                                      //       // nDataList.quantity =
                                                      //       //     _n;
                                                      //     });
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    onPressed: () {
                                                      calculateTotalValues();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Done"),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    leading: new Text(
                                      "${count.toString()})",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 15),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: new Text(
                                        nDataList.itemname,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    subtitle: new Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 5.0, 25.0, 5.0),
                                                child: new Text(
                                                  "Price",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 5.0, 25.0, 5.0),
                                                child: new Text(
                                                  nDataList.price
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 5.0, 20.0, 5.0),
                                                child: Text(
                                                  "qty",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 5.0, 20.0, 5.0),
                                                child: Text(
                                                  nDataList.quantity.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30.0, 5.0, 30.0, 5.0),
                                                child: Text(
                                                  "Total".toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30.0, 5.0, 30.0, 5.0),
                                                child: Text(
                                                  (nDataList.price *
                                                          nDataList.quantity)
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                                  ),
                                ));
                          },
                        ),
                      ),
                      itemDataDisplay == null
                          ? Center(child: Text(""))
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, top: 10.0, bottom: 10.0, right: 30),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              grossTotal == null ? "" : "Gross",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null
                                                  ? ""
                                                  : "Discount",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              taxTotal == null ? "" : "Taxable",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              vatTotal == null ? "" : "Vat",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              finalTotal == null ? "" : "Total",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              grossTotal == null ? "" : ":",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null ? "" : ":",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null ? "" : ":",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null ? "" : ":",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null ? "" : ":",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              grossTotal == null
                                                  ? ""
                                                  : "${grossTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              grossTotal == null
                                                  ? ""
                                                  : "${discountRate.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              taxTotal == null
                                                  ? " "
                                                  : "${taxTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              vatTotal == null
                                                  ? " "
                                                  : "${vatTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              finalTotal == null
                                                  ? " "
                                                  : "${finalTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  )),
        bottomNavigationBar: new Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: new MaterialButton(
                  onPressed: () async {
                    getCurrentDate();
                    print("Date = $finalDate");
                    print("Date = $fullDT");
                    final data = await holdQueue(finalDate, fullDT, finalTotal,
                        grossTotal, vatTotal, taxTotal, discountRate);
                    print('hold data : $data');

                    //var tra = data[''
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40.0))),
                        isDismissible: true,
                        enableDrag: false,
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    height: 60,
                                    width: 350,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            grossTotal == null ? "" : "Gross",
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            grossTotal == null
                                                ? ""
                                                : grossTotal.toStringAsFixed(2),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    height: 60,
                                    width: 350,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            grossTotal == null ? "" : "Vat",
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            grossTotal == null
                                                ? ""
                                                : vatTotal.toStringAsFixed(2),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    height: 60,
                                    width: 350,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            grossTotal == null ? "" : "Total",
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            grossTotal == null
                                                ? ""
                                                : finalTotal.toStringAsFixed(2),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      //child: Text(grossTotal.toStringAsFixed(2),textAlign: TextAlign.left,),
                                    )),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // RaisedButton(
                                    //   color: Colors.blueGrey,
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius:
                                    //         BorderRadius.circular(30.0),
                                    //   ),

                                    //   onPressed: () {
                                    //     //_printDocument(grossTotal,vatTotal,discountRate,finalTotal);
                                    //     getCurrentDate();
                                    //     print("Date = $finalDate");
                                    //     print("Date = $finalTime");
                                    //     _printDocument(
                                    //         grossTotal,
                                    //         vatTotal,
                                    //         discountRate,
                                    //         finalTotal,
                                    //         finalTime,
                                    //         finalDate);
                                    //   },
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         "Generate Bill",
                                    //         textAlign: TextAlign.left,
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   //child: Text(grossTotal.toStringAsFixed(2),textAlign: TextAlign.left,),
                                    // ),
                                    RaisedButton(
                                      color: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),

                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var tId = prefs.getString('trans_id');
                                        print('baljvh $tId');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext ctx) =>
                                                    MyApp(transId: tId)));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            "View Number",
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      //child: Text(grossTotal.toStringAsFixed(2),textAlign: TextAlign.left,),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        });
                  },
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Hold",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  color: Colors.blueGrey,
                )),
                Expanded(
                    child: new MaterialButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40.0))),
                        isDismissible: true,
                        enableDrag: false,
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                Text(
                                    "Discount on ${finalTotal.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 20)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                Container(
                                  height: 60,
                                  width: 350,
                                  child: new TextFormField(
                                    enabled: disable2,

                                    onChanged: (String text) {
                                      setState(() {
                                        percentController.text;
                                      });
                                    },
                                    // onFieldSubmitted: (String text) async {
                                    //   setState(() {
                                    //     if ((taxTotal -
                                    //             double.parse(
                                    //                 priceController.text)) >
                                    //         0.00) {
                                    //       discountRate = (double.parse(
                                    //           priceController.text));
                                    //       dis = ((double.parse(
                                    //                   priceController.text) *
                                    //               100) /
                                    //           taxTotal);
                                    //       print("Discount = $dis");
                                    //       taxTotal = taxTotal -
                                    //           double.parse(
                                    //               priceController.text);
                                    //       vatDis = ((dis * vatTotal) / 100);
                                    //       vatTotal = vatTotal - vatDis;
                                    //       finalTotal = taxTotal + vatTotal;
                                    //       _showMyDialog(discountRate);
                                    //       clear1();
                                    //     } else {
                                    //       error();
                                    //     }
                                    //   });
                                    // },
                                    controller: priceController,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        labelText: "jithu",
                                        fillColor: Colors.white,
                                        hintText: "Amount in ADE",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                Container(
                                  height: 60,
                                  width: 350,
                                  child: new TextFormField(
                                    onChanged: (String text) {
                                      setState(() {
                                        priceController.text;
                                      });
                                    },
                                    // onFieldSubmitted: (String text) async {
                                    //   // setState(() {
                                    //   //   (double.parse(priceController.text) *
                                    //   //           100) /
                                    //   //       taxTotal;

                                    //   //   //dis = ((double.parse(priceController.text) * 100)/taxTotal);
                                    //   //   print("Discount = $discountRate");
                                    //   //   //taxTotal = taxTotal - discountRate;
                                    //   //   if ((taxTotal -
                                    //   //           (((double.parse(
                                    //   //                       percentController
                                    //   //                           .text)) *
                                    //   //                   taxTotal) /
                                    //   //               100)) >
                                    //   //       0.00) {
                                    //   //     dis = (double.parse(
                                    //   //         percentController.text));
                                    //   //     discountRate = (dis * taxTotal) / 100;
                                    //   //     taxTotal = taxTotal - discountRate;
                                    //   //     vatDis = ((dis * vatTotal) / 100);
                                    //   //     vatTotal = vatTotal - vatDis;
                                    //   //     finalTotal = taxTotal + vatTotal;
                                    //   //     _showMyDialog(discountRate);
                                    //   //   } else {
                                    //   //     error();
                                    //   //   }

                                    //   //   clear2();
                                    //   // });
                                    // },
                                    controller: percentController,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: "Amount in %",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                ),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Close"),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("More",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  color: Colors.white,
                ))
              ],
            )),
      ),
    );
  }

  // void _printDocument(
  //     double g, double v, double d, double t, String time, String x) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('cName');

  //   Printing.layoutPdf(
  //     onLayout: (pageFormat) {
  //       final doc = pw.Document();
  //       doc.addPage(
  //         pw.Page(
  //             build: (pw.Context context) => pw.Container(
  //                     child: pw.Column(children: [
  //                   pw.Text(token),
  //                   pw.Text("Gross Rate : ${g.toStringAsFixed(2)}"),
  //                   pw.Text("Vat: ${v.toStringAsFixed(2)}"),
  //                   pw.Text("Discount Rate: ${d.toStringAsFixed(2)}"),
  //                   pw.Text("Total : ${t.toStringAsFixed(2)}"),
  //                   //pw.Text("Time : ")
  //                 ]))),
  //       );

  //       return doc.save();
  //     },
  //   );
  // }

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
      showSpin = true;
    });
    final List<Queue> queue = await queueBuster(barcodeScanRes);
    setState(() {
      for (var data in queue) {
        itemDataDisplay.add(data);
      }
      //Re Calculate total

      print("Queue" + "$itemDataDisplay");
    });
    calculateTotalValues();

    setState(() {
      showSpin = false;
    });
    //print("Item to be displayed = $itemLoc");*/
  }
}
