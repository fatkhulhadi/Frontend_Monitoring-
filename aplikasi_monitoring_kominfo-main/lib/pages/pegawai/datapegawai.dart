import 'package:flutter/material.dart';
import 'package:Monitoring/bottom_navbar.dart';
import 'package:Monitoring/controllers/pegawai_controller.dart';
import 'package:get/get.dart';

class DataPegawaiScreen extends StatefulWidget {
  @override
  _DataPegawaiScreenState createState() => _DataPegawaiScreenState();
}

class _DataPegawaiScreenState extends State<DataPegawaiScreen> {
  // Inisialisasi Controller
  final PegawaiController _pegawaiController = Get.put(PegawaiController());

  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10; // Default items per page

  String selectedCategory = 'ASN';
  String selectedBidang = 'IT';
  String initialBidang = 'IT';

  // Controllers untuk form
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();

  List<String> bidangOptions = ['IT', 'Keuangan', 'HRD'];
  List<int> itemsPerPageOptions = [5, 10, 20];

  @override
  void initState() {
    super.initState();
    // Fetch data pegawai saat screen pertama kali dimuat
    _pegawaiController.fetchAllPegawai();
  }

  // Getter untuk data pegawai yang difilter
  List<Map<String, dynamic>> get filteredPegawaiData {
    return _pegawaiController.pegawaiList
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

  // void _showAddPegawaiModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return AddPegawaiModal(
  //         initialCategory: selectedCategory,
  //         namaController: namaController,
  //         nipController: nipController,
  //         emailController: emailController,
  //         alamatController: alamatController,
  //         tglLahirController: tglLahirController,
  //         initialBidang: initialBidang,
  //         bidangOptions: bidangOptions,
  //         onCategoryChanged: (String newCategory) {
  //           setState(() {
  //             selectedCategory = newCategory;
  //           });
  //         },
  //         onBidangChanged: (String? newBidang) {
  //           setState(() {
  //             selectedBidang = newBidang ?? selectedBidang;
  //           });
  //         },
  //         onSubmit: (String nama, String nip, String email, String alamat,
  //             String tglLahir, String category, String? bidang, String someOtherValue) {
  //           // Persiapkan data untuk dikirim ke backend
  //           Map<String, dynamic> pegawaiData = {
  //             'name': nama,
  //             'nip': nip,
  //             'email': email,
  //             'occupation': category,
  //             'sector': bidang,
  //             'address': alamat,
  //             'birth_date': tglLahir,
  //           };

  //           // Panggil method tambah pegawai dari controller
  //           _pegawaiController.tambahPegawai(pegawaiData).then((berhasil) {
  //             if (berhasil) {
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Pegawai berhasil ditambahkan')),
  //               );

  //               // Reset controller
  //               namaController.clear();
  //               nipController.clear();
  //               emailController.clear();
  //               alamatController.clear();
  //               tglLahirController.clear();
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Gagal menambahkan pegawai')),
  //               );
  //             }
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  void _showDeleteConfirmationDialog(Map<String, dynamic> pegawai) {
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
                // Panggil method hapus pegawai dari controller
                _pegawaiController.hapusPegawai(pegawai['Nomor']).then((berhasil) {
                  Navigator.of(context).pop(); // Close the dialog
                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pegawai berhasil dihapus')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menghapus pegawai')),
                    );
                  }
                });
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // void _showEditPegawaiModal(Map<String, dynamic> pegawai) {
  //   final namaController = TextEditingController(text: pegawai['Nama']);
  //   final nipController = TextEditingController(text: pegawai['NIP']);
  //   final emailController = TextEditingController();
  //   final alamatController = TextEditingController();
  //   final tglLahirController = TextEditingController();

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return EditPegawaiModal(
  //         initialCategory: pegawai['Jabatan']!,
  //         namaController: namaController,
  //         nipController: nipController,
  //         emailController: emailController,
  //         alamatController: alamatController,
  //         tglLahirController: tglLahirController,
  //         initialBidang: pegawai['Bidang']!,
  //         bidangOptions: ['IT', 'HRD', 'Keuangan'],
  //         onCategoryChanged: (value) {},
  //         onBidangChanged: (value) {},
  //         onSubmit: (nama, nip, email, alamat, tglLahir, jabatan, fotoPath, bidang) {
  //           // Persiapkan data untuk update
  //           Map<String, dynamic> pegawaiData = {
  //             'name': nama,
  //             'nip': nip,
  //             'email': email,
  //             'occupation': jabatan,
  //             'sector': bidang,
  //             'address': alamat,
  //             'birth_date': tglLahir };

  //           // Panggil method update pegawai dari controller
  //           _pegawaiController.updatePegawai(pegawai['Nomor'], pegawaiData).then((berhasil) {
  //             Navigator.pop(context);
  //             if (berhasil) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Pegawai berhasil diperbarui')),
  //               );
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Gagal memperbarui pegawai')),
  //               );
  //             }
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<int>(
              value: itemsPerPage,
              items: itemsPerPageOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value per page'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  itemsPerPage = newValue ?? 10;
                  currentPage = 1;
                });
              },
            ),
          ),
        ),
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
                style: TextStyle(fontSize: 12),
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

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        if (_pegawaiController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final displayedPegawaiData = filteredPegawaiData
            .skip((currentPage - 1) * itemsPerPage)
            .take(itemsPerPage)
            .toList();

        return Column(
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
                                            color: Colors.grey[600],
                                            fontSize: 16),
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.blueAccent),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 2.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                            
                                 ],
                              ),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                child: Column(
                                  children: displayedPegawaiData
                                      .asMap()
                                      .map((index, pegawai) {
                                        return MapEntry(
                                          index,
                                          StatefulBuilder(
                                            builder: (context, setState) {
                                              bool isExpanded = false;

                                              int nomorPegawai =
                                                  (currentPage - 1) *
                                                          itemsPerPage +
                                                      index +
                                                      1;

                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 60,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255,
                                                            222,
                                                            245,
                                                            255),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          nomorPegawai
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .black87,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Card(
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(15),
                                                        ),
                                                        elevation: 4,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: isExpanded
                                                                    ? Colors.white
                                                                    : Color.fromARGB(
                                                                        255,
                                                                        222,
                                                                        245,
                                                                        255),
                                                                borderRadius: BorderRadius.vertical(
                                                                  top: Radius.circular(15),
                                                                  bottom: isExpanded
                                                                      ? Radius.zero
                                                                      : Radius.circular(15),
                                                                ),
                                                              ),
                                                              child: ExpansionTile(
                                                                tilePadding: EdgeInsets.symmetric(horizontal: 16),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                collapsedShape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                title: Text(
                                                                  pegawai['Nama']!,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                trailing: Icon(
                                                                  Icons.keyboard_arrow_down_rounded,
                                                                  size: 24,
                                                                  color: Colors.grey[700],
                                                                ),
                                                                onExpansionChanged: (value) {
                                                                  setState(() {
                                                                    isExpanded = value;
                                                                  });
                                                                },
                                                                children: [
                                                                 Container(
  width: double.infinity, // Menjadikan kotak full width
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(15),
    ),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Jabatan: ${pegawai['Jabatan']}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 6),
      Text(
        'Bidang: ${pegawai['Bidang']}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 6),
      Text(
        'NIP: ${pegawai['NIP']}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 16),
    ],
  ),
)
 
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      })
                                      .values
                                      .toList(),
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
        );
      }),
    );
  }

}