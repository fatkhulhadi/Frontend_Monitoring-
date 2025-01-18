import 'package:flutter/material.dart';
import 'package:Monitoring/intro/login.dart';
import 'package:Monitoring/bottom_navbar.dart';
import 'package:Monitoring/bottom_navbar_sup.dart';
import 'package:Monitoring/bottom_navbar_user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init(); // Pastikan GetStorage diinisialisasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final guard = box.read('guard');

    // Tentukan halaman awal berdasarkan token dan guard
    Widget determineHome() {
      if (token == null) {
        return LoginScreen();
      }

      // Periksa guard dan arahkan ke BottomNavigation yang sesuai
      switch (guard) {
        case 'admin':
          return BottomNavigation(); // Admin
        case 'supervisor':
          return BottomNavigationSupervisor(); // Supervisor
        case 'user':
          return BottomNavigationUser(); // User
        default:
          return LoginScreen(); // Jika guard tidak dikenal
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: determineHome(), // Gunakan fungsi untuk menentukan halaman awal
    );
  }
}
