import 'dart:convert';
import 'package:Monitoring/models/occupation_model.dart';

TeamModel teamModelFromJson(String str) => TeamModel.fromJson(json.decode(str));

String teamModelToJson(TeamModel data) => json.encode(data.toJson());

class TeamModel {
  TeamModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.occupationId,
    this.pivot,
    this.occupation,
  });

  String? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? occupationId;
  Pivot? pivot;
  OccupationModel? occupation;
  

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        occupationId: json["occupation_id"],
        pivot: json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null,
        occupation: json["occupation"] != null ? OccupationModel.fromJson(json["occupation"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "occupation_id": occupationId,
        "pivot": pivot != null ? pivot?.toJson() : null,
        "occupation": occupation != null ? occupation?.toJson() : null,
      };
}

class Pivot {
  Pivot({
    this.programId,
    this.taskId,
    this.userId,
    this.role,
  });

  String? programId;
  String? taskId;
  String? userId;
  String? role;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        programId: json["program_id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "program_id": programId,
        "task_id": taskId,
        "user_id": userId,
        "role": role,
      };
}
