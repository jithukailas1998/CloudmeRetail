// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);

import 'dart:convert';

Stock stockFromJson(String str) => Stock.fromJson(json.decode(str));

String stockToJson(Stock data) => json.encode(data.toJson());

class Stock {
  Stock({
    this.type,
    this.normal,
    this.variant,
    this.message,
    this.supplierItemCode,
    this.itemName,
  });

  String type;
  NormalClass normal;
  List<Variant> variant;
  String message;
  String supplierItemCode;
  String itemName;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    type: json["type"],
    normal: json['normal'] == null ?json['normal'] :NormalClass.fromJson(json["normal"]),
    variant: json['variant'] == null ?json['variant'] : List<Variant>.from(json["variant"].map((x) => Variant.fromJson(x))),
    message: json["message"],
    supplierItemCode: json["supplier_item_code"],
    itemName: json["item_name"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "normal":  normal.toJson(),
    "variant": List<dynamic>.from(variant.map((x) => x.toJson())),
    "message": message,
    "supplier_item_code": supplierItemCode,
    "item_name": itemName,
  };
}

class Variant {
  Variant({
    this.itemCode,
    this.itemBarcode,
    this.itemName,
    this.itemColour,
    this.itemSize,
    this.stockOnHand,
    this.retlPrice,
    this.itprBranCode,
    this.loccode,
    this.locationName,
    this.supplierItemCode,
    this.sizeName,
    this.colourName,
    this.itemUom,
  });

  int itemCode;
  String itemBarcode;
  String itemName;
  String itemColour;
  String itemSize;
  int stockOnHand;
  int retlPrice;
  String itprBranCode;
  int loccode;
  String locationName;
  String supplierItemCode;
  String sizeName;
  String colourName;
  dynamic itemUom;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    itemCode: json["Item_code"],
    itemBarcode: json["Item_barcode"],
    itemName: json["item_name"],
    itemColour: json["item_colour"],
    itemSize: json["item_size"],
    stockOnHand: json["stock_on_hand"],
    retlPrice: json["retl_price"],
    itprBranCode: json["ITPR_BRAN_CODE"],
    loccode: int.parse(json["LOCCODE"]),
    locationName: json["location_name"],
    supplierItemCode: json["supplier_item_code"],
    sizeName: json["size_name"],
    colourName: json["colour_name"],
    itemUom: json["Item_uom"],
  );

  Map<String, dynamic> toJson() => {
    "Item_code": itemCode,
    "Item_barcode": itemBarcode,
    "item_name": itemName,
    "item_colour": itemColour,
    "item_size": itemSize,
    "stock_on_hand": stockOnHand,
    "retl_price": retlPrice,
    "ITPR_BRAN_CODE": itprBranCode,
    "LOCCODE": loccode.toString(),
    "location_name": locationName,
    "supplier_item_code": supplierItemCode,
    "size_name": sizeName,
    "colour_name": colourName,
    "Item_uom": itemUom,
  };
}
class NormalClass {
  NormalClass({
    this.itemCode,
    this.itemName,
    this.itemBarcode,
    this.itemUom,
    this.prices,
    this.variantItemsParent,
  });

  int itemCode;
  String itemName;
  String itemBarcode;
  String itemUom;
  List<Price> prices;
  dynamic variantItemsParent;

  factory NormalClass.fromJson(Map<String, dynamic> json) => NormalClass(
    itemCode: json["Item_code"],
    itemName: json["item_name"],
    itemBarcode: json["Item_barcode"],
    itemUom: json["Item_uom"],
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
    variantItemsParent: json["variant_items_parent"],
  );

  Map<String, dynamic> toJson() => {
    "Item_code": itemCode,
    "item_name": itemName,
    "Item_barcode": itemBarcode,
    "Item_uom": itemUom,
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
    "variant_items_parent": variantItemsParent,
  };
}

class Price {
  Price({
    this.itprItemCode,
    this.stockOnHand,
    this.retlPrice,
    this.itprBranCode,
    this.location,
  });

  int itprItemCode;
  double stockOnHand;
  int retlPrice;
  String itprBranCode;
  LocationStock location;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    itprItemCode: json["ITPR_ITEM_CODE"],
    stockOnHand: json["stock_on_hand"].toDouble(),
    retlPrice: json["retl_price"],
    itprBranCode: json["ITPR_BRAN_CODE"],
    location: LocationStock.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "ITPR_ITEM_CODE": itprItemCode,
    "stock_on_hand": stockOnHand,
    "retl_price": retlPrice,
    "ITPR_BRAN_CODE": itprBranCode,
    "location": location.toJson(),
  };
}

class LocationStock {
  LocationStock({
    this.loccode,
    this.locationName,
    this.currency,
  });

  String loccode;
  String locationName;
  String currency;

  factory LocationStock.fromJson(Map<String, dynamic> json) => LocationStock(
    loccode: json["LOCCODE"],
    locationName: json["location_name"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "LOCCODE": loccode,
    "location_name": locationName,
    "currency": currency,
  };
}
