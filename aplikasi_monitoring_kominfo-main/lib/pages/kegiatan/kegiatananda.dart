// import 'package:flutter/material.dart';
// import 'package:Monitoring/pages/header.dart';
// import 'package:Monitoring/pages/kegiatan/editlaporan.dart';
// import 'package:Monitoring/pages/kegiatan/melihatlaporan.dart';
// import 'package:Monitoring/pages/kegiatan/tambahlaporan.dart';
// import 'package:get/get.dart';
// import 'package:Monitoring/controllers/program_controller.dart';
// import 'package:Monitoring/controllers/task_controller.dart';
// import 'package:Monitoring/models/program_model.dart';
// import 'package:intl/intl.dart';

// class KegiatanAndaPage extends StatefulWidget {
//   @override
//   _KegiatanAndaPageState createState() => _KegiatanAndaPageState();
// }

// class _KegiatanAndaPageState extends State<KegiatanAndaPage> {
//   bool isDateTodayOrFuture(String dateString) {
//     DateTime activityDate = parseDate(dateString);
//     DateTime today = DateTime.now();
//     today = DateTime(today.year, today.month, today.day);

//     // print("Activity Date: $activityDate, Today: $today"); // Debugging
//     return activityDate.isAfter(today) || activityDate.isAtSameMomentAs(today);
//   }
//   List<bool> _isExpandedList = [];

//   // final ProgramController _programController = Get.put(ProgramController());
//   final TaskController _taskController = Get.put(TaskController());
//   final List<Map<String, dynamic>> programData = [
//     {
//       'Kegiatan': 'Kegiatan A',
//       'Role': 'Koordinator',
//       'Tanggal Kegiatan': '06-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Pending',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '07-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Pending',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '12-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Pending',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '16-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Diserahkan',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '17-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Diterima',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '13-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-12-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Diserahkan',
//     },
//     {
//       'Kegiatan': 'Kegiatan   Perbaikan CCTV Taman Pancasila',
//       'Role': 'Kepala Bidang',
//       'Tanggal Kegiatan': '15-9-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan awokawok',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-01-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '02-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Pending',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Diserahkan',
//     },
//     {
//       'Kegiatan': 'Kegiatan B',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-10-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Diterima',
//     },
//   ];
//   String searchQuery = '';
//   int currentPage = 0;
//   int itemsPerPage = 10; // Default items per page
//   final List<int> itemsOptions = [5, 10, 20]; // Options for items per page
//   String selectedFilter = 'Semua'; // Filter yang dipilih


//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // _programController.getTotalProgram();
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // _programController.getTotalProgram();
//      _isExpandedList = List<bool>.filled(programData.length, false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           HeaderScreen(),
//           SizedBox(height: 16),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Stack(
//                 children: [
//                   _buildSearchAndTableCard(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   DateTime parseDate(String dateString) {
//     List<String> parts = dateString.split('-');
//     if (parts.length == 3) {
//       int day = int.parse(parts[0]);
//       int month = int.parse(parts[1]);
//       int year = int.parse(parts[2]);
//       return DateTime(year, month, day);
//     }
//     throw FormatException('Invalid date format');
//   }

//   Widget _buildSearchAndTableCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//       child: 
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               SizedBox(height: 10),
//               _buildSearchBar(),
//               SizedBox(height: 10),
//               _buildProgramTable(),
//               SizedBox(height: 10),
//               _buildPagination(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Cari Kegiatan',
//               hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
//               prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide(
//                   color: Colors.blueAccent,
//                   width: 2.0,
//                 ),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 14.0,
//                 horizontal: 16.0,
//               ),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value.toLowerCase();
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Kegiatan Anda',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         IconButton(
//           icon: Icon(Icons.filter_list),
//           onPressed: () {
//             _showFilterDialog();
//           },
//         ),
//       ],
//     );
//   }

// void _showFilterDialog() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Filter Kegiatan'),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15), // Set radius sudut untuk dialog
//         ),
//         content: Container(
//           width: 600, // Atur lebar kontainer jika diperlukan
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Gunakan PopupMenuButton untuk menampilkan opsi
//               PopupMenuButton<String>(
//                 onSelected: (String newValue) {
//                   setState(() {
//                     selectedFilter = newValue;
//                     Navigator.pop(context); // Close dialog after selecting filter
//                   });
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return <String>[
//                     'Semua',
//                     'Terdekat',
//                     'Lampau',
//                     'Diserahkan',
//                     'Belum',
//                     'Pending',
//                     'Diterima'
//                   ].map<PopupMenuItem<String>>((String value) {
//                     return PopupMenuItem<String>(
//                       value: value,
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30), // Padding untuk opsi
//                             child: Text(value),
//                           ),
//                           Divider(height: 1, color: Colors.grey), // Garis bawah
//                         ],
//                       ),
//                     );
//                   }).toList();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.grey[200], // Warna latar belakang dropdown
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(selectedFilter),
//                       Icon(Icons.arrow_drop_down),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// Widget _buildProgramTable() {
//   // Filter data berdasarkan query pencarian dan filter yang dipilih
//   final filteredData = programData.where((program) {
//     bool matchesSearch = program['Kegiatan']
//             .toLowerCase()
//             .contains(searchQuery) ||
//         (program['Anggota'] is List<String> &&
//             (program['Anggota'] as List<String>)
//                 .any((member) => member.toLowerCase().contains(searchQuery)));

//     // Logika filter
//     bool matchesFilter = true; // Default ke true

//     switch (selectedFilter) {
//       case 'Semua':
//         matchesFilter = true; // Tampilkan semua data
//         break;
//       case 'Diserahkan':
//         matchesFilter = program['Laporan'] == 'Diserahkan';
//         break;
//       case 'Belum':
//         matchesFilter = program['Laporan'] == 'Belum';
//         break;
//       case 'Pending':
//         matchesFilter = program['Laporan'] == 'Pending';
//         break;
//       case 'Diterima':
//         matchesFilter = program['Laporan'] == 'Diterima';
//         break;
//       case 'Terdekat':
//         matchesFilter = isDateTodayOrFuture(program['Tanggal Kegiatan']);
//         break;
//       case 'Lampau':
//         matchesFilter = !isDateTodayOrFuture(program['Tanggal Kegiatan']); // Kegiatan yang sudah berlalu
//         break;
//       default:
//         matchesFilter = true; // Tampilkan Semua data
//         break;
//     }

//     return matchesSearch && matchesFilter;
//   }).toList();

//   // Urutkan data berdasarkan tanggal kegiatan dari terbaru ke terlama
//   filteredData.sort((a, b) => parseDate(b['Tanggal Kegiatan'])
//       .compareTo(parseDate(a['Tanggal Kegiatan'])));

//   // Calculate the start and end indices for the current page
//   int startIndex = currentPage * itemsPerPage;
//   int endIndex = startIndex + itemsPerPage;

//   // Ensure endIndex does not exceed the total items
//   if (endIndex > filteredData.length) {
//     endIndex = filteredData.length;
//   }

//   // Inisialisasi _isExpandedList sesuai dengan jumlah filteredData
//   if (_isExpandedList.length != (endIndex - startIndex)) {
//     _isExpandedList = List<bool>.filled(endIndex - startIndex, false);
//   }

//   return ListView.builder(
//   physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
//   shrinkWrap: true, // Allow the ListView to take only the space it needs
//   itemCount: endIndex - startIndex,
//   itemBuilder: (context, index) {
//     final program = filteredData[startIndex + index]; // Access the correct program
//     bool isExpanded = _isExpandedList[index]; // Get the expansion state

//     return Card(
//       color: const Color.fromARGB(255, 222, 245, 255), // Set the background color to grey
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       elevation: 4, // Tambahkan shadow
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(
//               _isExpandedList[index] 
//                 ? program['Kegiatan'] // Tampilkan nama program lengkap saat diperluas
//                 : (program['Kegiatan'].length > 20 
//                     ? '${program['Kegiatan'].substring(0, 20)}...' 
//                     : program['Kegiatan']), // Tampilkan nama program dengan "..." jika lebih dari 20 karakter
//               style: TextStyle(
//                 fontSize: 18, // Increase font size
//                 fontWeight: FontWeight.bold, // Make font bold
//               ),
//             ),
//             subtitle: _buildDateWithBorder(program['Tanggal Kegiatan'], program['Laporan']),
//             trailing: Icon(
//               isExpanded ? Icons.expand_less : Icons.expand_more,
//               color: Colors.blue,
//             ),
//             onTap: () {
//               setState(() {
//                 _isExpandedList[index] = !_isExpandedList[index]; // Toggle the expansion state
//               });
//             },
//           ),
//           if (isExpanded) ...[
//             Container(
//               color: Colors.white, // Set the background color to white
//               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Role: ${program['Role']}'),
//                   SizedBox(height: 4),
//                   Text('Anggota: ${program['Anggota'].join(', ')}'),
//                   SizedBox(height: 4),
//                   Text('Laporan: ${program['Laporan']}'),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: _buildActionButtons(program),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   },
// );
// }
// Widget _buildDateWithBorder(String dateString, String status) {
//   DateTime activityDate = parseDate(dateString);
//   DateTime today = DateTime.now();
//   today = DateTime(today.year, today.month, today.day);

//   Color borderColor;

//   if (activityDate.isAfter(today) || activityDate.isAtSameMomentAs(today)) {
//     borderColor = Colors.green; // Future or today
//   } else {
//     if (status == 'Belum' || status == 'Pending') {
//       borderColor = Colors.red; // Past with 'Belum' or 'Pending'
//     } else {
//       borderColor = Colors.grey; // Past with 'Diserahkan' or 'Diterima'
//     }
//   }

//   return Align(
//     alignment: Alignment.centerLeft, // Position border to the left
//     child: Container(
//       width: 95, // Set the width of the border
//       decoration: BoxDecoration(
//         border: Border.all(color: borderColor, width: 2), // Set border thickness to 2
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(4.0), // Padding inside the border
//         child: Text(
//           dateString,
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Make text bold
//           textAlign: TextAlign.left, // Align text to the left
//         ),
//       ),
//     ),
//   );
// }
  
//   Widget _buildTable({
//     required List<String> headers,
//     required List<Map<String, dynamic>> data,
//     required List<String> keys,
//   }) {
//     // Add a new header for the serial number
//     List<String> updatedHeaders = ['No', ...headers];

//     return DataTable(
//       columns: updatedHeaders
//           .map((header) => DataColumn(
//                 label:
//                     Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
//               ))
//           .toList(),
//       rows: data.asMap().entries.map((entry) {
//         int index = entry.key; // Get the index of the current entry
//         Map<String, dynamic> row = entry.value; // Get the value (row data)

//         return DataRow(
//           cells: [
//             DataCell(Text((currentPage * itemsPerPage + index + 1)
//                 .toString())), // Serial number
//             ...keys.map((key) {
//               var value = row[key];
//               if (key == 'Anggota' && value is List<String>) {
//                 value = value.join(', ');
//               }
//               // Check if the key is 'Kegiatan' and apply the Text widget with wrapping
//               if (key == 'Kegiatan') {
//                 return DataCell(
//                   Container(
//                     constraints:
//                         BoxConstraints(maxWidth: 100), // Limit width to 200
//                     child: Text(
//                       value.toString(),
//                       maxLines: 3, // Allow up to 3 lines
//                       overflow: TextOverflow.visible, // Allow text to wrap
//                       style: TextStyle(fontSize: 14), // Optional: Set font size
//                     ),
//                   ),
//                 );
//               }
//               return DataCell(Text(value.toString()));
//             }).toList(),
//             DataCell(
//               Row(
//                 children: _buildActionButtons(row),
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

// List<Widget> _buildActionButtons(Map<String, dynamic> row) {
//   String status = row['Laporan'];
//   List<Widget> actionButtons = [];

//   List<Widget> icons = [];

//   if (status == 'Belum') {
//     icons.add(
//       Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.green,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.add, color: Colors.white),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LaporanKegiatan(),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   } else if (status == 'Diterima' || status == 'Pending' || status == 'Diserahkan') {
//     icons.add(
//       Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.remove_red_eye, color: Colors.white),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MelihatLaporanKegiatan(),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   if (status == 'Pending' || status == 'Diserahkan') {
//     icons.add(
//       Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.amber,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.edit, color: Colors.white),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditLaporanKegiatan(),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   if (icons.isNotEmpty) {
//     actionButtons.add(
//       Row(
//         mainAxisAlignment: MainAxisAlignment.end, // Pindahkan ke kanan
//         children: icons,
//       ),
//     );
//   }

//   return actionButtons;
// }  
 
//   Widget _buildPagination() {
//     // Filter data based on the search query and selected filter
//     final filteredData = programData.where((program) {
//       bool matchesSearch = program['Kegiatan']
//               .toLowerCase()
//               .contains(searchQuery) ||
//           (program['Anggota'] is List<String> &&
//               (program['Anggota'] as List<String>)
//                   .any((member) => member.toLowerCase().contains(searchQuery)));

//       // Logika filter
//       bool matchesFilter = true; // Default ke true

//       switch (selectedFilter) {
//         case 'Semua':
//         matchesFilter = true; // Tampilkan semua data
//         break;
//         case 'Diserahkan':
//           matchesFilter = program['Laporan'] == 'Diserahkan';
//           break;
//         case 'Belum':
//           matchesFilter = program['Laporan'] == 'Belum';
//           break;
//         case 'Pending':
//           matchesFilter = program['Laporan'] == 'Pending';
//           break;
//         case 'Diterima':
//           matchesFilter = program['Laporan'] == 'Diterima';
//           break;
//         case 'Terdekat':
//           matchesFilter = isDateTodayOrFuture(program['Tanggal Kegiatan']);
//           break;
//         case 'Lampau':
//           matchesFilter = !isDateTodayOrFuture(
//               program['Tanggal Kegiatan']); // Kegiatan yang sudah berlalu
//           break;
//         default:
//           matchesFilter = true; // Tampilkan Terdekat data
//           break;
//       }

//       return matchesSearch && matchesFilter;
//     }).toList();

//     final totalItems =
//         filteredData.length; // Get the total items from filtered data
//     final totalPages = (totalItems / itemsPerPage)
//         .ceil(); // Calculate total pages based on filtered data

//     // Adjust currentPage if it exceeds the total pages
//     if (currentPage >= totalPages) {
//       currentPage = totalPages > 0 ? totalPages - 1 : 0;
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               // Padding luar untuk memberikan jarak di sebelah kiri
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0), // Padding kiri 10
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey, width: 1), // Border
//                     borderRadius: BorderRadius.circular(6), // Radius sudut
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     // Menghilangkan garis bawah default
//                     child: DropdownButton<int>(
//                       value: itemsPerPage,
//                       onChanged: (value) {
//                         setState(() {
//                           itemsPerPage = value!;
//                           currentPage =
//                               0; // Reset current page when items per page changes
//                         });
//                       },
//                       items: itemsOptions.map((option) {
//                         return DropdownMenuItem<int>(
//                           value: option,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 10.0), // Padding kiri 10 pada opsi
//                             child: Text(
//                               '$option items',
//                               style: TextStyle(
//                                   fontWeight:
//                                       FontWeight.normal), // Pastikan tidak bold
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//               // Tombol navigasi ke halaman sebelumnya
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: currentPage > 0
//                     ? () {
//                         setState(() {
//                           currentPage--;
//                         });
//                       }
//                     : null,
//               ),
//               // Teks untuk menunjukkan halaman saat ini
//               Text('Page ${currentPage + 1} of $totalPages'),
//               // Tombol navigasi ke halaman berikutnya
//               IconButton(
//                 icon: Icon(Icons.arrow_forward),
//                 onPressed: currentPage < totalPages - 1
//                     ? () {
//                         setState(() {
//                           currentPage++;
//                         });
//                       }
//                     : null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
