import 'dart:convert';
import 'dart:io';
import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/models/task_model.dart';
import 'package:Monitoring/models/team_model.dart';
import 'package:file_picker/file_picker.dart';

class TaskController extends GetxController {
  Rx<List<TaskModel>> tasks = Rx<List<TaskModel>>([]);
  Rx<List<TaskModel>> tasks2 = Rx<List<TaskModel>>([]);
  Rx<List<TeamModel>> taskTeam = Rx<List<TeamModel>>([]);
  final isLoading = false.obs;
  final isLoadingTotalTask = false.obs;
  final isLoadingGetTaskById = false.obs;
  final box = GetStorage();
  RxInt totalTask = 0.obs;
  var task = TaskModel().obs;

  // @override
  // void onInit() {
  //   getAllTask();
  //   super.onInit();
  // }

  Future getTotalTask() async {
    try {
      tasks.value.clear();
      isLoadingTotalTask.value = true;
      var response = await http.get(Uri.parse('${url}task/count'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoadingTotalTask.value = false;
        print(totalTask);
        final content = json.decode(response.body)['count'];
        print(content);
        print(totalTask.value);
        totalTask.value =
            content; // Sesuaikan 'count' sesuai dengan struktur respons API
        print(totalTask
            .value); // Sesuaikan 'count' sesuai dengan struktur respons API
      } else {
        isLoadingTotalTask.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoadingTotalTask.value = false;
      print(e.toString());
    }
  }

  Future getAllTask() async {
    try {
      tasks.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}task'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['pasks'];
        for (var item in content) {
          tasks.value.add(TaskModel.fromJson(item));
        }
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future getProgramTask(String id) async {
    try {
      tasks.value.clear();
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('${url}program-$id/task'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['tasks'];
        for (var item in content) {
          tasks.value.add(TaskModel.fromJson(item));
        }
        print(content);
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future getUserTask() async {
    try {
      tasks.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}user/task'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['tasks'];
        for (var item in content) {
          tasks.value.add(TaskModel.fromJson(item));
          print(item);
        }
        print('getUserTask() success');
        print(tasks.value[0].pivot!.status!);
        print(tasks.value[1].pivot!.status!);
        print('tasks value');
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future getTaskById(String id) async {
    try {
      tasks2.value.clear();
      taskTeam.value.clear();
      isLoadingGetTaskById.value = true;
      var response = await http.get(Uri.parse('${url}task/$id'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoadingGetTaskById.value = false;
        final content1 = json.decode(response.body)['task'];
        final content2 = json.decode(response.body)['task_users'];
        print('data task');
        print(content1);
        print('data team');
        print(content2);
        tasks2.value.add(TaskModel.fromJson(content1)) ; // Abaikan `users`
        for (var item in content2) {
          taskTeam.value.add(TeamModel.fromJson(item));
          print(item);
        }
        // taskTeam.value.add(TeamModel.fromJson(content2)) ; // Abaikan `users`
        print(taskTeam.value);
        // print(task.value.id!);
        // print(task.value.name!);
        // print(task.value.host!);
        // print(task.value.date!);
        // print(task.value.location!);
        // print(task.value.description!);
        // print(task.value.description!);
        // print('data berhasil disimpan');
      } else {
        isLoadingGetTaskById.value = false;
      }
    } catch (e) {
      isLoadingGetTaskById.value = false;
    }
  }

  Future createTask(
    programId,
    name,
    description,
    location,
    date,
    time,
    host,
    uploadedFilePath, // file path bisa null
  ) async {
    try {
      // Data tanpa file
      var data = {
        'program_id': programId,
        'name': name,
        'description': description,
        'location': location,
        'date': date,
        'time': time,
        'host': host,
      };

      // Kirim data tanpa file
      var request = await http.post(
        Uri.parse('${url}task/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (uploadedFilePath != null && uploadedFilePath.isNotEmpty) {
        // Kirim file jika path-nya ada
        File file = File(uploadedFilePath);
        var request =
            http.MultipartRequest('POST', Uri.parse('${url}task/'))
              ..headers['Authorization'] = 'Bearer ${box.read('token')}'
              ..files.add(await http.MultipartFile.fromPath('file', file.path));

        var response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('File berhasil dikirim.');
        } else {
          print('Gagal mengirim file: ${response.statusCode}');
        }
      } else {
        print('File tidak dipilih, data tetap terkirim tanpa file.');
      }

      if (request.statusCode == 201 || request.statusCode == 200) {
        print(json.decode(request.body));
      } else {
        print('Gagal mengirim data: ${json.decode(request.body)}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateTask(
    taskId,
    programId,
    name,
    description,
    location,
    date,
    time,
    host,
    uploadedFilePath, // file path bisa null
  ) async {
    try {
      // Data tanpa file
      var data = {
        'program_id': programId,
        'name': name,
        'description': description,
        'location': location,
        'date': date,
        'time': time,
        'host': host,
      };

      // Kirim data tanpa file
      var request = await http.put(
        Uri.parse('${url}task/$taskId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (uploadedFilePath != null && uploadedFilePath.isNotEmpty) {
        // Kirim file jika path-nya ada
        File file = File(uploadedFilePath);
        var request =
            http.MultipartRequest('PUT', Uri.parse('${url}task/$taskId'))
              ..headers['Authorization'] = 'Bearer ${box.read('token')}'
              ..files.add(await http.MultipartFile.fromPath('file', file.path));

        var response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('File berhasil dikirim.');
        } else {
          print('Gagal mengirim file: ${response.statusCode}');
        }
      } else {
        print('File tidak dipilih, data tetap terkirim tanpa file.');
      }

      if (request.statusCode == 201 || request.statusCode == 200) {
        print(json.decode(request.body));
      } else {
        print('Gagal mengirim data: ${json.decode(request.body)}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future deleteTask(taskId) async {
    try {
      isLoading.value = true;
      var request = await http.delete(
        Uri.parse('${url}task/$taskId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (request.statusCode == 200) {
        isLoading.value = false;
        print(json.decode(request.body));
      } else {
        isLoading.value = false;
        print(json.decode(request.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //CRUD TEAM

  Future createTaskTeam(taskId, dataUser) async {
    // List<Map<String, dynamic>> idList = convertToIdList(dataUser);
    final List<dynamic> ids =
        dataUser.map((e) => "${e.id}".toString()).toList();
    try {
      isLoading.value = true;
      var data = {'id': ids};

      var request = await http.post(
        Uri.parse('${url}task/$taskId/attachTeam'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
          'Content-Type': 'application/json',
        },
        // body: jsonEncode(dataUser.map((e) => {'id': e.id}).toList()),
        body: json.encode(data),
      );

      if (request.statusCode == 200) {
        isLoading.value = false;
        print(json.decode(request.body));
      } else {
        isLoading.value = false;
        // print(dataUser.id);
        print(json.decode(request.body));
        print(ids);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
