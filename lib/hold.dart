// To parse this JSON data, do
//
//     final jsonData = jsonDataFromJson(jsonString);

import 'dart:convert';

JsonData jsonDataFromJson(String str) => JsonData.fromJson(json.decode(str));

String jsonDataToJson(JsonData data) => json.encode(data.toJson());

class JsonData {
  JsonData({
    this.mytable,
    this.requestfrom,
    this.hold,
  });

  List<Mytable> mytable;
  String requestfrom;
  String hold;

  factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
    mytable: List<Mytable>.from(json["mytable"].map((x) => Mytable.fromJson(x))),
    requestfrom: json["requestfrom"],
    hold: json["hold"],
  );

  Map<String, dynamic> toJson() => {
    "mytable": List<dynamic>.from(mytable.map((x) => x.toJson())),
    "requestfrom": requestfrom,
    "hold": hold,
  };
}

class Mytable {
  Mytable({
    this.invoicehead,
    this.invoicedetails,
    this.appointmentdetails,
    this.invoicepayment,
    this.exchangeCurrency,
  });

  List<Invoicehead> invoicehead;
  List<Invoicedetail> invoicedetails;
  List<dynamic> appointmentdetails;
  List<Invoicepayment> invoicepayment;
  List<dynamic> exchangeCurrency;

  factory Mytable.fromJson(Map<String, dynamic> json) => Mytable(
    invoicehead: List<Invoicehead>.from(json["invoicehead"].map((x) => Invoicehead.fromJson(x))),
    invoicedetails: List<Invoicedetail>.from(json["invoicedetails"].map((x) => Invoicedetail.fromJson(x))),
    appointmentdetails: List<dynamic>.from(json["appointmentdetails"].map((x) => x)),
    invoicepayment: List<Invoicepayment>.from(json["invoicepayment"].map((x) => Invoicepayment.fromJson(x))),
    exchangeCurrency: List<dynamic>.from(json["exchange_currency"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "invoicehead": List<dynamic>.from(invoicehead.map((x) => x.toJson())),
    "invoicedetails": List<dynamic>.from(invoicedetails.map((x) => x.toJson())),
    "appointmentdetails": List<dynamic>.from(appointmentdetails.map((x) => x)),
    "invoicepayment": List<dynamic>.from(invoicepayment.map((x) => x.toJson())),
    "exchange_currency": List<dynamic>.from(exchangeCurrency.map((x) => x)),
  };
}

class Invoicedetail {
  Invoicedetail({
    this.invoiceItemCode,
    this.invoiceItemDiscription,
    this.invoiceItemQty,
    this.invoiceItemPrice,
    this.currentStatus,
    this.itemSize,
    this.kitchenStatus,
    this.alert,
    this.addons,
    this.addonCode,
    this.invoiceItemGross,
    this.invoiceItemDisount,
    this.invoiceItemNett,
    this.invoiceItemWac,
    this.salePersonId,
    this.invoicedetailAddons,
    this.printFlag,
    this.invoiceItemVat,
    this.invoiceItemVatPer,
    this.deliveryDate,
    this.stichingCharge,
    this.discountType,
    this.netDiscountValue,
    this.itemParentFlag,
    this.vouchercode,
    this.bookingStatus,
    this.totalPrice,
    this.itemCost,
    this.unitpriceExvat,
    this.itemUom,
  });

  String invoiceItemCode;
  String invoiceItemDiscription;
  String invoiceItemQty;
  String invoiceItemPrice;
  String currentStatus;
  String itemSize;
  String kitchenStatus;
  String alert;
  String addons;
  String addonCode;
  String invoiceItemGross;
  String invoiceItemDisount;
  String invoiceItemNett;
  String invoiceItemWac;
  String salePersonId;
  String invoicedetailAddons;
  String printFlag;
  String invoiceItemVat;
  String invoiceItemVatPer;
  String deliveryDate;
  String stichingCharge;
  String discountType;
  String netDiscountValue;
  String itemParentFlag;
  String vouchercode;
  String bookingStatus;
  String totalPrice;
  String itemCost;
  String unitpriceExvat;
  String itemUom;

  factory Invoicedetail.fromJson(Map<String, dynamic> json) => Invoicedetail(
    invoiceItemCode: json["Invoice_Item_code"],
    invoiceItemDiscription: json["Invoice_Item_discription"],
    invoiceItemQty: json["Invoice_item_qty"],
    invoiceItemPrice: json["Invoice_Item_price"],
    currentStatus: json["Current_status"],
    itemSize: json["item_size"],
    kitchenStatus: json["kitchen_status"],
    alert: json["Alert"],
    addons: json["Addons"],
    addonCode: json["addon_code"],
    invoiceItemGross: json["Invoice_Item_gross"],
    invoiceItemDisount: json["Invoice_Item_disount"],
    invoiceItemNett: json["Invoice_Item_nett"],
    invoiceItemWac: json["Invoice_item_wac"],
    salePersonId: json["Sale_person_id"],
    invoicedetailAddons: json["addons"],
    printFlag: json["print_flag"],
    invoiceItemVat: json["invoice_item_vat"],
    invoiceItemVatPer: json["invoice_item_vat_PER"],
    deliveryDate: json["delivery_date"],
    stichingCharge: json["stiching_charge"],
    discountType: json["discount_type"],
    netDiscountValue: json["net_discount_value"],
    itemParentFlag: json["item_parent_flag"],
    vouchercode: json["vouchercode"],
    bookingStatus: json["booking_status"],
    totalPrice: json["TotalPrice"],
    itemCost: json["item_cost"],
    unitpriceExvat: json["unitpriceExvat"],
    itemUom: json["item_uom"],
  );

  Map<String, dynamic> toJson() => {
    "Invoice_Item_code": invoiceItemCode,
    "Invoice_Item_discription": invoiceItemDiscription,
    "Invoice_item_qty": invoiceItemQty,
    "Invoice_Item_price": invoiceItemPrice,
    "Current_status": currentStatus,
    "item_size": itemSize,
    "kitchen_status": kitchenStatus,
    "Alert": alert,
    "Addons": addons,
    "addon_code": addonCode,
    "Invoice_Item_gross": invoiceItemGross,
    "Invoice_Item_disount": invoiceItemDisount,
    "Invoice_Item_nett": invoiceItemNett,
    "Invoice_item_wac": invoiceItemWac,
    "Sale_person_id": salePersonId,
    "addons": invoicedetailAddons,
    "print_flag": printFlag,
    "invoice_item_vat": invoiceItemVat,
    "invoice_item_vat_PER": invoiceItemVatPer,
    "delivery_date": deliveryDate,
    "stiching_charge": stichingCharge,
    "discount_type": discountType,
    "net_discount_value": netDiscountValue,
    "item_parent_flag": itemParentFlag,
    "vouchercode": vouchercode,
    "booking_status": bookingStatus,
    "TotalPrice": totalPrice,
    "item_cost": itemCost,
    "unitpriceExvat": unitpriceExvat,
    "item_uom": itemUom,
  };
}

class Invoicehead {
  Invoicehead({
    this.invoiceCreatedUser,
    this.invoiceCreatedDt,
    this.invoiceLocation,
    this.deviceId,
    this.restDelType,
    this.restTableNo,
    this.orderTime,
    this.invoiceCustId,
    this.custName,
    this.custMob,
    this.custMob2,
    this.custAdd,
    this.saletype,
    this.saleInvoiceno,
    this.salePersonPaidValue,
    this.discountType,
    this.netDiscountValue,
    this.roundoff,
    this.manualRoundoff,
    this.remarks,
    this.deliveryType,
    this.discountRemarks,
    this.discountBy,
    this.addons,
    this.noOfPacks,
    this.invoiceTillId,
    this.invoiceBusinessDt,
    this.deliveryArea,
    this.entryTime,
    this.orderNo,
    this.invoiceGross,
    this.invoiceDiscount,
    this.invoiceNett,
    this.invoiceVat,
    this.invoiceSalePerson,
    this.invoiceCurrency,
    this.lastupdationBy,
  });

  String invoiceCreatedUser;
  DateTime invoiceCreatedDt;
  String invoiceLocation;
  String deviceId;
  String restDelType;
  String restTableNo;
  DateTime orderTime;
  String invoiceCustId;
  String custName;
  String custMob;
  String custMob2;
  String custAdd;
  String saletype;
  String saleInvoiceno;
  String salePersonPaidValue;
  String discountType;
  String netDiscountValue;
  String roundoff;
  String manualRoundoff;
  String remarks;
  String deliveryType;
  String discountRemarks;
  String discountBy;
  String addons;
  String noOfPacks;
  String invoiceTillId;
  DateTime invoiceBusinessDt;
  String deliveryArea;
  DateTime entryTime;
  String orderNo;
  String invoiceGross;
  String invoiceDiscount;
  String invoiceNett;
  String invoiceVat;
  String invoiceSalePerson;
  String invoiceCurrency;
  String lastupdationBy;

  factory Invoicehead.fromJson(Map<String, dynamic> json) => Invoicehead(
    invoiceCreatedUser: json["Invoice_created_user"],
    invoiceCreatedDt: DateTime.parse(json["Invoice_created_dt"]),
    invoiceLocation: json["Invoice_Location"],
    deviceId: json["device_id"],
    restDelType: json["Rest_del_type"],
    restTableNo: json["Rest_Table_no"],
    orderTime: DateTime.parse(json["order_time"]),
    invoiceCustId: json["Invoice_Cust_id"],
    custName: json["cust_name"],
    custMob: json["cust_mob"],
    custMob2: json["cust_mob2"],
    custAdd: json["cust_add"],
    saletype: json["saletype"],
    saleInvoiceno: json["sale_invoiceno"],
    salePersonPaidValue: json["Sale_person_paid_value"],
    discountType: json["discount_type"],
    netDiscountValue: json["net_discount_value"],
    roundoff: json["roundoff"],
    manualRoundoff: json["manual_roundoff"],
    remarks: json["Remarks"],
    deliveryType: json["delivery_type"],
    discountRemarks: json["Discount_Remarks"],
    discountBy: json["Discount_By"],
    addons: json["Addons"],
    noOfPacks: json["No_Of_Packs"],
    invoiceTillId: json["Invoice_till_id"],
    invoiceBusinessDt: DateTime.parse(json["Invoice_business_dt"]),
    deliveryArea: json["Delivery_Area"],
    entryTime: DateTime.parse(json["Entry_Time"]),
    orderNo: json["order_no"],
    invoiceGross: json["Invoice_gross"],
    invoiceDiscount: json["Invoice_discount"],
    invoiceNett: json["Invoice_nett"],
    invoiceVat: json["invoice_vat"],
    invoiceSalePerson: json["Invoice_sale_person"],
    invoiceCurrency: json["Invoice_currency"],
    lastupdationBy: json["lastupdation_by"],
  );

  Map<String, dynamic> toJson() => {
    "Invoice_created_user": invoiceCreatedUser,
    "Invoice_created_dt": "${invoiceCreatedDt.year.toString().padLeft(4, '0')}-${invoiceCreatedDt.month.toString().padLeft(2, '0')}-${invoiceCreatedDt.day.toString().padLeft(2, '0')}",
    "Invoice_Location": invoiceLocation,
    "device_id": deviceId,
    "Rest_del_type": restDelType,
    "Rest_Table_no": restTableNo,
    "order_time": orderTime.toIso8601String(),
    "Invoice_Cust_id": invoiceCustId,
    "cust_name": custName,
    "cust_mob": custMob,
    "cust_mob2": custMob2,
    "cust_add": custAdd,
    "saletype": saletype,
    "sale_invoiceno": saleInvoiceno,
    "Sale_person_paid_value": salePersonPaidValue,
    "discount_type": discountType,
    "net_discount_value": netDiscountValue,
    "roundoff": roundoff,
    "manual_roundoff": manualRoundoff,
    "Remarks": remarks,
    "delivery_type": deliveryType,
    "Discount_Remarks": discountRemarks,
    "Discount_By": discountBy,
    "Addons": addons,
    "No_Of_Packs": noOfPacks,
    "Invoice_till_id": invoiceTillId,
    "Invoice_business_dt": invoiceBusinessDt.toIso8601String(),
    "Delivery_Area": deliveryArea,
    "Entry_Time": entryTime.toIso8601String(),
    "order_no": orderNo,
    "Invoice_gross": invoiceGross,
    "Invoice_discount": invoiceDiscount,
    "Invoice_nett": invoiceNett,
    "invoice_vat": invoiceVat,
    "Invoice_sale_person": invoiceSalePerson,
    "Invoice_currency": invoiceCurrency,
    "lastupdation_by": lastupdationBy,
  };
}

class Invoicepayment {
  Invoicepayment({
    this.payType,
    this.payValue,
    this.payCardCheqVoNo,
    this.payCardType,
    this.payTillId,
    this.payRegisterId,
    this.payBusinessDt,
    this.payInvValue,
    this.payCustId,
    this.financeStatus,
    this.paidAmount,
    this.balanceAmount,
    this.splitOrd,
    this.deliveryType,
    this.location,
  });

  String payType;
  double payValue;
  String payCardCheqVoNo;
  String payCardType;
  String payTillId;
  String payRegisterId;
  DateTime payBusinessDt;
  String payInvValue;
  String payCustId;
  String financeStatus;
  String paidAmount;
  String balanceAmount;
  String splitOrd;
  String deliveryType;
  String location;

  factory Invoicepayment.fromJson(Map<String, dynamic> json) => Invoicepayment(
    payType: json["Pay_type"],
    payValue: json["Pay_value"].toDouble(),
    payCardCheqVoNo: json["Pay_card_cheq_vo_no"],
    payCardType: json["Pay_card_type"],
    payTillId: json["Pay_till_id"],
    payRegisterId: json["Pay_Register_id"],
    payBusinessDt: DateTime.parse(json["Pay_business_dt"]),
    payInvValue: json["Pay_inv_value"],
    payCustId: json["Pay_cust_id"],
    financeStatus: json["Finance_status"],
    paidAmount: json["Paid_amount"],
    balanceAmount: json["Balance_amount"],
    splitOrd: json["Split_ord"],
    deliveryType: json["Delivery_type"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "Pay_type": payType,
    "Pay_value": payValue,
    "Pay_card_cheq_vo_no": payCardCheqVoNo,
    "Pay_card_type": payCardType,
    "Pay_till_id": payTillId,
    "Pay_Register_id": payRegisterId,
    "Pay_business_dt": payBusinessDt.toIso8601String(),
    "Pay_inv_value": payInvValue,
    "Pay_cust_id": payCustId,
    "Finance_status": financeStatus,
    "Paid_amount": paidAmount,
    "Balance_amount": balanceAmount,
    "Split_ord": splitOrd,
    "Delivery_type": deliveryType,
    "location": location,
  };
}
