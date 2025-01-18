// import 'dart:convert';
// import 'dart:io';
// import 'package:Monitoring/constants/constants.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:Monitoring/models/report_model.dart';

// class ReportController extends GetxController {
//   Rx<List<ReportModel>> report = Rx<List<ReportModel>>([]);
//   final isLoading = false.obs;
//   final box = GetStorage();

//   // @override
//   // void onInit() {
//   //   super.onInit();
//   // }

//   Future getReport(String id) async {
//     try {
//       report.value.clear();
//       isLoading.value = true;
//       var response = await http.get(Uri.parse('${url}report/$id'), headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${box.read('token')}',
//       });
//       if (response.statusCode == 200) {
//         isLoading.value = false;
//         final content = json.decode(response.body)['report'];
//         print(content);
//         // for (var item in content) {
//           report.value.add(ReportModel.fromJson(content));
//         // }
//       } else {
//         isLoading.value = false;
//         print('gagal1');
//         print(json.decode(response.body));
//       }
//     } catch (e) {
//       isLoading.value = false;
//       print('gagal2');
//       print(e.toString());
//     }
//   }

//   Future<void> createReport(
//   taskId,
//   description,
//   longitude,
//   latitude,
//   uploadedFilePath1, // File path pertama
//   uploadedFilePath2, // File path kedua
// ) async {
//   try {
//     // Data tanpa file
//     var data = {
//       'task_id': taskId,
//       'description': description,
//       'longitude': longitude,
//       'latitude': latitude,
//     };

//     // Kirim data dengan file
//     var request = http.MultipartRequest('POST', Uri.parse('${url}report/'))
//       ..headers['Authorization'] = 'Bearer ${box.read('token')}';

//     // Tambahkan data ke dalam request
//     data.forEach((key, value) {
//       request.fields[key] = value.toString();
//     });

//     // Tambahkan file pertama jika ada
//     if (uploadedFilePath1 != null && uploadedFilePath1.isNotEmpty) {
//       File file1 = File(uploadedFilePath1);
//       request.files.add(
//         await http.MultipartFile.fromPath('photo', file1.path),
//       );
//     }

//     // Tambahkan file kedua jika ada
//     if (uploadedFilePath2 != null && uploadedFilePath2.isNotEmpty) {
//       File file2 = File(uploadedFilePath2);
//       request.files.add(
//         await http.MultipartFile.fromPath('documents', file2.path),
//       );
//     }

//     // Kirim request
//     var response = await request.send();

//     // Ambil body response
//     String responseBody = await response.stream.bytesToString();

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       print('Data dan file berhasil dikirim.');
//       print('Response: $responseBody');
//     } else {
//       print('Gagal mengirim: ${response.statusCode}');
//       print('Response: $responseBody');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// }
