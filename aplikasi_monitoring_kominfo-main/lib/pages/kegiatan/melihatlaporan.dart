import 'package:Monitoring/pages/kegiatan/pdflaporankegiatan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:Monitoring/controllers/report_controller.dart';
import 'package:Monitoring/controllers/authentication.dart';
import 'package:Monitoring/models/report_model.dart';
import 'package:Monitoring/widget/refreshable_gadget.dart';
import 'package:get/get.dart';
import 'dart:io';

class MelihatLaporanKegiatan extends StatefulWidget {
  const MelihatLaporanKegiatan({
    super.key,
    required this.taskId,
  });

  final String taskId;

  @override
  _MelihatLaporanKegiatanState createState() => _MelihatLaporanKegiatanState();
}

class _MelihatLaporanKegiatanState extends State<MelihatLaporanKegiatan> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _catatanController = TextEditingController();
  XFile? _image;
  String? _documentPath;
  String _selectedStatus = 'Diterima';
  final List<String> _statusOptions = ['Diterima', 'Pending'];
  ReportController _reportController = ReportController();
  final MapController _mapController = MapController();

  LatLng _markerPosition = LatLng(-6.200000, 106.816666);
  String fileName = '1.pdf';

  final List<String> _imagePaths = [
    'assets/Screenshot (285).png',
    'assets/Screenshot (286).png',
    'assets/Screenshot (287).png',
    'assets/Screenshot (287).png',
    'assets/Screenshot (287).png',
  ];

  bool get _isSupervisor {
    final AuthenticationController authController = Get.find();
    return authController.guard.value == 'supervisor';
  }

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  void _fetchReportData() async {
    await _reportController.getReport(widget.taskId);

    if (mounted && _reportController.report.value.isNotEmpty) {
      setState(() {
        _markerPosition = LatLng(
            _reportController.report.value.first.longitude!,
            _reportController.report.value.first.latitude!);
        _mapController.move(_markerPosition, _mapController.zoom);
      });
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _simpanCatatan() async {
    try {
      await _reportController.updateReportComment(
          widget.taskId, _catatanController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan')),
      );

      await _reportController.getReport(widget.taskId);
      _catatanController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan catatan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text(
          'Lihat Kegiatan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _reportController.getReport(widget.taskId);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _markerPosition,
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _markerPosition,
                    builder: (ctx) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                    width: 80.0,
                    height: 80.0,
                  ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: <Widget>[
                          const SizedBox(height: 16),
                          const Text('Dokumentasi Kegiatan',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: _imagePaths.map((imagePath) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      imagePath,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Notes',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RefreshableWidget(
                              onRefresh: () async {
                                await _reportController
                                    .getReport(widget.taskId);
                              },
                              isLoading: _reportController.isLoading,
                              child: Obx(() {
                                if (_reportController.report.value.isEmpty) {
                                  return const Text(
                                    'Tidak ada laporan tersedia.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  );
                                }
                                return Text(
                                  _reportController
                                      .report.value.first.description!,
                                  style: const TextStyle(fontSize: 16),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('File Dokumentasi',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fileName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LihatLaporan(
                                          assetPath: 'assets/$fileName',
                                          downloadUrl:
                                              'https://example.com/path/to/asset/$fileName',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                           const SizedBox(height: 24),
                          Container(
                            height: 2, // Ketebalan garis
                            color: Colors.black, // Warna garis
                          ),
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: $_selectedStatus'),
                                if (_isSupervisor)
                                  DropdownButton<String>(
                                    value: _selectedStatus,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedStatus = newValue!;
                                      });
                                    },
                                    items: _statusOptions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                else
                                  Text(_selectedStatus),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: const Text('Mengecek Perangkat CCTV'),
                                  subtitle: Text(
                                      '${_markerPosition.latitude}, ${_markerPosition.longitude}'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isSupervisor) ...[
                            const Text('Tambah Catatan',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: _catatanController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText: 'Tulis catatan tambahan...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                          if (_isSupervisor)
                            ElevatedButton(
                              onPressed: _simpanCatatan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Simpan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
