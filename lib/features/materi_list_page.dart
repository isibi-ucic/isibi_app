// lib/features/materi_sibi/presentation/pages/materi_list_page.dart

import 'package:flutter/material.dart';
import 'package:isibi_app/core/widgets/cretae_route.dart';
import 'materi_detail_page.dart'; // Pastikan file detail page sudah ada

class MateriListPage extends StatelessWidget {
  const MateriListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat daftar abjad dari A sampai Z secara dinamis
    final List<String> alphabets = List.generate(
      26,
      (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
    );

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang bersih
      appBar: AppBar(
        title: const Text(
          'Materi SIBI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Hilangkan bayangan untuk tampilan datar
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20.0),
        // SliverGridDelegateWithFixedCrossAxisCount untuk membuat grid dengan jumlah kolom tetap
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 kolom, cocok untuk abjad
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
        ),
        itemCount: alphabets.length,
        itemBuilder: (context, index) {
          final alphabet = alphabets[index];
          return AlphabetCard(
            alphabet: alphabet,
            onTap: () {
              // Navigasi ke halaman detail saat kartu ditekan
              Navigator.push(
                context,
                createFadeRoute(MateriDetailPage(alphabet: alphabet)),
              );
            },
          );
        },
      ),
    );
  }
}

// Widget kustom untuk kartu abjad
class AlphabetCard extends StatelessWidget {
  final String alphabet;
  final VoidCallback onTap;

  const AlphabetCard({super.key, required this.alphabet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Warna biru muda yang lembut
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100, width: 2),
        ),
        child: Center(
          child: Text(
            alphabet,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
      ),
    );
  }
}
