import 'package:Monitoring/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

class HeaderScreen extends StatefulWidget {
  @override
  State<HeaderScreen> createState() => _HeaderScreenState();
}

class _HeaderScreenState extends State<HeaderScreen> {
  final box = GetStorage();
  int _totalProgram = 0;
  int _totalKegiatan = 0; // Tambahkan variabel untuk total kegiatan
  bool _isProgramLoading = true;
  bool _isKegiatanLoading = true; // Loading state untuk kegiatan
  String _errorMessage = '';
  
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _fetchProgramCount();
    _fetchKegiatanCount(); // Panggil metode fetch kegiatan
  }

  @override
  void dispose() {
    _isCancelled = true;
    super.dispose();
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
  String getTotalTaskApi() {
    final guard = box.read('guard');

    if (guard == 'admin') {
      return '${url}task/count';
    } else if (guard == 'supervisor') {
      return '${url}task/count/sector';
    } else {
      return '${url}task/count/user';
    }
  }

  // Metode fetch program (tetap sama)
  Future<void> _fetchProgramCount() async {
    try {
      final token = box.read('token');
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      final response = await http.get(
        Uri.parse(getTotalProgramApi()),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('Debug: Program Count Request Timeout');
          throw TimeoutException('Request Timeout');
        },
      );

      print('Debug: Program Count Response Status Code = ${response.statusCode}');
      print('Debug: Program Count Response Body = ${response.body}');

      if (_isCancelled) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (mounted) {
          setState(() {
            _totalProgram = data['count'] ?? 0;
            _isProgramLoading = false;
          });
        }
      } else {
        _handleError('Gagal memuat jumlah program. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Debug: Fetch Program Count Error = $e');
      _handleError(e.toString());
    }
  }

  // Metode fetch kegiatan baru
  Future<void> _fetchKegiatanCount() async {
    try {
      final token = box.read('token');
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      final response = await http.get(
        Uri.parse(getTotalTaskApi()),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('Debug: Task Count Request Timeout');
          throw TimeoutException('Request Timeout');
        },
      );

      print('Debug: Task Count Response Status Code = ${response.statusCode}');
      print('Debug: Task Count Response Body = ${response.body}');

      if (_isCancelled) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (mounted) {
          setState(() {
            _totalKegiatan = data['count'] ?? 0;
            _isKegiatanLoading = false;
          });
        }
      } else {
        _handleError('Gagal memuat jumlah kegiatan. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Debug: Fetch Task Count Error = $e');
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    if (!_isCancelled && mounted) {
      setState(() {
        _isProgramLoading = false;
        _isKegiatanLoading = false;
        _errorMessage = message;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 25.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            _buildHeader(),
            SizedBox(height: 20),
            _buildProfile(context),
            SizedBox(height: 20),
            _buildStatCards(),
            
            // Tambahkan widget untuk menampilkan pesan error
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
  // Modifikasi _buildStatCards untuk menggunakan _totalKegiatan
  Widget _buildStatCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildStatCard(
            'Program',
            _isProgramLoading ? 'Loading...' : _totalProgram.toString(),
            Icons.folder,
            isLoading: _isProgramLoading,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Kegiatan',
            _isKegiatanLoading ? 'Loading...' : _totalKegiatan.toString(),
            Icons.task,
            isLoading: _isKegiatanLoading,
          ),
        ),
      ],
    );
  }
  // Tambahkan metode _buildStatCard
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    bool isLoading = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Text(
                  value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Image.asset(
        'assets/monitoring.png',
        width: double.infinity,
        height: 28.0,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${box.read('user')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${box.read('occupation')}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}