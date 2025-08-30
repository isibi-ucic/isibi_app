import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isibi_app/features/sign_detector/presentation/pages/scanner_page.dart';
import '../../../../main_navigation.dart';
import '../../../materi/presentation/pages/materi_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. Header Sapaan ---
                _buildGreeting(),
                const SizedBox(height: 24),

                // --- 2. Banner Carousel ---
                _buildCarousel(),
                const SizedBox(height: 32),

                // --- 3. Menu Akses Cepat ---
                _buildQuickAccessMenu(context),
                const SizedBox(height: 32),

                // --- 4. "Kata Hari Ini" ---
                _buildWordOfTheDay(),
                const SizedBox(height: 32),

                // --- 5. Lanjutkan Belajar ---
                _buildContinueLearning(),

                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Sapaan Pengguna
  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Pagi, 👋',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pengguna I-Sibi', // Anda bisa ganti dengan nama pengguna
            style: TextStyle(
              color: Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Banner Carousel
  Widget _buildCarousel() {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1698993001180-8654ab29032a',
      'https://images.unsplash.com/photo-1659352787755-ab30ee8b9887',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.85,
      ),
      items: imgList
          .map(
            (item) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  // Anda bisa tambahkan teks di atas gambar di sini
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // Widget untuk Menu Akses Cepat
  Widget _buildQuickAccessMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FeatureCard(
            icon: FontAwesomeIcons.handsAslInterpreting,
            label: 'Scanner',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScannerPage()),
              );
            },
          ),
          FeatureCard(
            icon: Icons.menu_book_rounded,
            label: 'Materi',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MateriListPage()),
              );
            },
          ),
          FeatureCard(
            icon: Icons.info_outline_rounded,
            label: 'Informasi',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MateriListPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk "Kata Hari Ini"
  Widget _buildWordOfTheDay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kata Hari Ini ✨',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.solidComment,
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Sapaan umum', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk "Lanjutkan Belajar"
  Widget _buildContinueLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Lanjutkan Belajar 🚀',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 24),
            children: [
              ContinueLearningCard(letter: 'C', progress: 0.8),
              ContinueLearningCard(letter: 'G', progress: 0.5),
              ContinueLearningCard(letter: 'A', progress: 1.0),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Widget Kustom untuk Kartu Fitur ---
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// --- Widget Kustom untuk Kartu Lanjutkan Belajar ---
class ContinueLearningCard extends StatelessWidget {
  final String letter;
  final double progress; // 0.0 to 1.0

  const ContinueLearningCard({
    super.key,
    required this.letter,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Huruf $letter',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
