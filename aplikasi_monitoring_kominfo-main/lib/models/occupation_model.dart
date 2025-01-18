import 'dart:convert';

OccupationModel OccupationModelFromJson(String str) => OccupationModel.fromJson(json.decode(str));

String occupationModelToJson(OccupationModel data) => json.encode(data.toJson());

class OccupationModel {
  OccupationModel({
    this.id,
    this.name,
    this.sectorId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  String? sectorId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OccupationModel.fromJson(Map<String, dynamic> json) => OccupationModel(
        id: json["id"],
        name: json["name"],
        sectorId: json["sector_id"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sector_id": sectorId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
