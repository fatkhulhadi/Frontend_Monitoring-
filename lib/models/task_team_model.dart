import 'dart:convert';
import 'package:Monitoring/models/occupation_model.dart';
import 'package:Monitoring/models/user_model.dart';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    this.user,
    this.role,
  });

  UserModel? user;
  String? role;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "user": user != null ? user?.toJson() : null,
        "role": role,
      };
      
}
