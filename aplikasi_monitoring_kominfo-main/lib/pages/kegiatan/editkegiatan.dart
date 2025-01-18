import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:Monitoring/controllers/task_controller.dart';
import 'package:Monitoring/models/task_model.dart';
import 'package:Monitoring/models/team_model.dart';
import 'package:intl/intl.dart';

class EditKegiatanPage extends StatefulWidget {
  const EditKegiatanPage({
    super.key,
    required this.programId,
    required this.programTeam,
    required this.task,
  });

  final TaskModel task;
  final String programId;
  final List<TeamModel> programTeam;

  @override
  _EditKegiatanPageState createState() => _EditKegiatanPageState();
}

class _EditKegiatanPageState extends State<EditKegiatanPage> {
  final TaskController _taskController = TaskController();
  final TextEditingController kegiatanController = TextEditingController();
  final TextEditingController tanggalKegiatanController =
      TextEditingController();
  final TextEditingController jamKegiatanController = TextEditingController();
  final TextEditingController koordinatorController = TextEditingController();
  final TextEditingController penyelenggaraController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  String lokasiOption = '';
  List<TeamModel> selectedAnggota = []; // Initialize to an empty list
  String? uploadedFilePath;

  @override
  initState() {
    super.initState();
    kegiatanController.text = widget.task.name!;
    deskripsiController.text = widget.task.description!;
    lokasiController.text = widget.task.location!;
    tanggalKegiatanController.text =
        DateFormat('dd-MM-yyyy').format(widget.task.date!);
    jamKegiatanController.text = DateFormat('HH:mm').format(widget.task.time!);
    penyelenggaraController.text = widget.task.host!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormField(
                            label: 'Nama Kegiatan',
                            controller: kegiatanController,
                            icon: Icons.event,
                            hintText: 'Input Nama Kegiatan'),
                        const SizedBox(height: 16),
                        _buildDatePickerField(),
                        const SizedBox(height: 16),
                        _buildTimePickerField(),
                        const SizedBox(height: 16),
                        _buildFormField(
                            label: 'Penyelenggara',
                            controller: penyelenggaraController,
                            icon: Icons.assessment,
                            hintText: 'Input Penyelenggara Kegiatan'),
                        const SizedBox(height: 16),
                        _buildLocationField(),
                        const SizedBox(height: 16),
                        _buildKoordinatorDropdown(), // Ganti dengan dropdown
                        const SizedBox(height: 16),
                        _buildMultiSelectField(),
                        const SizedBox(height: 16),
                        _buildFormField(
                            label: 'Deskripsi',
                            controller: deskripsiController,
                            icon: Icons.event,
                            hintText: 'Input Deskripsi Kegiatan'),
                        const SizedBox(height: 16),
                        _buildFileUploadButton(),
                        const SizedBox(height: 24),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -70,
          left: 20,
          right: 20,
          child: Container(
            height: 50,
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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Edit Kegiatan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Tanggal',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                tanggalKegiatanController.text = "${pickedDate.toLocal()}"
                    .split(' ')[0]; // Format the date as needed
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggalKegiatanController.text.isNotEmpty
                      ? tanggalKegiatanController.text
                      : 'Pilih Tanggal Kegiatan',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Waktu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialEntryMode: TimePickerEntryMode.input,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (pickedTime != null) {
              setState(() {
                jamKegiatanController.text =
                    '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jamKegiatanController.text.isNotEmpty
                      ? jamKegiatanController.text
                      : 'Pilih Waktu Kegiatan',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Icon(Icons.access_time, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKoordinatorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Koordinator',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: koordinatorController.text.isNotEmpty
                ? koordinatorController.text
                : null,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                'Pilih Koordinator',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            items: widget.programTeam.map((anggota) {
              return DropdownMenuItem<String>(
                value: anggota.id,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text(
                    anggota.name.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                koordinatorController.text = newValue ?? '';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Perbaikan di sini
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Icon(icon, color: Colors.grey[400]),
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Anggota',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final List<TeamModel>? selected = await showDialog<List<TeamModel>>(
              context: context,
              builder: (BuildContext context) {
                return MultiSelectDialog(
                  anggotaList: widget.programTeam,
                  selectedAnggota: selectedAnggota,
                );
              },
            );
            if (selected != null) {
              setState(() {
                selectedAnggota = selected;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: selectedAnggota.isNotEmpty
                  ? selectedAnggota.map((anggota) {
                      return Card(
                        child: ListTile(
                          title: Text(anggota.name!),
                          trailing: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[600]),
                            onPressed: () {
                              setState(() {
                                selectedAnggota.remove(anggota);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      Text('Pilih Anggota',
                          style: TextStyle(color: Colors.grey[600]))
                    ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Lokasi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'Dalam Kota',
              groupValue: lokasiOption,
              onChanged: (value) {
                setState(() {
                  lokasiOption = value as String;
                });
              },
            ),
            const Text('Dalam Kota'),
            const SizedBox(width: 20),
            Radio(
              value: 'Luar Kota',
              groupValue: lokasiOption,
              onChanged: (value) {
                setState(() {
                  lokasiOption = value as String;
                  lokasiController.text = 'Luar Kota';
                });
              },
            ),
            const Text('Luar Kota'),
          ],
        ),
        lokasiOption == 'Dalam Kota'
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: lokasiController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    suffixIcon:
                        Icon(Icons.location_on, color: Colors.grey[400]),
                    hintText: 'Input Lokasi Kegiatan',
                    hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildFileUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.isNotEmpty) {
              setState(() {
                uploadedFilePath = result.files.first.path;
              });
            }
          },
          child: const Text('Upload File'),
        ),
        if (uploadedFilePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Uploaded File: $uploadedFilePath',
              style: TextStyle(color: Colors.grey[600]), // Perbaikan di sini
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final inputFormat = DateFormat('dd-MM-yyyy'); // Format input
          final outputFormat = DateFormat('yyyy-MM-dd'); // Format output

          // Parse dan format tanggal mulai dan tanggal berakhir
          final tanggalKegiatan = outputFormat
              .format(inputFormat.parse(tanggalKegiatanController.text.trim()));

          await _taskController.updateTask(
            widget.task.id,
            widget.programId,
            kegiatanController.text.trim(),
            deskripsiController.text.trim(),
            lokasiController.text.trim(),
            tanggalKegiatan,
            jamKegiatanController.text.trim(),
            penyelenggaraController.text.trim(),
            uploadedFilePath
          );
          
          Navigator.pop(context, true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    kegiatanController.dispose();
    tanggalKegiatanController.dispose();
    jamKegiatanController.dispose();
    koordinatorController.dispose();
    penyelenggaraController.dispose();
    lokasiController.dispose();
    super.dispose();
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<TeamModel> anggotaList;
  final List<TeamModel> selectedAnggota;

  MultiSelectDialog({required this.anggotaList, required this.selectedAnggota});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<TeamModel> selectedItems;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.selectedAnggota);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pilih Anggota'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Anggota',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 10),
            ListBody(
              children: widget.anggotaList
                  .where((anggota) =>
                      anggota.name!.toLowerCase().contains(searchQuery))
                  .map((anggota) {
                return CheckboxListTile(
                  title: Text(anggota.name!),
                  value: selectedItems.contains(anggota),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedItems.add(anggota);
                      } else {
                        selectedItems.remove(anggota);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Mengatur jarak antara tombol
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Menutup dialog tanpa mengembalikan nilai
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Background merah
                side: BorderSide(color: Colors.red), // Border merah
                foregroundColor: Colors.white, // Font putih
              ),
              child: const Text('Cancel'), // Tombol Cancel
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedItems); // Mengembalikan nilai yang dipilih
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Background biru muda
                foregroundColor: Colors.white, // Font putih
              ),
              child: const Text('OK'), // Tombol OK
            ),
          ],
        ),
      ],
    );
  }
}
