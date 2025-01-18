import 'dart:convert';

import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/models/program_model.dart';

class ProgramController extends GetxController {
  Rx<List<ProgramModel>> programs = Rx<List<ProgramModel>>([]);
  Rx<ProgramModel?> program = Rx<ProgramModel?>(null);
  // Rx<List<SectorModel>> sectors = Rx<List<SectorModel>>([]);
  final isLoading = false.obs;
  final isLoadingTotalProgram = false.obs;
  final isLoadingGetProgramById = false.obs;
  final box = GetStorage();
  RxInt totalProgram = 0.obs;

  String getProgramApi() {
    final guard = box.read('guard');

    if (guard == 'admin') {
      return '${url}programProgress';
    } else if (guard == 'supervisor') {
      return '${url}program/sector';
    } else {
      return '${url}user/program';
    }
  }
  String getTotalProgramApi() {
    final guard = box.read('guard');

    if (guard == 'admin') {
      return '${url}program/count';
    } else if (guard == 'supervisor') {
      return '${url}program/count/sector';
    } else {
      return '${url}program/count/user';
    }
  }

  // @override
  // void onInit() {
  //   getAllProgram();
  //   super.onInit();
  // }

  // Future<void> fetchProgramCount() async {
  //   final response = await http.get(Uri.parse('${url}/count/program'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //       totalPrograms = data['count'];
  //   } else {
  //     throw Exception('Failed to load program count');
  //   }
  // }

  Future getTotalProgram() async {
    try {
      // total.value.clear();
      if (isLoadingTotalProgram.value) return;
      isLoadingTotalProgram.value = true;
      var response = await http.get(Uri.parse('${url}program/count'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoadingTotalProgram.value = false;
        final content = json.decode(response.body)['count'];
        totalProgram.value = content;
      } else {
        isLoadingTotalProgram.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoadingTotalProgram.value = false;
      print(e.toString());
    }
  }

  Future getAllProgram() async {
    try {
      programs.value.clear();
      if (isLoading.value) return;
      isLoading.value = true;
      var response =
          await http.get(Uri.parse(getProgramApi()), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['programs'];
        for (var item in content) {
          programs.value.add(ProgramModel.fromJson(item));
        }
        print(content);
        print('ini program');
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print('gagal2');
      print(e.toString());
    }
  }

  Future getProgramById(String id) async {
    try {
      programs.value.clear();
      isLoadingGetProgramById.value = true;
      var response = await http.get(Uri.parse('${url}program/$id/'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoadingGetProgramById.value = false;
        final content = json.decode(response.body)['program'];
        print('data program');
        print(content);
        for (var item in content) {
          program.value = (ProgramModel.fromJson(item));
        }
        print('programlist');
      } else {
        isLoadingGetProgramById.value = false;
        print(json.decode(response.body));
        print('gagal2-programById');
      }
    } catch (e) {
      isLoadingGetProgramById.value = false;
      print('gagal2-programById');
      print(e.toString());
    }
  }

  Future createProgram(sectorId, name, description, startDate, endDate) async {
    try {
      isLoading.value = true;
      var data = {
        'sector_id': sectorId,
        'name': name,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
      };

      var request = await http.post(
        Uri.parse('${url}program'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (request.statusCode == 201) {
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

  Future updateProgram(
      programId, sectorId, name, description, startDate, endDate) async {
    try {
      isLoading.value = true;
      var data = {
        'sector_id': sectorId,
        'name': name,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
      };

      var request = await http.put(
        Uri.parse('${url}program/$programId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
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

  Future deleteProgram(String id) async {
    try {
      programs.value.clear();
      isLoading.value = true;
      var response =
          await http.delete(Uri.parse('${url}program/$id/'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        print(json.decode(response.body));
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
