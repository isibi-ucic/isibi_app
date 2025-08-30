import 'package:isibi_app/features/scanner_web_page.dart';
import 'features/home_page.dart';
import 'features/materi_list_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// --- Halaman Navigasi Utama ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _bottomNavIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [const HomePage(), const MateriListPage()];

  // Daftar ikon untuk BottomNavBar
  final List<IconData> _iconList = [
    Icons.home_rounded,
    Icons.menu_book_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai dengan indeks yang aktif
      body: _pages[_bottomNavIndex],

      // Tombol Scanner yang Mengambang
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(
          FontAwesomeIcons.camera, // Ikon yang merepresentasikan sign language
          color: Colors.white,
        ),
        onPressed: () {
          // Aksi saat tombol scanner ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScannerWebPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar dengan Lekukan
      bottomNavigationBar: AnimatedBottomNavigationBar(
        shadow: BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(95)),
        height: 75,
        icons: _iconList,
        iconSize: 32,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
        backgroundColor: Colors.white,
        activeColor: Colors.blue.shade700,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
