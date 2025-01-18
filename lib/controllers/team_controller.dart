import 'dart:convert';

import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/models/team_model.dart';
import 'package:Monitoring/models/user_model.dart';

class TeamController extends GetxController {
  Rx<List<TeamModel>> teams = Rx<List<TeamModel>>([]);
  final isLoading = false.obs;
  final isLoadingUpdateRole = false.obs;
  final box = GetStorage();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  Future getTeamMember(String id) async {
    try {
      teams.value.clear();
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('${url}program/$id/team'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['team'];
        for (var item in content) {
          teams.value.add(TeamModel.fromJson(item));
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

  Future createTeam(programId, dataUser) async {
    // List<Map<String, dynamic>> idList = convertToIdList(dataUser);
    final List<dynamic> ids =
        dataUser.map((e) => "${e.id}".toString()).toList();
    try {
      isLoading.value = true;
      var data = {'id': ids};

      var request = await http.post(
        Uri.parse('${url}program-$programId/team/many'),
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
        print(ids);
        print(json.decode(request.body));
      } else {
        isLoading.value = false;
        // print(dataUser.id);
        print(ids);
        print(json.decode(request.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateRoleTeam(programId, userId, role) async {
    try {
      isLoading.value = true;
      var data = {'user_id': userId, 'role': role};

      var request = await http.put(
        Uri.parse('${url}program-$programId/team'),
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

  Future deleteTeamMember(programId, userId) async {
    try {
      isLoading.value = true;
      var data = {
        'user_id': userId,
      };

      var request = await http.delete(
        Uri.parse('${url}program-$programId/team'),
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
}
