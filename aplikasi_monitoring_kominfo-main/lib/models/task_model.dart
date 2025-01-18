// To parse this JSON data, do
//
//     final TaskModel = TaskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
    this.id,
    this.programId,
    this.name,
    this.host,
    this.date,
    this.location,
    this.time,
    this.description,
    this.file,
    this.created_at,
    this.updated_at,
    this.pivot,
  });

  String? id;
  String? programId;
  String? name;
  String? host;
  DateTime? date;
  String? location;
  DateTime? time;
  String? description;
  String? file;
  DateTime? created_at;
  DateTime? updated_at;
  ReportData? pivot;
  // String? progress; // Define this property
  // String? members;  // Define this property


  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json["id"],
      programId: json["program_id"],
      name: json["name"],
      host: json["host"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      location: json["location"],
      time: json["time"] != null ? DateTime.parse(json["date"]+" "+json["time"]) : null,
      description: json["description"],
      file: json["file"] ?? null,
      created_at: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
      updated_at: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
      pivot: json["report"] != null
            ? ReportData.fromJson(json["report"])
            : null,
    );


  Map<String, dynamic> toJson() => {
      "id": id,
      "program_id": programId,
      "name": name,
      "host": host,
      "location": location,
      "date": date != null ? date!.toIso8601String() : null,
      "time": time != null ? time!.toIso8601String() : null,
      "description": description,
      "file": description,
      "created_at": created_at != null ? created_at!.toIso8601String() : null,
      "updated_at": updated_at != null ? updated_at!.toIso8601String() : null,
    };

}

class ReportData {
  ReportData({
    this.id,
    this.taskId,
    this.photo,
    this.description,
    this.longitude,
    this.latitude,
    this.date,
    this.status,
    this.modifiedBy,
    this.comment,
  });

  String? id;
  String? taskId;
  String? photo;
  String? description;
  String? longitude;
  String? latitude;
  DateTime? date;
  String? status;
  String? modifiedBy;
  String? comment;


  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
      id: json["id"],
      taskId: json["task_id"],
      photo: json["photo"],
      description: json["description"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      status: json["status"],
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
      "date": date != null ? date!.toIso8601String() : null,
      "status": status,
      "modified_by": modifiedBy,
      "comment": comment,
    };

}