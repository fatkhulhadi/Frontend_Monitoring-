// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:Monitoring/controllers/report_controller.dart';

// import 'dart:io';

// // void main() {
// //   runApp(LaporanKegiatan());
// // }

// class LaporanKegiatan extends StatefulWidget {
//   const LaporanKegiatan({
//     super.key,
//     required this.taskId,
//   });

//   final String taskId;
//   @override
//   _LaporanKegiatanState createState() => _LaporanKegiatanState();
// }

// class _LaporanKegiatanState extends State<LaporanKegiatan> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   String? _documentPath;
//   String _currentLocation = 'Lokasi belum dideteksi';
//   String _address = 'Alamat belum tersedia';
//   ReportController _reportController = ReportController();
//   final TextEditingController _deskripsiController = TextEditingController();

//   LatLng _currentPosition = LatLng(-6.200000, 106.816666);
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _currentLocation = 'Layanan lokasi dinonaktifkan.';
//       });
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _currentLocation = 'Izin lokasi ditolak';
//         });
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _currentLocation = 'Izin lokasi ditolak secara permanen.';
//       });
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       Placemark place = placemarks[0];
//       String formattedAddress =
//           '${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}';

//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//         _currentLocation = '${position.latitude}, ${position.longitude}';
//         _address = formattedAddress;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = pickedFile;
//     });
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.any,
//     );

//     if (result != null) {
//       setState(() {
//         _documentPath = result.files.single.path;
//       });
//     }
//   }

//   // void _saveReport() {
//   //   // Implementasikan logika penyimpanan laporan di sini
//   //   // Misalnya, simpan ke database atau kirim ke server
//   //   print('Laporan disimpan');
//   //   print('Lokasi: $_currentLocation');
//   //   print('Alamat: $_address');
//   //   // Anda bisa menambahkan logika lain sesuai kebutuhan
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Laporan Kegiatan',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[100],
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Stack(
//         children: <Widget>[
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : FlutterMap(
//                   options: MapOptions(
//                     center: _currentPosition,
//                     zoom: 13.0,
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate:
//                           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                       subdomains: ['a', 'b', 'c'],
//                     ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: _currentPosition,
//                           builder: (ctx) => Icon(
//                             Icons.location_pin,
//                             color: Colors.red,
//                             size: 40,
//                           ),
//                           width: 80.0,
//                           height: 80.0,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.3,
//             minChildSize: 0.1,
//             maxChildSize: 0.9,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
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
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         controller: scrollController,
//                         padding: EdgeInsets.all(16),
//                         children: <Widget>[
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                   color: Colors.blue[100]!, width: 1),
//                             ),
//                             padding: EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ListTile(
//                                   title: Text('Mengecek Perangkat CCTV'),
//                                   subtitle: Text(
//                                       '${_currentPosition.latitude}, ${_currentPosition.longitude}'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text('Dokumentasi Kegiatan',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           Container(
//                             height: 200,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: _image == null
//                                   ? Icon(Icons.camera_alt,
//                                       size: 50, color: Colors.grey[600])
//                                   : Image.file(File(_image!.path),
//                                       fit: BoxFit.cover),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                             ),
//                             onPressed: _pickImage,
//                             child: Text('Upload Gambar Dokumentasi Kegiatan'),
//                           ),
//                           SizedBox(height: 16),
//                           Text('Notes',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: _deskripsiController,
//                             decoration: InputDecoration(
//                               hintText: 'Tambahkan Catatan',
//                               border: OutlineInputBorder(),
//                             ),
//                             maxLines: 3,
//                           ),
//                           SizedBox(height: 16),
//                           Text('Dokumen',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                             ),
//                             onPressed: _pickDocument,
//                             child: Text('Upload Dokumen'),
//                           ),
//                           if (_documentPath != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child:
//                                   Text('Dokumen yang dipilih: $_documentPath'),
//                             ),
//                           SizedBox(height: 16),
//                           Text('Lokasi Terkini',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           Text(_currentLocation),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                             ),
//                             onPressed: _getCurrentLocation,
//                             child: Text('Deteksi Lokasi'),
//                           ),
//                           SizedBox(height: 16),
//                           Text('Alamat Terkini',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           Text(_address),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                             ),
//                             onPressed: () async {
//                               // File file = File(uploadedFilePath!);
//                               await _reportController.createReport(
//                                   widget.taskId,
//                                   _deskripsiController.text.trim(),
//                                   _currentPosition.longitude,
//                                   _currentPosition.latitude,
//                                   _image!.path,
//                                   _documentPath);
//                                   print(_deskripsiController.text.trim());
//                                   print(_currentPosition.longitude);
//                                   print(_currentPosition.latitude);
//                                   print(_image!.path);
//                                   print(_documentPath);
//                               Navigator.pop(context, true);
//                             },
//                             child: Text('Simpan'),
//                           ),
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
