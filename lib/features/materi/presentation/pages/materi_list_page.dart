import 'package:flutter/material.dart';
// Impor halaman detail yang akan kita buat nanti
import 'materi_detail_page.dart';

class MateriListPage extends StatelessWidget {
  const MateriListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat daftar abjad dari A sampai Z
    final List<String> alphabets = List.generate(
      26,
      (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Materi Bahasa Isyarat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 kartu per baris
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: alphabets.length,
          itemBuilder: (context, index) {
            final alphabet = alphabets[index];
            return NeumorphicCard(
              onTap: () {
                // Navigasi ke halaman detail dengan animasi
                Navigator.push(
                  context,
                  createFadeRoute(MateriDetailPage(alphabet: alphabet)),
                );
              },
              child: Center(
                child: Text(
                  alphabet,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget Kustom untuk Kartu dengan Efek Neumorphic (Soft UI)
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const NeumorphicCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Bayangan gelap di kanan bawah
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            // Bayangan terang di kiri atas
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// Fungsi untuk membuat route dengan animasi FADE
Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    // Halaman tujuan yang akan ditampilkan
    pageBuilder: (context, animation, secondaryAnimation) => page,

    // Builder untuk membuat animasinya
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animation adalah nilai dari 0.0 hingga 1.0 yang dikontrol oleh Flutter
      return FadeTransition(
        opacity: animation,
        child: child, // child adalah halaman tujuan (page)
      );
    },

    // Durasi transisi
    transitionDuration: const Duration(milliseconds: 400),
  );
}
