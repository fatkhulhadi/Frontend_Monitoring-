import 'package:flutter/material.dart';
import 'package:Monitoring/pages/headerdetail.dart';
import 'package:Monitoring/pages/kegiatan/detailkegiatan.dart';
import 'package:Monitoring/pages/kegiatan/editkegiatan.dart';
import 'package:Monitoring/pages/kegiatan/tambahkegiatan.dart';
import 'package:Monitoring/pages/pegawai/tambahanggotaprog.dart';
import 'package:Monitoring/pages/program/editprogram.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';
import 'package:Monitoring/controllers/program_controller.dart';
import 'package:Monitoring/controllers/sector_controller.dart';
import 'package:Monitoring/models/program_model.dart';
import 'package:Monitoring/models/sector_model.dart';
import 'package:Monitoring/controllers/team_controller.dart';
import 'package:Monitoring/models/team_model.dart';
import 'package:Monitoring/controllers/task_controller.dart';
import 'package:Monitoring/models/task_model.dart';
import 'package:Monitoring/widget/refreshable_gadget.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';

class DetailProgram extends StatefulWidget {
  const DetailProgram({
    super.key,
    required this.program,
    required this.programId,
    required this.sector,
  });

  final ProgramModel program;
  final String sector;
  final String programId;

  @override
  _DetailProgramState createState() => _DetailProgramState();
}

class _DetailProgramState extends State<DetailProgram> {
  final ProgramController _programController = Get.put(ProgramController());
  final SectorController _sectorController = Get.put(SectorController());
  final TeamController _teamController = Get.put(TeamController());
  final TaskController _taskController = Get.put(TaskController());

  bool _canEditTeam() {
    final box = GetStorage();
    return box.read('guard') == 'admin' || box.read('guard') == 'supervisor';
  }

  final PanelController _editTeamPanelController = PanelController();
  String? _selectedRole;
  TeamModel? _currentMember;

  @override
  void initState() {
    super.initState();
    _programController.getProgramById(widget.programId);
    _teamController.getTeamMember(widget.programId);
    _taskController.getProgramTask(widget.programId); // Refresh programs
    _sectorController.getUsersBySector(widget.sector); // Refresh programs
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
                  body: _buildMainContent(
                      // _programController.program.value!,
                      widget.program,
                      _teamController.teams.value,
                      _taskController.tasks.value),
                  panel: _buildEditTeamPanel(),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
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
        if (_isPanelOpen)
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
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
                            "Nama: ${_currentMember!.name}",
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
                                borderRadius: BorderRadius.circular(20),
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
                            items: <String>['anggota', 'koordinator']
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Close the panel without saving changes
                          _editTeamPanelController.close();
                          setState(() {
                            _isPanelOpen = false;
                          });
                        },
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // Text color
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300], // Gray background
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_currentMember != null && _selectedRole != null) {
                            _currentMember!.pivot!.role = _selectedRole!;
                          }
                          await _teamController.updateRoleTeam(widget.programId,
                              _currentMember!.id, _selectedRole);
                          _editTeamPanelController.close();
                          setState(() {
                            _isPanelOpen = false;
                          });
                        },
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
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
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          print("Close button pressed"); // Debugging
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

  Widget _buildMainContent(
      ProgramModel programs, List<TeamModel> team, List<TaskModel> tasks) {
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
                          _programController.getAllProgram();
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: RefreshableWidget(
                          onRefresh: () async {
                            await _programController
                                .getProgramById(widget.programId);
                          },
                          isLoading: _programController.isLoadingGetProgramById,
                          child: Text(
                            programs.name! ?? "Nama Program",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              builder: (context) => EditProgram(
                                  program: programs,
                                  sectors: _sectorController.sectors),
                            );
                            if (result == true) {
                              _programController
                                  .getProgramById(widget.programId);
                              _teamController.getTeamMember(
                                  widget.programId); // Refresh programs
                              _taskController.getProgramTask(
                                  widget.programId); // Refresh programs
                              _sectorController.getUsersBySector(
                                  widget.sector); // Refresh programs
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber, width: 2),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.edit, color: Colors.amber),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              _showDeleteConfirmationDeleteProgram(
                                  context, widget.programId);
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
          const SizedBox(height: 20),
          _buildDetailProgramCard(programs),
          const SizedBox(height: 20),
          RefreshIndicator(onRefresh: () async {
            await _teamController
                .getTeamMember(widget.programId); // Refresh posts
          }, child: Obx(() {
            if (_teamController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTimProgram(programs.sector!.id.toString(), team),
              ); // Pass filtered data here
            }
          })),
          const SizedBox(height: 20),
          _buildKegiatanCard(tasks),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailProgramCard(ProgramModel programs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Detail Program",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              RefreshableWidget(
                  onRefresh: () async {
                    await _programController.getProgramById(widget.programId);
                  },
                  isLoading: _programController.isLoadingGetProgramById,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.event, "Nama Program:",
                          programs.name!, Colors.purple, Colors.purple[100]!),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                          Icons.calendar_today,
                          "Tanggal Mulai:",
                          DateFormat('dd-MM-yyyy')
                              .format(programs.startDate!)
                              .toString(),
                          Colors.green,
                          Colors.green[100]!),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                          Icons.calendar_month,
                          "Tanggal Berakhir:",
                          DateFormat('dd-MM-yyyy')
                              .format(programs.endDate!)
                              .toString(),
                          Colors.pink,
                          Colors.pink[100]!),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                          Icons.description,
                          "Deskripsi:",
                          programs.description!,
                          Colors.grey,
                          Colors.grey[100]!),
                    ],
                  )),
              const SizedBox(height: 20),
            ],
          ),
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
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ' $value',
                    style: const TextStyle(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimProgram(String sectorId, List<TeamModel> team) {
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
            // Menampilkan nama anggota
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Anggota Tim",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_canEditTeam())
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahAnggotaTim(
                            users: _sectorController.users.value,
                            sectorId: sectorId,
                            programId: widget.programId,
                            teamId: ['konz', 'konz'],
                          ),
                        ),
                      );
                      if (result == true) {
                        _teamController.getTeamMember(widget.programId);
                      }
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
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: RefreshIndicator(onRefresh: () async {
                  await _teamController
                      .getTeamMember(widget.programId); // Refresh posts
                }, child: Obx(() {
                  if (_teamController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return DataTable(
                      columns: const [
                        DataColumn(
                            label: Text("No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Nama",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Role",
                                style: TextStyle(fontWeight: FontWeight.bold))),
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
                              DataCell(Text(index.toString())),
                              DataCell(Text(member.name!)),
                              DataCell(Text(member.pivot!.role!)),
                              DataCell(
                                _canEditTeam()
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.amber,
                                                  width: 2,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: Colors.amber),
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    _currentMember = member;
                                                    _selectedRole =
                                                        member.pivot!.role;
                                                  });
                                                  _editTeamPanelController
                                                      .open();
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red),
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                _showDeleteConfirmationTeam(
                                                    context,
                                                    widget.programId,
                                                    member.id!.toString());
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text('-'),
                              ),
                            ],
                          );
                        }
                      }).toList(),
                    ); // Pass filtered data here
                  }
                })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDeleteProgram(
      BuildContext context, String programId) {
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
              onPressed: () async {
                await _programController.deleteProgram(programId);
                await _programController.getAllProgram();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationTeam(
      BuildContext context, String programId, String userId) {
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
                await _teamController.deleteTeamMember(programId, userId);
                await _teamController.getTeamMember(programId);
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildKegiatanCard(List<TaskModel> tasks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Card(
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
                      const Text(
                        'List Kegiatan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (_canEditTeam())
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              builder: (context) => TambahKegiatanPage(
                                programId: widget.programId,
                                programTeam: _teamController.teams.value,
                              ),
                            );
                            if (result == true) {
                              _taskController.getProgramTask(widget.programId);
                            }
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text("Tambah"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Use ListView.builder to create a list of cards
                  SizedBox(
                    height: 300, // Set a fixed height for the ListView
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _taskController.getProgramTask(widget.programId);
                      },
                      child: Obx(() {
                        if (_taskController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Card(
                                color: const Color.fromARGB(255, 222, 245,
                                    255), // Light blue color for the card
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors
                                        .transparent, // Menghilangkan garis pembatas
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      task.name ?? "Nama Kegiatan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Tanggal Kegiatan: ${DateFormat('dd-MM-yyyy').format(task.date!)}",
                                    ),
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .white, // Warna latar belakang untuk bagian yang diperluas
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(
                                                15), // Menambahkan border radius 15 pada bagian bawah
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Jam Kegiatan: ${DateFormat('HH:mm').format(task.time!).toString() ?? 'N/A'}"),
                                            Text(
                                                "Koordinator: ${task.host ?? 'N/A'}"),
                                            Text(
                                                "Progres: ${task.description ?? 'N/A'}"),
                                            Text(
                                                "Laporan: ${task.description ?? 'N/A'}"),
                                            Text(
                                                "Lokasi: ${task.location ?? 'N/A'}"),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // Icon for viewing details
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(Icons.info,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailKegiatan(
                                                            task: task,
                                                            programId: widget
                                                                .programId,
                                                            programTeam:
                                                                _teamController
                                                                    .teams
                                                                    .value,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                if (_canEditTeam()) ...[
                                                  const SizedBox(width: 8),
                                                  // Icon for editing
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(Icons.edit,
                                                          color: Colors.white),
                                                      onPressed: () async {
                                                        final result =
                                                            await showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              EditKegiatanPage(
                                                            task: task,
                                                            programId: widget
                                                                .programId,
                                                            programTeam:
                                                                _teamController
                                                                    .teams
                                                                    .value,
                                                          ),
                                                        );
                                                        if (result == true) {
                                                          _taskController
                                                              .getProgramTask(
                                                                  widget
                                                                      .programId);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Icon for deleting
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.white),
                                                      onPressed: () {
                                                        _showDeleteConfirmationkegiatan(
                                                            context,
                                                            widget.programId,
                                                            task.id.toString());
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 150), // Add bottom padding of 150
        ],
      ),
    );
  }

  void _showDeleteConfirmationkegiatan(
      BuildContext context, String programId, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus anngota tim ini?"),
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
                await _taskController.deleteTask(taskId);
                await _taskController.getProgramTask(programId);
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}
