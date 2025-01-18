import 'dart:convert';
import 'package:Monitoring/models/occupation_model.dart';
import 'package:Monitoring/models/user_model.dart';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    this.id,
    this.photo,
    this.taskId,
    this.description,
    this.longitude,
    this.latitude,
    this.date,
    this.status,
    this.file,
    this.modifiedBy,
    this.comment,
  });

  String? id;
  String? photo;
  String? taskId;
  String? description;
  double? longitude;
  double? latitude;
  String? date;
  String? status;
  String? file;
  String? modifiedBy;
  String? comment;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json["id"],
        taskId: json["task_id"],
        photo: json["photo"],
        description: json["description"],
        longitude: json["longitude"] != null
            ? double.tryParse(json["longitude"].toString())
            : null,
        latitude: json["latitude"] != null
            ? double.tryParse(json["latitude"].toString())
            : null,
        date: json["date"],
        status: json["status"],
        file: json["file"],
        modifiedBy: json["modified_by"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "photo": photo,
        "description": description,
        "longitude": longitude,
        "latitude": latitude,
        "date": date,
        "status": status,
        "file": file,
        "modified_by": modifiedBy,
        "comment": comment,
      };
}
