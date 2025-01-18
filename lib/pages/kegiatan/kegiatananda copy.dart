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

//     print("Activity Date: $activityDate, Today: $today"); // Debugging
//     return activityDate.isAfter(today) || activityDate.isAtSameMomentAs(today);
//   }

//   final ProgramController _programController = Get.put(ProgramController());
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
//       'Kegiatan': 'Kegiatan C',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '15-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Belum',
//     },
//     {
//       'Kegiatan': 'Kegiatan D',
//       'Role': 'Anggota',
//       'Tanggal Kegiatan': '12-11-2024',
//       'Anggota': ['Jhon'],
//       'Laporan': 'Pending',
//     },
//     {
//       'Kegiatan': 'Kegiatan E',
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
//       'Kegiatan': 'Kegiatan B',
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
//   //   _programController
//   //       .getTotalPrograms(); // Fetch programs when the page is initialized
//   //   _taskController
//   //       .getTotalTasks(); // Fetch programs when the page is initialized
//   // }

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
//       child: Container(
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
// child: Padding(
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

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Filter Kegiatan'),
//           content: DropdownButton<String>(
//             value: selectedFilter,
//             onChanged: (String? newValue) {
//               setState(() {
//                 selectedFilter = newValue!;
//                 Navigator.pop(context); // Close dialog after selecting filter
//               });
//             },
//             items: <String>[
//               'Semua',
//               'Lampau', // Adding Past category
//               'Diserahkan',
//               'Belum',
//               'Pending',
//               'Diterima'
//             ].map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildProgramTable() {
//     // Filter data berdasarkan query pencarian dan filter yang dipilih
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
//         case 'Semua':
//           matchesFilter = isDateTodayOrFuture(program['Tanggal Kegiatan']);
//           break;
//         case 'Lampau':
//           matchesFilter = !isDateTodayOrFuture(
//               program['Tanggal Kegiatan']); // Kegiatan yang sudah berlalu
//           break;
//         default:
//           matchesFilter = true; // Tampilkan semua data
//           break;
//       }

//       return matchesSearch && matchesFilter;
//     }).toList();

//     // Urutkan data berdasarkan tanggal kegiatan dari terbaru ke terlama
//     filteredData.sort((a, b) => parseDate(b['Tanggal Kegiatan'])
//         .compareTo(parseDate(a['Tanggal Kegiatan'])));

//     // Pindahkan logika pagination di sini
//     int startIndex = currentPage * itemsPerPage; // Change final to int
//     int endIndex = startIndex + itemsPerPage > filteredData.length
//         ? filteredData.length
//         : startIndex + itemsPerPage;

//     // Pastikan startIndex dan endIndex valid
//     if (startIndex >= filteredData.length) {
//       currentPage = (filteredData.length / itemsPerPage)
//           .floor(); // Reset ke halaman terakhir jika di luar batas
//       // Update startIndex dan endIndex setelah mengatur currentPage
//       startIndex = currentPage * itemsPerPage;
//       endIndex = startIndex + itemsPerPage > filteredData.length
//           ? filteredData.length
//           : startIndex + itemsPerPage;
//     }

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         constraints: BoxConstraints(maxHeight: 1300), // Batasi tinggi tabel
//         child: _buildTable(
//           headers: [
//             'Kegiatan',
//             'Role',
//             'Tanggal Kegiatan',
//             'Anggota',
//             'Laporan',
//             'Action'
//           ],
//           data: filteredData.sublist(startIndex, endIndex),
//           keys: ['Kegiatan', 'Role', 'Tanggal Kegiatan', 'Anggota', 'Laporan'],
//         ),
//       ),
//     );
//   }

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
//                         BoxConstraints(maxWidth: 200), // Limit width to 200
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
//     String status = row['Laporan'];
//     List<Widget> actionButtons = [];

//     if (status == 'Belum') {
//       actionButtons.add(
//         Padding(
//           padding:
//               const EdgeInsets.only(right: 10), // Menambahkan padding kanan
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.green, width: 2),
//             ),
//             alignment: Alignment.center,
//             child: IconButton(
//               icon: Icon(Icons.add, color: Colors.green),
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LaporanKegiatan(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       );
//     } else if (status == 'Diterima') {
//       actionButtons.add(
//         Padding(
//           padding:
//               const EdgeInsets.only(right: 10), // Menambahkan padding kanan
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             alignment: Alignment.center,
//             child: IconButton(
//               icon: Icon(Icons.remove_red_eye, color: Colors.blue),
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MelihatLaporanKegiatan(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       );
//     } else if (status == 'Pending') {
//       actionButtons.addAll([
//         Padding(
//           padding:
//               const EdgeInsets.only(right: 10), // Menambahkan padding kanan
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             alignment: Alignment.center,
//             child: IconButton(
//               icon: Icon(Icons.remove_red_eye, color: Colors.blue),
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MelihatLaporanKegiatan(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.amber, width: 2),
//           ),
//           alignment: Alignment.center,
//           child: IconButton(
//             icon: Icon(Icons.edit, color: Colors.amber),
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
//       ]);
//     } else if (status == 'Diserahkan') {
//       actionButtons.addAll([
//         Padding(
//           padding:
//               const EdgeInsets.only(right: 10), // Menambahkan padding kanan
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             alignment: Alignment.center,
//             child: IconButton(
//               icon: Icon(Icons.remove_red_eye, color: Colors.blue),
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MelihatLaporanKegiatan(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.amber, width: 2),
//           ),
//           alignment: Alignment.center,
//           child: IconButton(
//             icon: Icon(Icons.edit, color: Colors.amber),
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
//       ]);
//     }

//     return actionButtons;
//   }

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
//         case 'Semua':
//           matchesFilter = isDateTodayOrFuture(program['Tanggal Kegiatan']);
//           break;
//         case 'Lampau':
//           matchesFilter = !isDateTodayOrFuture(
//               program['Tanggal Kegiatan']); // Kegiatan yang sudah berlalu
//           break;
//         default:
//           matchesFilter = true; // Tampilkan semua data
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
