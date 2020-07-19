import 'package:cloudmeretail/filter.dart';
import 'package:flutter/material.dart';
import 'package:cloudmeretail/stockjson.dart';
import 'package:json_table/json_table.dart';

// ignore: must_be_immutable
class OtherLocation extends StatefulWidget {
  final List<Variant> stockData;
  final List<ColourMaster> colorDrop;
  final List<Location> locData;
  final List<Location> sizeDrop;
  NormalClass normalItem;
  OtherLocation(
      {Key key,
      this.stockData,
      this.colorDrop,
      this.locData,
      this.sizeDrop,
      this.normalItem})
      : super(key: key);

  @override
  _OtherLocationState createState() => _OtherLocationState();
}

class _OtherLocationState extends State<OtherLocation> {
  String textcolor = "All";
  // ignore: non_constant_identifier_names
  String location_code = "All";
  String sizeValue = "All";
  String selectedColor;
  String selectLocation;
  String selectSize;
  List<JsonTableColumn> columns;
  List<Location> loc;
  List<Variant> stockDisplay = new List();
  NormalClass normDisplay;

  List<DataRow> bodyData() {
    return stockDisplay
        .where((element) {
          String colorSlt = textcolor != null
              ? textcolor
              : "All"; //col!=null? col[0].colorName : "All";
          print("sol" + colorSlt);
          String locSlt = location_code != null ? location_code : "All";
          print("Loc" + locSlt);
          String sizeSlt = sizeValue != null ? sizeValue : "All";
          if ((element.colourName == colorSlt || colorSlt == "All") &&
              (element.locationName == locSlt || locSlt == "All") &&
              (element.sizeName == sizeSlt || sizeSlt == "All")) {
            return true;
          }
          return false;
        })
        .map((Variant item) => DataRow(cells: <DataCell>[
              DataCell(
                Text(item.itemBarcode),
              ),
              DataCell(Text(item.colourName)),
              DataCell(Text(item.sizeName)),
              DataCell(Text(item.stockOnHand.toString())),
              DataCell(Text(item.locationName)),
              DataCell(Text(item.retlPrice.toString()))
            ]))
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      stockDisplay = widget.stockData;
      normDisplay = widget.normalItem;
    });

    return Scaffold(
      //resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: stockDisplay == null
              ? normDisplay == null
                  ? Center(
                      child: Text(""),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(columns: <DataColumn>[
                            DataColumn(
                                label: Text(
                                  "Location",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                numeric: false,
                                onSort: (i, b) {},
                                tooltip: "Barcode"),
                            DataColumn(
                                label: Text(
                                  "Quantity",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                numeric: false,
                                onSort: (i, b) {},
                                tooltip: "Color"),
                            DataColumn(
                                label: Text(
                                  "Price",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                numeric: false,
                                onSort: (i, b) {},
                                tooltip: "size"),
                          ], rows: [
                            DataRow(cells: [
                              DataCell(Text(
                                  normDisplay.prices[0].location.locationName)),
                              DataCell(Text(normDisplay.prices[0].stockOnHand
                                  .toString())),
                              DataCell(Text(
                                  normDisplay.prices[0].retlPrice.toString())),
                            ]),
                          ]),
                        ),
                      ],
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Text("Color",style: TextStyle(fontSize: 15),),
                        DropdownButton<String>(
                          hint: Text("Select Color"),
                          value: selectedColor,
                          // ignore: non_constant_identifier_names
                          onChanged: (String Value) {
                            setState(() {
                              selectedColor = Value;
                            });
                          },
                          items: widget.colorDrop.map((ColourMaster map) {
                            return DropdownMenuItem<String>(
                              value: map.colorName,
                              child: Row(
                                children: <Widget>[
                                  //color.icon,
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    map.colorName != null
                                        ? map.colorName
                                        : "All",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          hint: Text("Select Location"),
                          value: selectLocation,
                          // ignore: non_constant_identifier_names
                          onChanged: (String val) {
                            setState(() {
                              selectLocation = val;
                            });
                          },
                          items: widget.locData.map((Location map) {
                            return DropdownMenuItem<String>(
                              value: map.name,
                              child: Row(
                                children: <Widget>[
                                  //color.icon,
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    map.name != null ? "${map.name}" : "All",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          hint: Text("Select Size"),
                          value: selectSize,
                          // ignore: non_constant_identifier_names
                          onChanged: (String Value) {
                            setState(() {
                              selectSize = Value;
                            });
                          },
                          items: widget.sizeDrop.map((Location val) {
                            return DropdownMenuItem<String>(
                              value: val.name,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    val.name != null ? "${val.name}" : "All",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.blueGrey,
                          onPressed: () async {
                            setState(() {
                              //col = color.length>0?color:null;
                              textcolor = selectedColor;
                              location_code = selectLocation;
                              sizeValue = selectSize;
                              bodyData();
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    Center(
                      child: Container(
                        color: Colors.black87,
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(
                          stockDisplay[0].itemName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                              "Barcode",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "Barocde"),
                        DataColumn(
                            label: Text(
                              "Color",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "Color"),
                        DataColumn(
                            label: Text(
                              "Size",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "Size"),
                        DataColumn(
                            label: Text(
                              "Stock",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "Stock"),
                        DataColumn(
                            label: Text(
                              "Location",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "Location"),
                        DataColumn(
                            label: Text(
                              "Prize",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            numeric: false,
                            onSort: (i, b) {},
                            tooltip: "First Data"),
                      ], rows: bodyData()),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
