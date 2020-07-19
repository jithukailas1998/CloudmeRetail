import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cloudmeretail/filter.dart';
import 'package:cloudmeretail/queueJson.dart';
import 'package:cloudmeretail/stockjson.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loginData(String email, String pass) async {
  Map<String, dynamic> body = {"email": "$email", "password": "$pass"};
  String myurl = "https://dev.cloudmesoft.com/api/login";
  final res = await http.post(myurl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(body));

  print(res.body);
  Map<String, dynamic> conData = jsonDecode(res.body);
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.setString('token', conData);
  print(conData);
  if (conData.containsKey('success')) {
    if (conData['success'] != null) {
      // ignore: non_constant_identifier_names
      String Token = conData['success']["token"];
      // ignore: non_constant_identifier_names
      String Location = conData['success']["location_code"];
      String compName = conData['success']['company_details']['Company_name'];
      int userId = conData['success']['user_details']['userid'];
      String compNo = conData['success']['company_details']['Tel_no'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('locat', Location);
      prefs.setString('token', Token);
      prefs.setString('cName', compName);
      prefs.setString('cNo', compNo);
      prefs.setInt('uName', userId);
      print("Token = $compNo");
      print("Location = $Location");
    }
    return true;
  }
  return false;
}

Future<Stock> getData(String itemCode) async {
  Map<String, dynamic> body = {
    "item_code": "$itemCode",
  };
  String myurl = "https://dev.cloudmesoft.com/api/get-item-stock-single-array";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  prefs.setString('codeItem', itemCode);
  final res = await http.post(myurl,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }, //eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImU4OWY1ZTZhN2EwN2VjYTFlZjUxYTAwODM0MGUyOTkxNDRlMzA1NTFhZGM4ZjgzYzcwN2RlZTk4NDczYjYyM2M2MDgyOTQyYTEzMmU0OGYwIn0.eyJhdWQiOiIxIiwianRpIjoiZTg5ZjVlNmE3YTA3ZWNhMWVmNTFhMDA4MzQwZTI5OTE0NGUzMDU1MWFkYzhmODNjNzA3ZGVlOTg0NzNiNjIzYzYwODI5NDJhMTMyZTQ4ZjAiLCJpYXQiOjE1OTE4NzU0OTEsIm5iZiI6MTU5MTg3NTQ5MSwiZXhwIjoxNjIzNDExNDkxLCJzdWIiOiI0MTM4NSIsInNjb3BlcyI6W119.Hib7GwH_biX1mCuBc2y8p5mLz1HU6G18bv2EN1504hs3xHDBCRVlYY956VL5HD-XKqV8orl1Jm_13Qqokhklvbxj7wtWpSZpiMztw8kQZ19yCl_datsuFy9FRnbmlaL-I-tvJxssZ_YTqFd-iKpbBAEQ5RuoLzrmp5O49PTWP6Sg31Ex70EfXiRO2482Q_p67O9yxMZhNT1vLUBidjhkxqEftnRyEiPq-uTCF0jpurVRERKNnfCcIUOshL-qpw-ixhk3WLs7Rw56P2pzIhu9M2vw0-YfGCAMu8XvEQJQLx-h_zPRAuTQi_TIjF1CIu-hYNBQYe4uiZTeqBxefHlCZrdArXVkyIOdDnE8Xdggen8MG2Xz_cGQeSjXwFr31NwxeQ9rEYvhtUGd2kIcq3WEMFDzs2LgzPnsQLFp4oRLvQmGSXhPfC3lui9OoPCut7odBsGWVDjlDAVGpJQ_6H0AJn39u76BWblo1p12XJ9IuVaMFJzsTdj3aEz_AP7WoZliVNKgNVg8fkEJs4XLfKvlhTFg54jQXaUsegZ-VUqfjNgVzRSBnxYwHi-asIa_W8ThRBcA1fkwk5bKuc993Cnln2b0UthaNKzpc1gDgY8YaXFt3O-Cm79J6iBMNWRvNoAGqPYHfL83BkVTwa4gx5gqKY0xJ4WYjwiEM-PuuRhovVs,
      body: body);
  print("http response" + res.body);
  Map<String, dynamic> conData = jsonDecode(res.body);
  String sup = conData['supplier_item_code'];
  print("Codeeeeee $sup");
  prefs.setString('supplier_code', sup);
  Stock returnData = Stock.fromJson(conData);
  print("Data= $returnData");
  return returnData;
}

Future<Filter> getItem() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var supId = prefs.getString('supplier_code');
  var token = prefs.getString('token');
  //var code = prefs.getString('supplier_code');

  //print("code"+supId);
  //print("SupID="+supId);
  Map<String, dynamic> body = {
    "supplier_item_code": "$supId",
  };
  //print("Item"+id);
  String myurl = "https://apps.cloudmesoft.com/api/size-color-masters";
  final res = await http.post(myurl,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }, //eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImU4OWY1ZTZhN2EwN2VjYTFlZjUxYTAwODM0MGUyOTkxNDRlMzA1NTFhZGM4ZjgzYzcwN2RlZTk4NDczYjYyM2M2MDgyOTQyYTEzMmU0OGYwIn0.eyJhdWQiOiIxIiwianRpIjoiZTg5ZjVlNmE3YTA3ZWNhMWVmNTFhMDA4MzQwZTI5OTE0NGUzMDU1MWFkYzhmODNjNzA3ZGVlOTg0NzNiNjIzYzYwODI5NDJhMTMyZTQ4ZjAiLCJpYXQiOjE1OTE4NzU0OTEsIm5iZiI6MTU5MTg3NTQ5MSwiZXhwIjoxNjIzNDExNDkxLCJzdWIiOiI0MTM4NSIsInNjb3BlcyI6W119.Hib7GwH_biX1mCuBc2y8p5mLz1HU6G18bv2EN1504hs3xHDBCRVlYY956VL5HD-XKqV8orl1Jm_13Qqokhklvbxj7wtWpSZpiMztw8kQZ19yCl_datsuFy9FRnbmlaL-I-tvJxssZ_YTqFd-iKpbBAEQ5RuoLzrmp5O49PTWP6Sg31Ex70EfXiRO2482Q_p67O9yxMZhNT1vLUBidjhkxqEftnRyEiPq-uTCF0jpurVRERKNnfCcIUOshL-qpw-ixhk3WLs7Rw56P2pzIhu9M2vw0-YfGCAMu8XvEQJQLx-h_zPRAuTQi_TIjF1CIu-hYNBQYe4uiZTeqBxefHlCZrdArXVkyIOdDnE8Xdggen8MG2Xz_cGQeSjXwFr31NwxeQ9rEYvhtUGd2kIcq3WEMFDzs2LgzPnsQLFp4oRLvQmGSXhPfC3lui9OoPCut7odBsGWVDjlDAVGpJQ_6H0AJn39u76BWblo1p12XJ9IuVaMFJzsTdj3aEz_AP7WoZliVNKgNVg8fkEJs4XLfKvlhTFg54jQXaUsegZ-VUqfjNgVzRSBnxYwHi-asIa_W8ThRBcA1fkwk5bKuc993Cnln2b0UthaNKzpc1gDgY8YaXFt3O-Cm79J6iBMNWRvNoAGqPYHfL83BkVTwa4gx5gqKY0xJ4WYjwiEM-PuuRhovVs,
      body: body);
  print("http response" + res.body);
  Map<String, dynamic> conData = jsonDecode(res.body);
  Filter returnData = Filter.fromJson(conData);
  ColourMaster allColor = ColourMaster(colorName: "All", id: -5, x: "All");
  Location allSize = Location(id: -5, name: "All");
  returnData.colourMaster.add(allColor);
  returnData.sizeMaster.add(allSize);

  //print("barcode = $itemCode");
  print("Color= $returnData");
  return returnData;
}

Future<List<dynamic>> queueBuster(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //var supId = prefs.getString('supplier_code');
  var token = prefs.getString('token');
  var locId = prefs.getString('locat');
  Map<String, dynamic> body = {"loccode": "$locId", "code": "$code"};
  //print("Item"+id);
  String myurl = "https://dev.cloudmesoft.com/api/get_item_detail";

  final res = await http.post(myurl,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}, body: body);
  print("http response" + res.body);
  List<Queue> conData =
      (json.decode(res.body) as List).map((i) => Queue.fromJson(i)).toList();
  // List<dynamic> conData = jsonDecode(res.body);
  print("Condata[0]=" + "$conData");

  return conData;
}

// ignore: missing_return
Future<List<dynamic>> holdQueue(String date, String time, double total,
    double gross, double vat, double tax, double discount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var locId = prefs.getString('location_id');
  //var supId = prefs.getString('supplier_code');
  var body = jsonEncode({
    "mytable": [
      {
        "invoicehead": [
          {
            "Invoice_created_user": "40071",
            "Invoice_created_dt": date,
            "Invoice_Location": locId,
            "device_id": "160",
            "Rest_del_type": "",
            "Rest_Table_no": "0",
            "order_time": time,
            "Invoice_Cust_id": "1",
            "cust_name": "Cash",
            "cust_mob": "",
            "cust_mob2": "",
            "cust_add": "",
            "saletype": "0",
            "sale_invoiceno": "0",
            "Sale_person_paid_value": "0",
            "discount_type": "0",
            "net_discount_value": "0",
            "roundoff": "0",
            "manual_roundoff": "0",
            "Remarks": "0",
            "delivery_type": "0",
            "Discount_Remarks": "0",
            "Discount_By": "0",
            "Addons": "0",
            "No_Of_Packs": "0",
            "Invoice_till_id": "0",
            "Invoice_business_dt": time,
            "Delivery_Area": "",
            "Entry_Time": time,
            "order_no": "",
            "Invoice_gross": "$gross",
            "Invoice_discount": "$discount",
            "Invoice_nett": "$total",
            "invoice_vat": "$vat",
            "Invoice_sale_person": "",
            "Invoice_currency": "AED",
            "lastupdation_by": ""
          }
        ],
        "invoicedetails": [
          {
            "Invoice_Item_code": "10001",
            "Invoice_Item_discription": "Product 1 A-1233 10001خدمات",
            "Invoice_item_qty": "1",
            "Invoice_Item_price": "39.904761904761905",
            "Current_status": "0",
            "item_size": "0",
            "kitchen_status": "0",
            "Alert": "0",
            "Addons": "0",
            "addon_code": "0",
            "Invoice_Item_gross": "38.095238095238095",
            "Invoice_Item_disount": "",
            "Invoice_Item_nett": "39.904761904761905",
            "Invoice_item_wac": "",
            "Sale_person_id": "0",
            "addons": "0",
            "print_flag": "0",
            "invoice_item_vat": "1.8095238095238095",
            "invoice_item_vat_PER": "5",
            "delivery_date": "",
            "stiching_charge": "",
            "discount_type": "",
            "net_discount_value": "",
            "item_parent_flag": "",
            "vouchercode": "",
            "booking_status": "",
            "TotalPrice": "36.19047619047619",
            "item_cost": "0",
            "unitpriceExvat": "38.095238095238095",
            "item_uom": "0"
          },
          {
            "Invoice_Item_code": "10009",
            "Invoice_Item_discription":
                "heel slipper-LADIES HEEL SLIPPER-864-1-38-TAN 100090",
            "Invoice_item_qty": "1",
            "Invoice_Item_price": "64.8452380952381",
            "Current_status": "0",
            "item_size": "0",
            "kitchen_status": "0",
            "Alert": "0",
            "Addons": "0",
            "addon_code": "0",
            "Invoice_Item_gross": "61.904761904761905",
            "Invoice_Item_disount": "",
            "Invoice_Item_nett": "64.8452380952381",
            "Invoice_item_wac": "",
            "Sale_person_id": "0",
            "addons": "0",
            "print_flag": "0",
            "invoice_item_vat": "2.9404761904761907",
            "invoice_item_vat_PER": "5",
            "delivery_date": "",
            "stiching_charge": "",
            "discount_type": "",
            "net_discount_value": "",
            "item_parent_flag": "",
            "vouchercode": "",
            "booking_status": "",
            "TotalPrice": "58.80952380952381",
            "item_cost": "0",
            "unitpriceExvat": "61.904761904761905",
            "item_uom": "0"
          }
        ],
        "appointmentdetails": [],
        "invoicepayment": [
          {
            "Pay_type": "0",
            "Pay_value": 99.75,
            "Pay_card_cheq_vo_no": "0",
            "Pay_card_type": "0",
            "Pay_till_id": "0",
            "Pay_Register_id": "0",
            "Pay_business_dt": time,
            "Pay_inv_value": "0",
            "Pay_cust_id": "0",
            "Finance_status": "0",
            "Paid_amount": "0",
            "Balance_amount": "0",
            "Split_ord": "0",
            "Delivery_type": "0",
            "location": "0"
          }
        ],
        "exchange_currency": []
      }
    ],
    "requestfrom": "app",
    "hold": "true"
  });
  var token = prefs.getString('token');
  //Map <String,dynamic> body={"loccode": "$locId","code": "$code"};
  //print("Item"+id);
  String myurl = "https://dev.cloudmesoft.com/api/hold-store";

  final res = await http.post(myurl,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}, body: body);
  print("http response" + res.body);
  Map<String, dynamic> conData = jsonDecode(res.body);
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.setString('token', conData);
  String idVal = conData['tran_no'];
  prefs.setString('trans_id', idVal);
  print('Trn id = $idVal');
  print(conData);
  print("Condata[0]=" + "$conData");
}
