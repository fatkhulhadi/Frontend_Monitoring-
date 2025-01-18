// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// import 'dart:io';

// class EditLaporanKegiatan extends StatefulWidget {
//   const EditLaporanKegiatan({
//     super.key,
//     required this.taskId,
//   });

//   final String taskId;

//   @override
//   _EditLaporanKegiatanState createState() => _EditLaporanKegiatanState();
// }

// class _EditLaporanKegiatanState extends State<EditLaporanKegiatan> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   String? _documentPath;
//   String _currentLocation = 'Lokasi belum dideteksi';
//   String _address = 'Alamat belum tersedia';
//   String _selectedStatus = 'Diterima';
//   bool _isLoading = true;
//   bool _isSaving = false;
//   final TextEditingController _notesController = TextEditingController();

//   LatLng _currentPosition = LatLng(-6.200000, 106.816666);

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
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
//       setState(() {
//         _address = 'Tidak dapat menemukan alamat';
//       });
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

//   Future<void> _saveLaporan() async {
//     if (_isSaving) return;

//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       // Show loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: Card(
//               child: Container(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text('Menyimpan laporan...'),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );

//       // Add your save logic here
//       // For example:
//       // await saveToAPI({
//       //   'taskId': widget.taskId,
//       //   'status': _selectedStatus,
//       //   'location': _currentLocation,
//       //   'address': _address,
//       //   'notes': _notesController.text,
//       //   'image': _image?.path,
//       //   'document': _documentPath,
//       // });

//       // Simulate network delay
//       await Future.delayed(Duration(seconds: 2));

//       // Close loading dialog
//       Navigator.of(context).pop();

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Laporan berhasil disimpan'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Return to previous screen
//       Navigator.of(context).pop();
//     } catch (e) {
//       // Close loading dialog
//       Navigator.of(context).pop();

//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal menyimpan laporan: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isSaving = false;
//       });
//     }
//   }

//   @override
//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Laporan Kegiatan',
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
//                               border: Border.all(color: Colors.blue[100]!, width: 1),
//                             ),
//                             padding: EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Status: $_selectedStatus'),
//                                   ],
//                                 ),
//                                 SizedBox(height: 16),
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
//                             onPressed: _pickImage,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               minimumSize: Size(double.infinity, 40),
//                             ),
//                             child: Text(
//                               'Upload Gambar Dokumentasi Kegiatan',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text('Notes',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: _notesController,
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
//                             onPressed: _pickDocument,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               minimumSize: Size(double.infinity, 40),
//                             ),
//                             child: Text(
//                               'Upload Dokumen',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           if (_documentPath != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text('Dokumen yang dipilih: $_documentPath'),
//                             ),
//                           SizedBox(height: 16),
//                           Text('Lokasi Terkini',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           Text(_currentLocation),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: _getCurrentLocation,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               minimumSize: Size(double.infinity, 40),
//                             ),
//                             child: Text(
//                               'Deteksi Lokasi',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text('Alamat Terkini',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 8),
//                           Text(_address),
//                           SizedBox(height: 24),
//                           Container(
//                             width: double.infinity,
//                             height: 40,
//                             child: ElevatedButton(
//                               onPressed: _isSaving ? null : _saveLaporan,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: Text(
//                                 _isSaving ? 'Menyimpan...' : 'Simpan Laporan',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
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
//   }