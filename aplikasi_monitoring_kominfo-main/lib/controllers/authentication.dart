import 'dart:convert';

import 'package:Monitoring/bottom_navbar_sup.dart';
import 'package:Monitoring/bottom_navbar_user.dart';
import 'package:Monitoring/constants/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Monitoring/bottom_navbar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final user = ''.obs;
  final emailUser = ''.obs;
  final token = ''.obs;
  final guard = ''.obs;

  final box = GetStorage();

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        user.value = json.decode(response.body)['user'];
        emailUser.value = json.decode(response.body)['email'];
        token.value = json.decode(response.body)['token'];
        guard.value = json.decode(response.body)['guard'];
        var occupation =
            json.decode(response.body)['occupation'] ?? 'Kepala Dinas';

        box.write('user', user.value);
        box.write('emailUser', emailUser.value);
        box.write('token', token.value);
        box.write('guard', guard.value);
        box.write('occupation', occupation);
        if (box.read('guard') == 'admin') {
          Get.off(() => BottomNavigation()); // Use GetX navigation here
        } else if (box.read('guard') == 'supervisor') {
          Get.off(() => BottomNavigationSupervisor()); // Use GetX navigation here
        } else {
          Get.off(() => BottomNavigationUser()); // Use GetX navigation here
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
