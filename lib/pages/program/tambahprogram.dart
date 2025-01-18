import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:Monitoring/controllers/program_controller.dart';
import 'package:Monitoring/controllers/sector_controller.dart';
import 'package:Monitoring/models/sector_model.dart';
import 'package:get/get.dart';

class TambahProgramForm extends StatefulWidget {
  const TambahProgramForm({
    super.key,
    required this.sectors,
  });

  final Rx<List<SectorModel>> sectors;
  // final Function(String, String, String, String, String, String) onSubmit;

  // const TambahProgramForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _TambahProgramFormState createState() => _TambahProgramFormState();
}

class _TambahProgramFormState extends State<TambahProgramForm> {
  final _namaController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalBerakhirController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _kepalaBidangController = TextEditingController();

  final ProgramController _programController = Get.put(ProgramController());
  final SectorController _sectorController = Get.put(SectorController());

  // @override
  // void initState() {
  //   _programController.getAllSector();
  //   super.initState();
  // }

  String? _selectedBidang;
  String _kepalaBidang = '';

  final List<Map<String, String>> _bidangOptions = [
    {'name': 'Bidang A', 'kepala': 'Kepala A'},
    {'name': 'Bidang B', 'kepala': 'Kepala B'},
    {'name': 'Bidang C', 'kepala': 'Kepala C'},
  ];

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
            colorScheme: const ColorScheme.light(
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
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
                          label: 'Program',
                          controller: _namaController,
                          icon: Icons.business,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Bidang',
                        ),
                        const SizedBox(height: 16),
                        _buildKepalaBidangField(),
                        const SizedBox(height: 16),
                        _buildDateField(
                          label: 'Tanggal Mulai',
                          controller: _tanggalMulaiController,
                        ),
                        const SizedBox(height: 16),
                        _buildDateField(
                          label: 'Tanggal Berakhir',
                          controller: _tanggalBerakhirController,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'Deskripsi',
                          controller: _deskripsiController,
                          icon: Icons.task_sharp,
                        ),
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
                    'Tambah Program',
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
                    onPressed: () => Navigator.pop(context, true),
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
            }
            return DropdownButtonFormField<String>(
              value: _selectedBidang,
              onChanged: (value) {
                setState(() {
                  _selectedBidang = value;
                  // Mencari sektor yang sesuai dengan ID dan mengambil supervisor
                  final selectedSector = _sectorController.sectors.value
                      .firstWhere((element) => element.id.toString() == value);
                  _kepalaBidang = selectedSector.users?.name ??
                      'Tidak ada kepala bidang';
                  _kepalaBidangController.text =
                      selectedSector.id!; // Menyimpan nama kepala bidang
                });
              },
              items: _sectorController.sectors.value.map((option) {
                return DropdownMenuItem<String>(
                  value: option.id.toString(),
                  child: Text(option.name ??
                      'Unknown'), // Pastikan nama sektor tersedia
                );
              }).toList(),
            );
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
          padding: const EdgeInsets.only(left: 4, bottom: 8),
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            controller: TextEditingController(text: _kepalaBidang),
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
          padding: const EdgeInsets.only(left: 4, bottom: 8),
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        //   //   _programController.text,
        //   //   _selectedBidang ?? '',
        //   //   _tanggalMulaiController.text,
        //   //   _tanggalBerakhirController.text,
        //   //   _deskripsiController.text,
        //   //   '0/0',
        //   // );
        // },
        onPressed: () async {
          await _programController.createProgram(
            _kepalaBidangController.text.trim(),
            _namaController.text.trim(),
            _deskripsiController.text.trim(),
            _tanggalMulaiController.text.trim(),
            _tanggalBerakhirController.text.trim(),
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
    _namaController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalBerakhirController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}

// class MySlidingUpPanel extends StatelessWidget {
//   final PanelController panelController = PanelController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SlidingUpPanel(
//         controller: panelController,
//         maxHeight: MediaQuery.of(context).size.height * 0.9,
//         minHeight: 50,
//         backdropEnabled: true,
//         backdropColor: Colors.black,
//         backdropOpacity: 0.5,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         panel: SingleChildScrollView(
//           child: TambahProgramForm(
//               // onSubmit: (program, role, mulai, berakhir, deskripsi, progres) {
//               //   print('Form submitted: $program, $role');
//               // },
//               ),
//         ),
//         body: const Center(
//           child: Text('Main Content'),
//         ),
//       ),
//     );
//   }
// }
