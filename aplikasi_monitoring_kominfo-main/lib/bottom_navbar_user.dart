import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'pages/user/kegiatananda.dart';
import 'pages/user/kegiatananda2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pages/user/program.dart';
import 'pages/pegawai/profile.dart';

class BottomNavigationUser extends StatefulWidget {
  final int initialIndex;

  BottomNavigationUser({this.initialIndex = 0});

  @override
  _BottomNavigationUserState createState() => _BottomNavigationUserState();
}

class _BottomNavigationUserState extends State<BottomNavigationUser> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  final List<Widget> _pages = [
    ProgramScreen(),
    KegiatanAndaPage(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Warna bayangan
              spreadRadius: 0,
              blurRadius: 8, // Seberapa blur bayangan
              offset: Offset(0, -2), // Posisi bayangan
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.code, size: 24),
              title: Text("Program"),
              selectedColor: Color.fromARGB(255, 71, 145, 255),
              unselectedColor: Colors.grey, // Warna tidak dipilih
            ),
            SalomonBottomBarItem(
              icon: FaIcon(FontAwesomeIcons.listCheck, size: 24),
              title: Text("Kegiatan"),
              selectedColor: Color.fromARGB(255, 71, 145, 255),
              unselectedColor: Colors.grey, // Warna tidak dipilih
            ),
            SalomonBottomBarItem(
              icon: FaIcon(FontAwesomeIcons.user, size: 24),
              title: Text("Profile"),
              selectedColor: Color.fromARGB(255, 71, 145, 255),
              unselectedColor: Colors.grey, // Warna tidak dipilih
            ),
          ],
        ),
      ),
    );
  }
}
