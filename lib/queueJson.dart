// To parse this JSON data, do
//
//     final queue = queueFromJson(jsonString);

import 'dart:convert';

List<Queue> queueFromJson(String str) => List<Queue>.from(json.decode(str).map((x) => Queue.fromJson(x)));

String queueToJson(List<Queue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Queue {
  Queue({
    this.value,
    this.tokens,
    this.enarName,
    this.itemname,
    this.image,
    this.anName,
    this.itemBarcode,
    this.uom,
    this.cost,
    this.price,
    this.vat,
    this.img,
    this.restMenu,
    this.itemWac,
    this.stock,
    this.parentFlag,
    this.discountStatus,
    this.quantity
  });

  int value;
  dynamic tokens;
  String enarName;
  String itemname;
  dynamic image;
  String anName;
  String itemBarcode;
  dynamic uom;
  double cost;
  int price;
  String vat;
  String img;
  String restMenu;
  double itemWac;
  var stock;
  String parentFlag;
  int discountStatus;
  int quantity;

  factory Queue.fromJson(Map<String, dynamic> json)=> Queue(
        value: json["value"],
        tokens: json["tokens"],
        enarName: json["enar_name"],
        itemname: json["itemname"],
        image: json["image"],
        anName: json["an_name"],
        itemBarcode: json["item_barcode"],
        uom: json["uom"],
        cost: json["cost"].toDouble(),
        price: json["price"],
        vat: json["vat"],
        img: json["img"],
        restMenu: json["Rest_Menu"],
        itemWac: json["item_wac"].toDouble(),
        stock: json["stock"],
        parentFlag: json["parent_flag"],
        discountStatus: json["discount_status"],
        quantity: 1
    );

    Map<String, dynamic> toJson() => {
      "value": value,
      "tokens": tokens,
      "enar_name": enarName,
      "itemname": itemname,
      "image": image,
      "an_name": anName,
      "item_barcode": itemBarcode,
      "uom": uom,
      "cost": cost,
      "price": price,
      "vat": vat,
      "img": img,
      "Rest_Menu": restMenu,
      "item_wac": itemWac,
      "stock": stock,
      "parent_flag": parentFlag,
      "discount_status": discountStatus,
      "quantity": quantity
    };
  }

