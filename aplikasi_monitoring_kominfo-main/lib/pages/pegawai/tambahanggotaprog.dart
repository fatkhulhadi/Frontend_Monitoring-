import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Monitoring/models/user_model.dart';
import 'package:Monitoring/controllers/sector_controller.dart';
import 'package:Monitoring/controllers/team_controller.dart';

class TambahAnggotaTim extends StatefulWidget {
  const TambahAnggotaTim({
    super.key,
    required this.users,
    required this.sectorId,
    required this.programId,
    required this.teamId,
  });

  final List<UserModel> users;
  final String sectorId;
  final String programId;
  final List<String> teamId;

  @override
  _TambahAnggotaTimState createState() => _TambahAnggotaTimState();
}

class _TambahAnggotaTimState extends State<TambahAnggotaTim> {
  final SectorController _sectorController = SectorController();
  final TeamController _teamController = TeamController();
  List<UserModel> selectedAnggota = [];
  String searchQuery = '';

  void _addAnggota(UserModel anggota) {
    setState(() {
      selectedAnggota.add(anggota);
    });
  }

  void _removeAnggota(UserModel anggota) {
    setState(() {
      selectedAnggota.remove(anggota);
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  // _sectorController.getUsersBySector(widget.sectorId);
  // }

  @override
  Widget build(BuildContext context) {
    final filteredAnggota = widget.users.where((member) {
      return member.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Tambah Anggota', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBox(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAnggota.length,
                itemBuilder: (context, index) {
                  final currentAnggota = filteredAnggota[index];
                  final isSelected = selectedAnggota.contains(currentAnggota);

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage("https://via.placeholder.com/150"),
                      ),
                      title: Text(currentAnggota.name!),
                      subtitle: Text(currentAnggota.occupation!.name!),
                      trailing: isSelected
                          ? IconButton(
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                _removeAnggota(currentAnggota);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () {
                                _addAnggota(currentAnggota);
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (selectedAnggota.isNotEmpty)
                  ? () {
                      _teamController.createTeam(
                          widget.programId, selectedAnggota);
                      Navigator.pop(context, true);
                    }
                  : null,
              child: Text('Simpan Anggota (${selectedAnggota.length})'),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  SearchBox({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari Anggota',
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        filled: true,
        fillColor: Colors.grey[215],
      ),
      onChanged: onChanged,
    );
  }
}
