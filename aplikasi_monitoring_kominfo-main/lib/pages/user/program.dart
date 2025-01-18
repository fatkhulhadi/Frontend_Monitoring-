import 'package:flutter/material.dart';
import 'package:Monitoring/pages/program/editprogram.dart';
import 'package:Monitoring/pages/program/detailprogram.dart';
import 'package:Monitoring/pages/header.dart';
import 'package:get/get.dart';
import 'package:Monitoring/controllers/program_controller.dart';
import 'package:Monitoring/models/program_model.dart';
import 'package:intl/intl.dart';

class ProgramScreen extends StatefulWidget {
  @override
  _ProgramScreenState createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final ProgramController _programController = Get.put(ProgramController());
  List<bool> _isExpandedList = [];

  String searchQuery = '';
  int currentPage = 0;
  int itemsPerPage = 10; // Default items per page
  final List<int> itemsOptions = [5, 10, 20]; // Options for items per page

  @override
  void initState() {
    super.initState();
    _programController.getAllProgram();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreen(),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  _buildSearchAndTableCard(_programController.programs.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update this method to not require a parameter
  Widget _buildSearchAndTableCard(List<ProgramModel> data) {
    // Filter the program data based on the search query
    final filteredData = data.where((program) {
      return program.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
    print(
        "Filtered Data 2 : ${filteredData.map((program) => 'ID: ${program.id}, Name: ${program.name}')}");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: 10),
              _buildSearchField(),
              SizedBox(height: 20),
              RefreshIndicator(onRefresh: () async {
                await _programController.getAllProgram(); // Refresh posts
              }, child: Obx(() {
                if (_programController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
//                 return Expanded(
//                     child: SingleChildScrollView(
//                         child: _buildSearchAndTableCard(
//                             _programController.programs.value)));
//               }
                  return Column(
                    children: [
                      _buildDataTable(_programController.programs.value),
                      SizedBox(height: 16),
                      _buildPagination(_programController.programs.value)
                    ],
                  ); // Pass filtered data here
                }
              })),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Program Anda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Program',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDataTable(List<ProgramModel> data) {
    // Filter the data based on the search query
    final filteredData = data.where((program) {
      return program.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Resize the expansion state list if necessary
    if (_isExpandedList.length < filteredData.length) {
      _isExpandedList = List<bool>.filled(filteredData.length, false);
    }

    return Column(
      children: [
        // Container(
        //   child: ElevatedButton(
        //       onPressed: () {
        //         print('filtered data : $filteredData');
        //         // print(_taskController.tasks.value);
        //         // print(task);
        //         // print('=============');
        //         // print('start index $startIndex');
        //         // print('end index $endIndex');
        //       },
        //       child: Text('debug')),
        // ),
       
        ListView.builder(
          physics:
              NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
          shrinkWrap:
              true, // Allow the ListView to take only the space it needs
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final program = filteredData[index];

            return Card(
              color: const Color.fromARGB(
                  255, 222, 245, 255), // Set the background color to grey
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      _isExpandedList[index]
                          ? program
                              .name! // Tampilkan nama program lengkap saat diperluas
                          : (program.name!.length > 20
                              ? '${program.name!.substring(0, 20)}...'
                              : program
                                  .name!), // Tampilkan nama program dengan "..." jika lebih dari 20 karakter
                      style: TextStyle(
                        fontSize: 18, // Increase font size
                        fontWeight: FontWeight.bold, // Make font bold
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        // Start Date with green background and white text
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green, width: 2), // Border color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          padding: EdgeInsets.all(
                              4.0), // Padding inside the container
                          margin: EdgeInsets.only(
                              right: 4.0), // Margin to the right
                          child: Text(
                            '${DateFormat('dd-MM-yyyy').format(program.startDate!)}', // tanggal mulai
                            style: TextStyle(
                              color: Colors.green, // Text color
                              fontWeight: FontWeight.bold, // Make font bold
                            ),
                          ),
                        ),
                        // End Date with red background and white text
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.red, width: 2), // Border color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          padding: EdgeInsets.all(
                              4.0), // Padding inside the container
                          child: Text(
                            '${DateFormat('dd-MM-yyyy').format(program.endDate!)}',
                            style: TextStyle(
                              color: Colors.red, // Text color
                              fontWeight: FontWeight.bold, // Make font bold
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      _isExpandedList[index]
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        _isExpandedList[index] = !_isExpandedList[
                            index]; // Toggle the expansion state
                      });
                    },
                  ),
                  if (_isExpandedList[index]) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Warna putih untuk konten yang terexpand
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Koordinator: ${program.coordinator?.name ?? 'No Coordinator'}'),
                          SizedBox(height: 8),
                          Text(
                              'Progres: ${program.completedTasks}/${program.totalTasks}'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildCircularIconButton(Icons.info, Colors.blue,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProgram(
                                      program: program,
                                      sector: program.sector!.id.toString(),
                                      programId: program.id!.toString(),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircularIconButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Atur posisi ke sebelah kanan
      children: [
        Container(
          margin:
              EdgeInsets.only(right: 8), // Tambahkan margin di sebelah kanan
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Bentuk lingkaran
            color: color, // Background warna sesuai dengan parameter color
          ),
          child: IconButton(
            icon: Icon(icon,
                color: Colors.white,
                size: 24), // Ukuran icon dengan warna putih
            onPressed: onPressed,
            padding: EdgeInsets.all(0), // Padding di dalam button
            constraints: BoxConstraints.tight(Size(24, 24)), // Ukuran button
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(List<ProgramModel> data) {
    final filteredData = data.where((program) {
      return program.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final totalItems = filteredData.length;
    final totalPages = (totalItems / itemsPerPage).ceil();

    if (currentPage >= totalPages) {
      currentPage = totalPages > 0 ? totalPages - 1 : 0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: itemsPerPage,
                      onChanged: (value) {
                        setState(() {
                          itemsPerPage = value!;
                          currentPage = 0;
                        });
                      },
                      items: itemsOptions.map((option) {
                        return DropdownMenuItem<int>(
                          value: option,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              '$option items',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () {
                        setState(() {
                          currentPage--;
                        });
                      }
                    : null,
              ),
              Text('Page ${currentPage + 1} dari $totalPages'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages - 1
                    ? () {
                        setState(() {
                          currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_showDeleteConfirmationDialog(
    BuildContext context, int index, String programId) {
  ProgramController _programController = ProgramController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content:
            Text("Apakah Anda yakin ingin menghapus Anggota kegiatan ini?"),
        actions: <Widget>[
          TextButton(
            child: Text("Tidak"),
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
          ),
          TextButton(
              child: Text("Ya"),
              onPressed: () async {
                await _programController.deleteProgram(programId);
                await _programController.getAllProgram();
                Navigator.of(context).pop(true); // Tutup dialog
              }),
        ],
      );
    },
  );
}
