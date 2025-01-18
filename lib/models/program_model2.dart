// To parse this JSON data, do
//
//     final programModel2 = programModel2FromJson(jsonString);

import 'dart:convert';
import 'sector_model.dart';
import 'team_model.dart';

ProgramModel2 programModel2FromJson(String str) =>
    ProgramModel2.fromJson(json.decode(str));

String programModel2ToJson(ProgramModel2 data) => json.encode(data.toJson());

class ProgramModel2 {
  ProgramModel2({
    this.id,
    this.sector,
    this.name,
    this.startDate,
    this.endDate,
    this.completedTasks,
    this.totalTasks,
    this.description,
    this.coordinator,
    // this.sector,
  });

  String? id;
  SectorModel? sector;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  int? completedTasks;
  int? totalTasks;
  String? description;
  // String? coordinator;
  TeamModel? coordinator;
  // SectorModel? sector;

  factory ProgramModel2.fromJson(Map<String, dynamic> json) => ProgramModel2(
        id: json["id"],
        sector: json["sector"] != null
            ? SectorModel.fromJson(json["sector"])
            : null,
        name: json["name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        completedTasks: json["completed_tasks"],
        totalTasks: json["total_tasks"],
        description: json["description"],
        // coordinator: json["coordinator"],
        coordinator: json["coordinator"] != null
            ? TeamModel.fromJson(json["coordinator"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sector": sector,
        "name": name,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "completed_tasks": completedTasks,
        "total_tasks": totalTasks,
        "description": description,
        // "coordinator": coordinator != null ? coordinator : null,
        "coordinator": coordinator != null ? coordinator?.toJson() : null,
      };
}
