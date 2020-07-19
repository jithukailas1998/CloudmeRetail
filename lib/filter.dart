import 'dart:convert';

Filter filterFromJson(String str) => Filter.fromJson(json.decode(str));

String filterToJson(Filter data) => json.encode(data.toJson());

class Filter {
  Filter({
    this.sizeMaster,
    this.colourMaster,
    this.locations,
  });

  List<Location> sizeMaster;
  List<ColourMaster> colourMaster;
  List<Location> locations;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        sizeMaster: List<Location>.from(
            json["size_master"].map((x) => Location.fromJson(x))),
        colourMaster: List<ColourMaster>.from(
            json["colour_master"].map((x) => ColourMaster.fromJson(x))),
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "size_master": List<dynamic>.from(sizeMaster.map((x) => x.toJson())),
        "colour_master":
            List<dynamic>.from(colourMaster.map((x) => x.toJson())),
        "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
      };
}

class ColourMaster {
  ColourMaster({this.colorName, this.id, this.x});

  String colorName;
  int id;
  String x = "All";

  factory ColourMaster.fromJson(Map<String, dynamic> json) =>
      ColourMaster(colorName: json["color_Name"], id: json["id"], x: json["x"]);

  Map<String, dynamic> toJson() => {"color_Name": colorName, "id": id, "x": x};
}

class Location {
  Location({
    this.name,
    this.id,
  });

  String name;
  int id;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "id": id == null ? null : id,
      };
}

// class Size {
//   Size({
//     this.name,
//     this.id,
//   });

//   String name;
//   int id;

//   factory Size.fromJson(Map<String, dynamic> json) => Size(
//         name: json["name"] == null ? null : json["name"],
//         id: json["id"] == null ? null : json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name == null ? null : name,
//         "id": id == null ? null : id,
//       };
// }
