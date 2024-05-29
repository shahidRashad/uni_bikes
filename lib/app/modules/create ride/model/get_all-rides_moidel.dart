// To parse this JSON data, do
//
//     final getAllRidesModel = getAllRidesModelFromJson(jsonString);

import 'dart:convert';

GetAllRidesModel getAllRidesModelFromJson(String str) =>
    GetAllRidesModel.fromJson(json.decode(str));

String getAllRidesModelToJson(GetAllRidesModel data) =>
    json.encode(data.toJson());

class GetAllRidesModel {
  List<Ride>? rides;

  GetAllRidesModel({
    this.rides,
  });

  factory GetAllRidesModel.fromJson(Map<String, dynamic> json) =>
      GetAllRidesModel(
        rides: json["rides"] == null
            ? []
            : List<Ride>.from(json["rides"].map((x) => Ride.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rides": List<dynamic>.from(rides!.map((x) => x.toJson())),
      };
}

class Ride {
  String id;
  String? startPoint;
  String? endPoint;
  String? startTime;
  String? genderPreference;
  String? vehicleType;
  int? phoneNumber;
  UserId? userId;
  List<String> showIntrests;
  int v;

  Ride({
    required this.id,
    required this.startPoint,
    required this.endPoint,
    required this.startTime,
    required this.genderPreference,
    required this.vehicleType,
    required this.phoneNumber,
    this.userId,
    required this.showIntrests,
    required this.v,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json["_id"],
        startPoint: json["startPoint"],
        endPoint: json["endPoint"],
        startTime: json["startTime"],
        genderPreference: json["genderPreference"],
        vehicleType: json["vehicleType"],
        phoneNumber: json["phoneNumber"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        showIntrests: List<String>.from(json["showIntrests"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "startPoint": startPoint,
        "endPoint": endPoint,
        "startTime": startTime,
        "genderPreference": genderPreference,
        "vehicleType": vehicleType,
        "phoneNumber": phoneNumber,
        "userId": userId?.toJson(),
        "showIntrests": List<dynamic>.from(showIntrests.map((x) => x)),
        "__v": v,
      };
}



class UserId {
  String id;
  int mobileNumber;
  String profilePicture;
  String fullName;
  String gender;
  String hostelName;
  String departMent;
  bool isRegistered;
  String collegeId;
  int v;

  UserId({
    required this.id,
    required this.mobileNumber,
    required this.profilePicture,
    required this.fullName,
    required this.gender,
    required this.hostelName,
    required this.departMent,
    required this.isRegistered,
    required this.collegeId,
    required this.v,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        mobileNumber: json["mobileNumber"],
        profilePicture: json["profilePicture"],
        fullName: json["fullName"],
        gender: json["gender"],
        hostelName: json["hostelName"],
        departMent: json["departMent"],
        isRegistered: json["isRegistered"],
        collegeId: json["collegeId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobileNumber": mobileNumber,
        "profilePicture": profilePicture,
        "fullName": fullName,
        "gender": gender,
        "hostelName": hostelName,
        "departMent": departMent,
        "isRegistered": isRegistered,
        "collegeId": collegeId,
        "__v": v,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
