import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Monitoring/models/user_model.dart';
import 'package:Monitoring/models/team_model.dart';
import 'package:Monitoring/controllers/sector_controller.dart';
import 'package:Monitoring/controllers/team_controller.dart';
import 'package:Monitoring/controllers/task_controller.dart';

class TambahAnggotaKegiatan extends StatefulWidget {
  const TambahAnggotaKegiatan({
    super.key,
    required this.users,
    required this.taskId,
    // required this.sectorId,
    // required this.teamId,
  });

  final List<TeamModel> users;
  final String taskId;
  // final String sectorId;
  // final List<String> teamId;

  @override
  _TambahAnggotaKegiatanState createState() => _TambahAnggotaKegiatanState();
}

class _TambahAnggotaKegiatanState extends State<TambahAnggotaKegiatan> {
  final SectorController _sectorController = SectorController();
  final TeamController _teamController = TeamController();
  final TaskController _taskController = TaskController();
  List<TeamModel> selectedAnggota = [];
  String searchQuery = '';

  void _addAnggota(TeamModel anggota) {
    setState(() {
      selectedAnggota.add(anggota);
    });
  }

  void _removeAnggota(TeamModel anggota) {
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
                      _taskController.createTaskTeam(
                          widget.taskId, selectedAnggota);
                      Navigator.pop(context);
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
