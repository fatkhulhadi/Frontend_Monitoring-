import 'dart:convert';
import 'dart:io';
import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/models/report_model.dart';

// Create a separate service class for report-related API calls

class ReportController extends GetxController {
  Rx<List<ReportModel>> report = Rx<List<ReportModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  Future<void> createReport({
    required String taskId,
    required String description,
    required double longitude,
    required double latitude,
    String? uploadedFilePath1,
    String? uploadedFilePath2,
  }) async {
    try {
      // Data tanpa file
      var data = {
        'task_id': taskId,
        'description': description,
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
      };

      // Kirim data dengan file
      var request = http.MultipartRequest('POST', Uri.parse('${url}report/'))
        ..headers['Authorization'] = 'Bearer ${box.read('token')}';

      // Tambahkan data ke dalam request
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Tambahkan file pertama jika ada
      if (uploadedFilePath1 != null && uploadedFilePath1.isNotEmpty) {
        File file1 = File(uploadedFilePath1);
        request.files.add(
          await http.MultipartFile.fromPath('photo', file1.path),
        );
      }

      // Tambahkan file kedua jika ada
      if (uploadedFilePath2 != null && uploadedFilePath2.isNotEmpty) {
        File file2 = File(uploadedFilePath2);
        request.files.add(
          await http.MultipartFile.fromPath('documents', file2.path),
        );
      }

      // Kirim request
      var response = await request.send();

      // Ambil body response
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Data dan file berhasil dikirim.');
        print('Response: $responseBody');
      } else {
        print('Gagal mengirim: ${response.statusCode}');
        print('Response: $responseBody');
        throw Exception('Failed to create report');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> getReport(String taskId) async {
    try {
      isLoading.value = true;
      var fetchedReports = await ReportService.getReportByTaskId(taskId);
      report.value = fetchedReports;
    } catch (e) {
      print('Error fetching reports: $e');
      report.value = []; // Ensure the list is cleared on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateReportComment(String taskId, String comment) async {
    try {
      await ReportService.updateReportComment(taskId, comment);
      // Refresh the report after updating
      await getReport(taskId);
    } catch (e) {
      print('Error updating report comment: $e');
      rethrow;
    }
  }
}
class ReportService {
  static Future<List<ReportModel>> getReportByTaskId(String taskId) async {
    final box = GetStorage();
    try {
      final response = await http.get(
        Uri.parse('${url}report/?task_id=$taskId'),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<ReportModel> reports = body
            .map((dynamic item) => ReportModel.fromJson(item))
            .toList();
        return reports;
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      print('Error in getReportByTaskId: $e');
      rethrow;
    }
  }

  static Future<void> updateReportComment(String taskId, String comment) async {
    final box = GetStorage();
    try {
      final response = await http.patch(
        Uri.parse('${url}report/$taskId/'),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update report comment');
      }
    } catch (e) {
      print('Error in updateReportComment: $e');
      rethrow;
    }
  }
}