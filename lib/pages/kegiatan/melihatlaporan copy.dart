// import 'package:Monitoring/pages/kegiatan/pdflaporankegiatan.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:Monitoring/controllers/report_controller.dart';
// import 'package:Monitoring/models/report_model.dart';
// import 'package:Monitoring/widget/refreshable_gadget.dart';
// import 'package:get/get.dart';
// import 'dart:io';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Laporan Kegiatan',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: MelihatLaporanKegiatan(),
// //     );
// //   }
// // }

// class MelihatLaporanKegiatan extends StatefulWidget {
//   const MelihatLaporanKegiatan({
//     super.key,
//     required this.taskId,
//   });

//   final String taskId;

//   @override
//   _MelihatLaporanKegiatanState createState() => _MelihatLaporanKegiatanState();
// }

// class _MelihatLaporanKegiatanState extends State<MelihatLaporanKegiatan> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   String? _documentPath;
//   String _selectedStatus = 'Diterima';
//   final List<String> _statusOptions = ['Diterima', 'Pending'];
//   ReportController _reportController = ReportController();
//   final MapController _mapController = MapController();

//   LatLng _markerPosition = LatLng(-6.200000, 106.816666);
//   String fileName = '1.pdf'; // Ganti ini dengan nama file yang sesuai

//   // List of image paths to display
//   final List<String> _imagePaths = [
//     'assets/Screenshot (285).png',
//     'assets/Screenshot (286).png',
//     'assets/Screenshot (287).png',
//     'assets/Screenshot (287).png',
//     'assets/Screenshot (287).png',
//   ];

//   final List<Map<String, dynamic>> _databaseCoordinates = [
//     {'latitude': -6.175110, 'longitude': 106.865036},
//     {'latitude': -7.797068, 'longitude': 110.370529},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _reportController.getReport(widget.taskId).then((_) {
//       if (mounted) {
//         setState(() {
//           _markerPosition = LatLng(
//               _reportController.report.value.first.longitude!,
//               _reportController.report.value.first.latitude!);
//           _mapController.move(_markerPosition, _mapController.zoom);
//         });
//       }
//     });

//     // _getCoordinatesFromDatabase();
//   }

//   // Future<void> _getCoordinatesFromDatabase() async {
//   //   await Future.delayed(const Duration(seconds: 2));
//   //   double latitude = _databaseCoordinates[0]['latitude'];
//   //   double longitude = _databaseCoordinates[0]['longitude'];

//   //   setState(() {
//   //     _markerPosition = LatLng(latitude, longitude);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[100],
//         title: const Text(
//           'Lihat Kegiatan',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: <Widget>[
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               center: _markerPosition,
//               zoom: 13.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 subdomains: ['a', 'b', 'c'],
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: _markerPosition,
//                     builder: (ctx) => const Icon(
//                       Icons.location_pin,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                     width: 80.0,
//                     height: 80.0,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.3,
//             minChildSize: 0.1,
//             maxChildSize: 0.9,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 5,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         controller: scrollController,
//                         padding: const EdgeInsets.all(16),
//                         children: <Widget>[
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                                border: Border.all(color: Colors.blue, width: 1),
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Status: $_selectedStatus'),
//                                 DropdownButton<String>(
//                                   value: _selectedStatus,
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       _selectedStatus = newValue!;
//                                     });
//                                   },
//                                   items: _statusOptions
//                                       .map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ListTile(
//                                   title: const Text('Mengecek Perangkat CCTV'),
//                                   subtitle: Text(
//                                       '${_markerPosition.latitude}, ${_markerPosition.longitude}'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text('Dokumentasi Kegiatan',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           // SingleChildScrollView for images
//                           SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: Column(
//                               children: _imagePaths.map((imagePath) {
//                                 return Container(
//                                   margin: const EdgeInsets.only(bottom: 16),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Image.asset(
//                                       imagePath,
//                                       width: MediaQuery.of(context).size.width,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text('Notes',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: RefreshableWidget(
//                                 onRefresh: () async {
//                                   await _reportController
//                                       .getReport(widget.taskId);
//                                 },
//                                 isLoading: _reportController.isLoading,
//                                 child: Obx(() {
//                                   if (_reportController.report.value.isEmpty) {
//                                     return Text(
//                                       'Tidak ada laporan tersedia.',
//                                       style: TextStyle(
//                                           fontSize: 16, color: Colors.grey),
//                                     );
//                                   }

//                                   return Text(
//                                     _reportController
//                                         .report.value.first.description!,
//                                     style: TextStyle(fontSize: 16),
//                                   );
//                                 })),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text('File Dokumentasi',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   fileName, // Menampilkan nama file
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.visibility),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => LihatLaporan(
//                                           assetPath:
//                                               'assets/$fileName', // Menggunakan nama file dinamis
//                                           downloadUrl:
//                                               'https://example.com/path/to/asset/$fileName',
//                                               // downloadUrl2: _reportController.report.value.first.file! // Menggunakan nama file dinamis
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
