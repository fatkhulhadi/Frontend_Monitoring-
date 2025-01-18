import 'dart:convert';

import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/models/sector_model.dart';
import 'package:Monitoring/models/user_model.dart';

class SectorController extends GetxController {
  Rx<List<SectorModel>> sectors = Rx<List<SectorModel>>([]);
  Rx<List<UserModel>> users = Rx<List<UserModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  Future getAllSector() async {
    try {
      sectors.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}sector'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['sectors'];
        for (var item in content) {
          sectors.value.add(SectorModel.fromJson(item));
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

  Future getUsersBySector(sectorId) async {
    try {
      users.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}getUsersBySector/$sectorId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['users'];
        for (var item in content) {
          users.value.add(UserModel.fromJson(item));
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

}