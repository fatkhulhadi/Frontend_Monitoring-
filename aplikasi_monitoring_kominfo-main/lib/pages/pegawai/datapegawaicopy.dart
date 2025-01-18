import 'package:flutter/material.dart';
import 'package:Monitoring/bottom_navbar.dart';
import 'package:Monitoring/pages/pegawai/tambahpegawai.dart';
import 'package:Monitoring/pages/pegawai/editpegawai.dart';

class DataPegawaiScreen extends StatefulWidget {
  @override
  _DataPegawaiScreenState createState() => _DataPegawaiScreenState();
}

class _DataPegawaiScreenState extends State<DataPegawaiScreen> {
  final List<Map<String, String>> pegawaiData = [
    {
      'Nomor': '1',
      'Nama': 'Budi Darko Santoso Mangkupupuk',
      'Jabatan': 'Kepala Bidang',
      'Bidang': 'IT',
      'NIP': '1234567890',
    },
    {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
     {
      'Nomor': '2',
      'Nama': 'Siti Aminah',
      'Jabatan': 'Pegawai',
      'Bidang': 'Keuangan',
      'NIP': '0987654321',
    },
 ];

  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10; // Default items per page

  String selectedCategory = 'ASN';
  String selectedBidang = 'IT';
  String initialBidang = 'IT';
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();

  List<String> bidangOptions = ['IT', 'Keuangan', 'HRD'];
  List<int> itemsPerPageOptions = [5, 10, 20]; // Options for items per page

  List<Map<String, String>> get filteredPegawaiData {
    return pegawaiData
        .where((pegawai) =>
            pegawai['Nama']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  int get totalItems => filteredPegawaiData.length;
  int get totalPages => (totalItems / itemsPerPage).ceil();

  void _goToNextPage() {
    setState(() {
      if (currentPage < totalPages) {
        currentPage++;
      }
    });
  }

  void _goToPreviousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  void _showAddPegawaiModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return AddPegawaiModal(
            initialCategory: selectedCategory,
            namaController: namaController,
            nipController: nipController,
            emailController: emailController,
            alamatController: alamatController,
            tglLahirController: tglLahirController,
            initialBidang: initialBidang,
            bidangOptions: bidangOptions,
            onCategoryChanged: (String newCategory) {
              setState(() {
                selectedCategory = newCategory;
              });
            },
            onBidangChanged: (String? newBidang) {
              setState(() {
                selectedBidang = newBidang ?? selectedBidang;
              });
            },
            onSubmit: (String nama,
                String nip,
                String email,
                String alamat,
                String tglLahir,
                String category,
                String? bidang,
                String someOtherValue) {
              Navigator.pop(context);
              setState(() {
                pegawaiData.add({
                  'Nomor': (totalItems + 1).toString(),
                  'Nama': nama,
                  'Jabatan': category,
                  'Bidang': selectedBidang,
                  'NIP': nip,
                });
                namaController.clear();
                nipController.clear();
                emailController.clear();
                alamatController.clear();
                tglLahirController.clear();
              });
            });
      },
    );
  }

void _showDeleteConfirmationDialog(Map<String, String> pegawai) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data pegawai ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                pegawaiData.remove(pegawai); // Remove the employee data
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Hapus'),
          ),
        ],
      );
    },
  );
}

Widget _buildPaginationControls() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0), // Padding kiri 10
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1), // Border
            borderRadius: BorderRadius.circular(6), // Radius sudut
          ),
          child: DropdownButton<int>(
            value: itemsPerPage,
            items: itemsPerPageOptions.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value per page'), // Menampilkan jumlah per halaman
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                itemsPerPage = newValue ?? 10; // Default to 10 if null
                currentPage = 1; // Reset to first page
              });
            },
          ),
        ),
      ),
      // Menggunakan Flexible untuk menghindari overflow
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: currentPage > 1 ? _goToPreviousPage : null,
            ),
            Text(
              'Page $currentPage of $totalPages',
              style: TextStyle(fontSize: 12), // Set the font size here
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: currentPage < totalPages ? _goToNextPage : null,
            ),
          ],
        ),
      ),
    ],
  );
}

  void _showEditPegawaiModal(Map<String, String> pegawai) {
    final namaController = TextEditingController(text: pegawai['Nama']);
    final nipController = TextEditingController(text: pegawai['NIP']);
    final emailController = TextEditingController();
    final alamatController = TextEditingController();
    final tglLahirController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditPegawaiModal(
          initialCategory: pegawai['Jabatan']!,
          namaController: namaController,
          nipController: nipController,
          emailController: emailController,
          alamatController: alamatController,
          tglLahirController: tglLahirController,
          initialBidang: pegawai['Bidang']!,
          bidangOptions: ['IT', 'HRD', 'Keuangan'],
          onCategoryChanged: (value) {},
          onBidangChanged: (value) {},
          onSubmit:
              (nama, nip, email, alamat, tglLahir, jabatan, fotoPath, bidang) {
            setState(() {
              pegawai['Nama'] = nama;
              pegawai['NIP'] = nip;
              pegawai['Jabatan'] = jabatan;
              pegawai['Bidang'] = bidang;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedPegawaiData = filteredPegawaiData
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pegawai'),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BottomNavigation(initialIndex: 2),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                        currentPage = 1;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Cari Pegawai',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[600], fontSize: 16),
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.blueAccent),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent, width: 2.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  width: 40.0,
                                  height: 40.0,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: Colors.white,
                                      onPressed: _showAddPegawaiModal,
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                    ),
                                ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Table(
                                  defaultColumnWidth: FixedColumnWidth(120.0),
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      width: 1,
                                      color: Colors.grey[300]!,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'No.',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Nama Pegawai',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Jabatan',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Bidang',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'NIP',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Action',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                            ...displayedPegawaiData.map((pegawai) {
  return TableRow(
    children: [
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pegawai['Nomor']!),
        ),
      ),
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pegawai['Nama']!, textAlign: TextAlign.center),
        ),
      ),
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pegawai['Jabatan']!, textAlign: TextAlign.center),
        ),
      ),
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pegawai['Bidang']!, textAlign: TextAlign.center),
        ),
      ),
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pegawai['NIP']!, textAlign: TextAlign.center),
        ),
      ),
      Container(
        constraints: BoxConstraints(minHeight: 50), // Minimum height of 50
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.amber),
                padding: EdgeInsets.zero,
                onPressed: () {
                  _showEditPegawaiModal(pegawai);
                },
              ),
            ),
            SizedBox(width: 8), // Spacing between icons
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
  child: IconButton(
    icon: Icon(Icons.delete_forever, color: Colors.red),
    padding: EdgeInsets.zero,
    onPressed: () {
      _showDeleteConfirmationDialog(pegawai); // Show confirmation dialog
    },
  ),
),
          ],
        ),
      ),
    ],
  );
  
}).toList(),
                    ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildPaginationControls(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}