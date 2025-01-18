import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:Monitoring/controllers/program_controller.dart';
import 'package:Monitoring/controllers/sector_controller.dart';
import 'package:Monitoring/models/program_model.dart';
import 'package:Monitoring/models/sector_model.dart';
import 'package:intl/intl.dart';

class EditProgram extends StatefulWidget {
  const EditProgram({
    super.key,
    required this.program,
    required this.sectors,
  });

  final ProgramModel program;
  final Rx<List<SectorModel>> sectors;

  // final Function(String, String, String, String, String, String) onSubmit;

  // const EditProgram({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _EditProgramState createState() => _EditProgramState();
}

class _EditProgramState extends State<EditProgram> {
  final _namaController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalBerakhirController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _bidangController = TextEditingController();
  final _kepalaBidangController = TextEditingController();

  final ProgramController _programController = Get.put(ProgramController());
  final SectorController _sectorController = Get.put(SectorController());

  String? _selectedBidang;
  String _kepalaBidang = '';

  // final List<Map<String, String>> _bidangOptions = [
  //   {'name': 'Bidang A', 'kepala': 'Kepala A'},
  //   {'name': 'Bidang B', 'kepala': 'Kepala B'},
  //   {'name': 'Bidang C', 'kepala': 'Kepala C'},
  // ];

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with values from the program object
    _namaController.text = widget.program.name.toString();
    _tanggalMulaiController.text =
        DateFormat('dd-MM-yyyy').format(widget.program.startDate!);
    _tanggalBerakhirController.text =
        DateFormat('dd-MM-yyyy').format(widget.program.endDate!);
    _deskripsiController.text = widget.program.description.toString();
    // _selectedBidang = widget.program.sector?.id;
    _bidangController.text = widget.program.sector!.id.toString();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormField(
                          label: 'Program',
                          controller: _namaController,
                          icon: Icons.business,
                        ),
                        SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Bidang',
                        ),
                        SizedBox(height: 16),
                        _buildKepalaBidangField(),
                        SizedBox(height: 16),
                        _buildDateField(
                          label: 'Tanggal Mulai',
                          controller: _tanggalMulaiController,
                        ),
                        SizedBox(height: 16),
                        _buildDateField(
                          label: 'Tanggal Berakhir',
                          controller: _tanggalBerakhirController,
                        ),
                        SizedBox(height: 16),
                        _buildFormField(
                          label: 'Deskripsi',
                          controller: _deskripsiController,
                          icon: Icons.supervisor_account,
                        ),
                        SizedBox(height: 24),
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
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Edit Program',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Icon(icon, color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Obx(() {
            // Pastikan _programController.sectors.value sudah terisi data
            if (_sectorController.sectors.value.isEmpty) {
              return const CircularProgressIndicator(); // Menampilkan loading jika data belum ada
            } else {
              _selectedBidang = widget.program.sector!.id.toString();
              final selectedSector = _sectorController.sectors.value.firstWhere(
                  (element) => element.id.toString() == _selectedBidang);
              print(selectedSector.name);
              _kepalaBidangController.text =
                  selectedSector.users!.name ?? 'Tidak ada kepala bidang';
              print(_kepalaBidangController.text);
              return DropdownButtonFormField<String>(
                value: _selectedBidang,
                onChanged: (value) {
                  setState(() {
                    _selectedBidang = value;
                    // Mencari sektor yang sesuai dengan ID dan mengambil supervisor
                    final selectedSector = _sectorController.sectors.value
                        .firstWhere(
                            (element) => element.id.toString() == value);
                    _kepalaBidangController.text =
                        selectedSector.users?.name ??
                            'Tidak ada kepala bidang';
                    _bidangController.text = selectedSector.id!
                        .toString(); // Menyimpan nama kepala bidang
                    print(_bidangController.text);
                    // print(_selectedBidang);
                    // print(selectedSector.id);
                  });
                },
                items: widget.sectors.value.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.id.toString(),
                    child: Text(option.name ??
                        'Unknown'), // Pastikan nama sektor tersedia
                  );
                }).toList(),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildKepalaBidangField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Kepala Bidang',
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
            enabled: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            controller: _kepalaBidangController,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
        InkWell(
          onTap: () => _selectDate(context, controller),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey[400]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // onPressed: () {
        //   // widget.onSubmit(
        //   // //   _programController.text,
        //   // //   _selectedBidang ?? '',
        //   // //   _tanggalMulaiController.text,
        //   // //   _tanggalBerakhirController.text,
        //   // //   _deskripsiController.text,
        //   // //   '0/0',
        //   // // );

        // },
        onPressed: () async {
          final inputFormat = DateFormat('dd-MM-yyyy'); // Format input
          final outputFormat = DateFormat('yyyy-MM-dd'); // Format output

          // Parse dan format tanggal mulai dan tanggal berakhir
          final tanggalMulai = outputFormat
              .format(inputFormat.parse(_tanggalMulaiController.text.trim()));
          final tanggalBerakhir = outputFormat.format(
              inputFormat.parse(_tanggalBerakhirController.text.trim()));

          await _programController.updateProgram(
            widget.program.id.toString(),
            _bidangController.text.trim(),
            _namaController.text.trim(),
            _deskripsiController.text.trim(),
            tanggalMulai,
            tanggalBerakhir,
          );
          Navigator.pop(context, true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Simpan',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _programController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalBerakhirController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}
