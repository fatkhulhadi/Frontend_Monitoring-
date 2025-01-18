import 'dart:convert';
import 'package:Monitoring/models/occupation_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

List<Map<String, dynamic>> convertToIdList(List<UserModel> users) {
    return users.map((user) => user.toIdJson()).toList();
  }

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    // this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.sectorId,
    this.occupationId,
    this.occupation,
  });

  String? id;
  String? name;
  String? email;
  // dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? sectorId;
  String? occupationId;
  OccupationModel? occupation;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        // emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        sectorId: json["sector_id"],
        occupationId: json["occupation_id"],
        occupation: json["occupation"] != null ? OccupationModel.fromJson(json["occupation"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        // "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "sector_id": sectorId,
        "occupation_id": occupationId,
        "occupation": occupation != null ? occupation?.toJson() : null,
      };
      
  Map<String, dynamic> toIdJson() => {
        "id": id,
      };
}
