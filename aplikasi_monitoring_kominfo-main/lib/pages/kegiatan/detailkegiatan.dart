import 'package:flutter/material.dart';
import 'package:Monitoring/pages/headerdetail.dart';
import 'package:Monitoring/pages/kegiatan/editkegiatan.dart';
import 'package:Monitoring/pages/kegiatan/melihatlaporan.dart';
import 'package:Monitoring/pages/pegawai/tambahanggotaket.dart';
import 'package:Monitoring/pages/kegiatan/pdfkegiatan.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Monitoring/controllers/task_controller.dart';
import 'package:Monitoring/models/task_model.dart';
import 'package:Monitoring/models/team_model.dart';
import 'package:intl/intl.dart';
import 'package:Monitoring/widget/refreshable_gadget.dart';

class DetailKegiatan extends StatefulWidget {
  const DetailKegiatan({
    super.key,
    required this.task,
    required this.programId,
    required this.programTeam,
  });

  final String programId;
  final List<TeamModel> programTeam;
  final TaskModel task;
  // final String task;
  @override
  _DetailKegiatanState createState() => _DetailKegiatanState();
}

class _DetailKegiatanState extends State<DetailKegiatan> {
  final PanelController _editTeamPanelController = PanelController();
  final TaskController _taskController = TaskController();
  String? _selectedRole;
  Map<String, String>? _currentMember;

  final List<Map<String, String>> programData = [
    {
      'Nomor': '1',
      'Kegiatan': 'Memperbaiki CCTV',
      'Role': 'Pegawai',
      'Tanggal Kegiatan': '01-01-2024',
      'Koordinator': 'John Doe',
      'Progres': '2/3',
      'Anggota': 'Anton',
      'Laporan': 'Diterima',
    },
    {
      'Nomor': '2',
      'Kegiatan': 'Membuat Website',
      'Role': 'Pegawai',
      'Tanggal Kegiatan': '02-01-2024',
      'Koordinator': 'Jane Doe',
      'Progres': '1/3',
      'Anggota': 'Budi',
      'Laporan': 'Pending',
    },
    {
      'Nomor': '3',
      'Kegiatan': 'Membuat Website',
      'Role': 'Pegawai',
      'Tanggal Kegiatan': '02-01-2024',
      'Koordinator': 'Anton',
      'Progres': '1/3',
      'Anggota': 'Doni',
      'Laporan': 'Belum',
    },
    {
      'Nomor': '4',
      'Kegiatan': 'Membuat Website',
      'Role': 'Pegawai',
      'Tanggal Kegiatan': '02-01-2024',
      'Koordinator': 'Anton',
      'Progres': '1/3',
      'Anggota': 'Dono',
      'Laporan': 'Diserahkan',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTaskById(widget.task.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreenDetail(),
          Expanded(
            child: Stack(
              children: [
                SlidingUpPanel(
                  controller: _editTeamPanelController,
                  minHeight: 0,
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                  body: RefreshableWidget(
                      onRefresh: () async {
                        await _taskController.getTaskById(widget.task.id!);
                      },
                      isLoading: _taskController.isLoadingGetTaskById,
                      child: Obx(() {
                        if (_taskController.tasks2.value.isEmpty) {
                          return _buildMainContent(
                              widget.task, widget.programTeam
                              // _taskController.tasks2.value.first
                              );
                        }

                        return _buildMainContent(
                            // widget.task
                            _taskController.tasks2.value.first,
                            _taskController.taskTeam.value);
                      })),
                  panel: _buildEditTeamPanel(),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isPanelOpen = false;

  Widget _buildEditTeamPanel() {
    if (_currentMember == null) return Container();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20), // Untuk memberikan ruang di atas
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.grey[200],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama: ${_currentMember!['Anggota']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            hint: Text("Pilih Role"),
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: <String>['Pegawai', 'Koordinator']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentMember != null && _selectedRole != null) {
                        _currentMember!['Role'] = _selectedRole!;
                      }
                      _editTeamPanelController.close();
                    },
                    child: Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Warna tulisan
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Warna latar belakang tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -60,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Anggota Kegiatan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _editTeamPanelController.close();
                          setState(() {
                            _isPanelOpen = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(TaskModel task, List<TeamModel> team) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: RefreshableWidget(
                          onRefresh: () async {
                            await _taskController.getTaskById(widget.task.id!);
                          },
                          isLoading: _taskController.isLoadingGetTaskById,
                          child: Text(
                            widget.task.name!,
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              _showDeleteConfirmationDeleteKegiatan(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildDetailKegiatanCard(task),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTimKegiatan(team),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDokumenKegiatanCard(context),
          ),
          SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );
  }

  void _showDeleteConfirmationKegiatan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus kegiatan ini?"),
          actions: <Widget>[
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () {
                // Lakukan aksi penghapusan di sini
                // Misalnya, hapus kegiatan dari daftar atau lakukan aksi lain
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDokumenKegiatanCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dokumen Kegiatan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LihatDokumen(
                                    assetPath: 'assets/1.pdf',
                                    downloadUrl:
                                        'https:/example.com/path/to/asset/1.pdf',
                                        downloadUrl2: _taskController.tasks2.value.first.file!
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Kegiatan: ${programData.length}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Lihat Selengkapnya"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailKegiatanCard(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
          child: RefreshableWidget(
              onRefresh: () async {
                await _taskController.getTaskById(widget.task.id!);
              },
              isLoading: _taskController.isLoadingGetTaskById,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Detail Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  _buildDetailRow(Icons.event, "Nama Kegiatan:", task.name!,
                      Colors.purple, Colors.purple[100]!),
                  SizedBox(height: 15),
                  _buildDetailRow(
                      Icons.calendar_today,
                      "Tanggal Kegiatan:",
                      DateFormat('dd-MM-yyyy').format(task.date!),
                      Colors.green,
                      Colors.green[100]!),

                  SizedBox(height: 15),

                  _buildDetailRow(
                      Icons.access_time,
                      "Waktu Kegiatan:",
                      task.time != null
                          ? DateFormat('HH:mm').format(task.time!)
                          : 'Waktu Belum Ditentukan',
                      Colors.blue,
                      Colors.blue[100]!),
                  SizedBox(height: 15),
                  _buildDetailRow(Icons.location_on, "Tempat:", task.location!,
                      Colors.lightBlue, Colors.lightBlue[100]!),
                  SizedBox(height: 15),
                  _buildDetailRow(Icons.description, "Deskripsi:",
                      task.description!, Colors.grey, Colors.grey[100]!),
                  SizedBox(height: 20),

                  // Tambahkan tombol Lihat Laporan
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MelihatLaporanKegiatan(
                              taskId: widget.task.id!,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.visibility),
                      label: Text('Lihat Laporan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      Color borderColor, Color backgroundColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, size: 20),
        ),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ' $value',
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimKegiatan(List<TeamModel> team) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Anggota Kegiatan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahAnggotaKegiatan(
                          users: widget.programTeam,
                          taskId: widget.task.id!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text("No.",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Nama Anggota",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    // DataColumn(
                    //     label: Text("Role",
                    //         style: TextStyle(fontWeight: FontWeight.bold))),
                    // DataColumn(
                    //     label: Text("Status",
                    //         style: TextStyle(fontWeight: FontWeight.bold))),
                    // DataColumn(
                    //     label: Text("Pelaporan",
                    //         style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Aksi",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: team.asMap().entries.map((entry) {
                    final index = entry.key + 1; // Start from 1
                    final member = entry.value;
                    {
                      
                      return DataRow(
                        cells: [
                          DataCell(Text((index).toString())),
                          DataCell(
                              Text(member.name! ?? 'Unknown')),
                          // DataCell(
                          //     Text(member.pivot!.role! ?? 'Pegawai')),
                          // DataCell(
                          //   Container(
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 10, vertical: 5),
                          //     decoration: BoxDecoration(
                          //       color: _getStatusColor(
                          //           programData[index]['Laporan'] ?? 'Belum'),
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Text(
                          //       programData[index]['Laporan'] ?? 'Belum',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                          // DataCell(
                          //   Container(
                          //     width: 40,
                          //     height: 40,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       border: Border.all(
                          //         color: Colors.blue,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     alignment: Alignment.center,
                          //     child: IconButton(
                          //       icon: Icon(Icons.visibility, color: Colors.blue),
                          //       padding: EdgeInsets.zero,
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 MelihatLaporanKegiatan(
                          //               taskId: widget.task.id!,
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //   width: 40,
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //       color: Colors.orange,
                                //       width: 2,
                                //     ),
                                //   ),
                                //   alignment: Alignment.center,
                                //   child: IconButton(
                                //     icon: Icon(Icons.edit, color: Colors.orange),
                                //     padding: EdgeInsets.zero,
                                //     onPressed: () {
                                //       setState(() {
                                //         _currentMember = programData[index];
                                //         _selectedRole =
                                //             programData[index]['Role'];
                                //       });
                                //       _editTeamPanelController.open();
                                //     },
                                //   ),
                                // ),
                                // SizedBox(width: 10),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: Icon(Icons.delete_forever,
                                        color: Colors.red),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDeleteKegiatan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus program ini?"),
          actions: <Widget>[
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () {
                // Add your delete logic here
                // For example, you might call a method to delete the program
                // _programController.deleteProgram(widget.programId);

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
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
              onPressed: () {
                setState(() {
                  programData.removeAt(index); // Menghapus kegiatan dari daftar
                });
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Diterima":
        return Colors.green.withOpacity(0.7);
      case "Pending":
        return Colors.orange.withOpacity(0.7);
      case "Diserahkan":
        return Colors.blue.withOpacity(0.7);
      case "Belum":
        return Colors.red.withOpacity(0.7);
      default:
        return Colors.transparent;
    }
  }
}

Future<void> _downloadFile(String url) async {
  try {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    await dio.download(url, "${dir.path}/file.pdf");
    print("File downloaded to ${dir.path}/file.pdf");
  } catch (e) {
    print("Error downloading file: $e");
  }
}
