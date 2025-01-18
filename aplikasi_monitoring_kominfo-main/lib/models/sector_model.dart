import 'dart:convert';

SectorModel sectorModelFromJson(String str) =>
    SectorModel.fromJson(json.decode(str));

String sectorModelToJson(SectorModel data) => json.encode(data.toJson());

class SectorModel {
  SectorModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  Supervisor? users;

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        // users: Supervisor.fromJson(json["users"]),
        users: json["user"] != null
            ? Supervisor.fromJson(json["user"])
            : null,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user": users!.toJson(),
      };
}

class Supervisor {
  Supervisor({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
