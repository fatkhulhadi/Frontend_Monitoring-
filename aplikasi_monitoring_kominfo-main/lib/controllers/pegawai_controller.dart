import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PegawaiController extends GetxController {
  final box = GetStorage();
  RxList<Map<String, dynamic>> pegawaiList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Metode untuk fetch semua pegawai
  Future<void> fetchAllPegawai() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';

      // Ambil token dari storage
      final token = box.read('token');
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      // Lakukan request HTTP
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw Exception('Request Timeout'),
      );

      // Debug print
      print('Pegawai Response Status: ${response.statusCode}');
      print('Pegawai Response Body: ${response.body}');

      // Periksa status response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Konversi data ke list map
        List<Map<String, dynamic>> pegawai = 
          List<Map<String, dynamic>>.from(data['users'].map((user) => {
            'Nomor': user['id'].toString(),
            'Nama': user['name'] ?? '',
            'Jabatan': user['occupation']['name'] ?? '',
            'Bidang': user['sector'] ?? '',
            'NIP': user['nip'] ?? '',
            'Email': user['email'] ?? '',
          }));

        // Update list pegawai
        pegawaiList.value = pegawai;
        isLoading.value = false;
      } else {
        // Tangani error response
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error
      isLoading.value = false;
      errorMessage.value = e.toString();
      print('Error fetching pegawai: $e');
    }
  }

  // Metode untuk menambah pegawai
  Future<bool> tambahPegawai(Map<String, dynamic> pegawaiData) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(pegawaiData),
      );

      print('Tambah Pegawai Response: ${response.body}');

      if (response.statusCode == 201) {
        // Refresh daftar pegawai setelah berhasil menambah
        await fetchAllPegawai();
        isLoading.value = false;
        return true;
      } else {
        throw Exception('Gagal menambah pegawai: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  // Metode untuk update pegawai
  Future<bool> updatePegawai(String id, Map<String, dynamic> pegawaiData) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/user/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(pegawaiData),
      );

      print('Update Pegawai Response: ${response.body}');

      if (response.statusCode == 200) {
        // Refresh daftar pegawai setelah berhasil update
        await fetchAllPegawai();
        isLoading.value = false;
        return true;
      } else {
        throw Exception('Gagal update pegawai: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  // Metode untuk hapus pegawai
  Future<bool> hapusPegawai(String id) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/user/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Hapus Pegawai Response: ${response.body}');

      if (response.statusCode == 200) {
        // Refresh daftar pegawai setelah berhasil hapus
        await fetchAllPegawai();
        isLoading.value = false;
        return true;
      } else {
        throw Exception('Gagal hapus pegawai: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }
}