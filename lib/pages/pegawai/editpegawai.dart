import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPegawaiModal extends StatefulWidget {
  final String initialCategory;
  final TextEditingController namaController;
  final TextEditingController nipController;
  final TextEditingController emailController;
  final TextEditingController alamatController;
  final TextEditingController tglLahirController;
  final String initialBidang;
  final List<String> bidangOptions;
  final Function(String) onCategoryChanged;
  final Function(String?) onBidangChanged;
  final Function(
      String, String, String, String, String, String, String?, String) onSubmit;

  EditPegawaiModal({
    required this.initialCategory,
    required this.namaController,
    required this.nipController,
    required this.emailController,
    required this.alamatController,
    required this.tglLahirController,
    required this.initialBidang,
    required this.bidangOptions,
    required this.onCategoryChanged,
    required this.onBidangChanged,
    required this.onSubmit,
  });

  @override
  _EditPegawaiModalState createState() => _EditPegawaiModalState();
}

class _EditPegawaiModalState extends State<EditPegawaiModal> {
  late ValueNotifier<String> _selectedCategoryNotifier;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController jabatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategoryNotifier = ValueNotifier(widget.initialCategory);
  }

  @override
  void dispose() {
    _selectedCategoryNotifier.dispose();
    jabatanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 8, bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Pilih Kategori:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: _selectedCategoryNotifier,
                          builder: (context, selectedCategory, child) {
                            return RadioListTile<String>(
                              title: const Text('ASN'),
                              value: 'ASN',
                              groupValue: selectedCategory,
                              onChanged: (value) {
                                _selectedCategoryNotifier.value = value!;
                                widget.onCategoryChanged(value);
                              },
                              activeColor: Colors.blueAccent,
                              visualDensity: VisualDensity.compact,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: _selectedCategoryNotifier,
                          builder: (context, selectedCategory, child) {
                            return RadioListTile<String>(
                              title: const Text('Non-ASN'),
                              value: 'Non-ASN',
                              groupValue: selectedCategory,
                              onChanged: (value) {
                                _selectedCategoryNotifier.value = value!;
                                widget.onCategoryChanged(value);
                              },
                              activeColor: Colors.blueAccent,
                              visualDensity: VisualDensity.compact,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildFormField(
                    label: 'Nama Pegawai',
                    controller: widget.namaController,
                    icon: Icons.person,
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: _selectedCategoryNotifier,
                    builder: (context, selectedCategory, child) {
                      if (selectedCategory == 'ASN') {
                        return _buildFormField(
                          label: 'NIP',
                          controller: widget.nipController,
                          icon: Icons.business,
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 16),
                  _buildStyledDropdownField(
                    label: 'Bidang',
                    value: widget.initialBidang,
                    items: widget.bidangOptions,
                    onChanged: widget.onBidangChanged,
                  ),
                  _buildFormField(
                    label: 'Jabatan',
                    controller: jabatanController,
                    icon: Icons.work,
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image.file(
                        File(_selectedImage!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  _buildFormField(
                    label: 'Email',
                    controller: widget.emailController,
                    icon: Icons.email,
                  ),
                  _buildFormField(
                    label: 'Alamat',
                    controller: widget.alamatController,
                    icon: Icons.location_on,
                  ),
                  _buildFormField(
                    label: 'Tanggal Lahir',
                    controller: widget.tglLahirController,
                    icon: Icons.calendar_today,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Foto Pegawai', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: Icon(Icons.upload_file),
                            label: Text('Upload'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                          if (_selectedImage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Image.file(
                                File(_selectedImage!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSubmitButton(),
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
                      'Edit Pegawai',
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
      ),
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

  Widget _buildStyledDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String bidang) {
          return DropdownMenuItem<String>(
            value: bidang,
            child: Text(bidang),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          widget.onSubmit(
            widget.namaController.text,
            widget.nipController.text,
            widget.emailController.text,
            widget.alamatController.text,
            widget.tglLahirController.text,
            jabatanController.text,
            _selectedImage?.path ?? '',
            widget.initialBidang,
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          minimumSize: Size(double.infinity, 0),
        ),
        child: Text(
          'Simpan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
