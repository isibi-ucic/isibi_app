import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isibi_app/core/widgets/cretae_route.dart';
import 'package:isibi_app/features/about_page.dart';
import 'package:isibi_app/features/materi_list_page.dart';
import 'package:isibi_app/features/scanner_page.dart';

// Asumsikan path ke halaman-halaman ini sudah benar
import 'package:isibi_app/features/scanner_web_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
        children: [
          // Header Sapaan
          const Text(
            'Halo, Sobat I-Sibi! 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih fitur di bawah untuk memulai.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Kartu Fitur Scanner
          FeatureCard(
            icon: FontAwesomeIcons.camera,
            title: 'Scanner Isyarat',
            subtitle: 'Terjemahkan isyarat secara real-time',
            color: Colors.blue,
            onTap: () {
              Navigator.push(context, createFadeRoute(const ScannerWebPage()));
            },
          ),
          const SizedBox(height: 16),

          // Kartu Fitur Materi
          FeatureCard(
            icon: Icons.menu_book_rounded,
            title: 'Materi SIBI',
            subtitle: 'Pelajari abjad dan kata dasar',
            color: Colors.orange,
            onTap: () {
              Navigator.push(context, createFadeRoute(const MateriListPage()));
            },
          ),
          const SizedBox(height: 16),

          // Kartu Fitur Informasi
          FeatureCard(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi',
            subtitle: 'Informasi mengenai proyek I-Sibi',
            color: Colors.green,
            onTap: () {
              // Ganti dengan halaman About Us atau Informasi Anda
              Navigator.push(context, createFadeRoute(const AboutPage()));
            },
          ),
          const SizedBox(height: 16),
          // Kartu Fitur Scanner Flutter
          FeatureCard(
            icon: FontAwesomeIcons.handsAslInterpreting,
            title: 'Scanner (debug)',
            subtitle:
                'Terjemahkan isyarat secara real-time langsung di Flutter',
            color: Colors.grey,
            onTap: () {
              Navigator.push(context, createFadeRoute(const ScannerPage()));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Widget kustom untuk kartu fitur dengan gaya yang konsisten
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: color.withAlpha(10), // Warna latar belakang yang lembut
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(30), width: 2),
        ),
        child: Row(
          children: [
            // Ikon Fitur
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            // Teks Judul dan Subjudul
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color.withAlpha(70)),
          ],
        ),
      ),
    );
  }
}
