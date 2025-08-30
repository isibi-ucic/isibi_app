// lib/features/materi_sibi/presentation/pages/materi_detail_page.dart

import 'package:flutter/material.dart';

class MateriDetailPage extends StatefulWidget {
  final String alphabet;

  const MateriDetailPage({super.key, required this.alphabet});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Path ke gambar lokal di dalam aset
    final imagePath = 'assets/images/${widget.alphabet.toLowerCase()}.jpg';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Detail Huruf: ${widget.alphabet}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Gambar Statis dari Aset ---
              // --- 1. Gambar Statis dari Aset ---
              Container(
                // Hapus height dari Container karena AspectRatio akan menentukannya
                // height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  // Tambahkan ClipRRect di sini untuk border radius
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    // Bungkus dengan AspectRatio
                    aspectRatio: 4 / 3, // Aspek rasio 4:3 (lebar/tinggi)
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit
                          .cover, // Ini penting untuk mengisi tanpa stretch/celah
                      // Beri error handler jika gambar tidak ditemukan
                      errorBuilder: (context, error, stackTrace) {
                        print("Error memuat gambar: $error");
                        return Container(
                          // Ganti icon error dengan Container berwarna
                          color: Colors
                              .red[50], // Latar belakang merah muda untuk error
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gagal memuat gambar dari $imagePath',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- 3. Deskripsi ---
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Berikut adalah cara memperagakan huruf "${widget.alphabet}" dalam Sistem Isyarat Bahasa Indonesia (SIBI). Perhatikan posisi jari dan bentuk tangan dengan saksama.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
