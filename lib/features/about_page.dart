import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang abu-abu sangat muda
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1, // Beri sedikit bayangan agar terpisah dari body
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian Header Utama
          _buildHeaderCard(),
          const SizedBox(height: 20),

          // Bagian Info Pendanaan (Dengan Judul PKM)
          _buildFundingCard(),
          const SizedBox(height: 20),

          // --- KARTU BARU UNTUK DOSEN PENDAMPING ---
          _buildSupervisorCard(),
          const SizedBox(height: 20),

          // Bagian Author
          _buildAuthorCard(),
        ],
      ),
    );
  }

  // Widget untuk kartu header
  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withAlpha(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons
                  .handsAslInterpreting, // Menggunakan ikon sign language
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'I-Sibi App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Made with ❤️ by I-Sibi Dev',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Universitas Catur Insan Cendekia (CIC)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu info pendanaan
  // Widget untuk kartu info pendanaan
  Widget _buildFundingCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withAlpha(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Program Pendanaan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Text(
              'Aplikasi ini dikembangkan melalui Program Kreativitas Mahasiswa bidang Karya Inovatif (PKM-KI) yang didanai oleh pemerintah pada tahun 2023 dengan judul:',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // --- JUDUL LENGKAP PKM DITAMBAHKAN DI SINI ---
            Text(
              '"Aplikasi Penerjemah Bahasa Isyarat Berbasis AI Sebagai Upaya Membantu Komunikasi Disabilitas Tunarungu"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BARU UNTUK DOSEN PENDAMPING ---
  Widget _buildSupervisorCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withAlpha(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dosen Pendamping',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            // Ganti dengan nama Dosen Pendamping Anda
            _buildInfoTile(
              icon: Icons.school,
              title:
                  'Rifqi Fahrudin, S.Kom, M.Kom', // Ganti dengan nama & gelar dosen
              subtitle: 'Dosen Pendamping PKM',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu author
  Widget _buildAuthorCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withAlpha(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Author',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            // Ganti dengan nama-nama tim Anda
            _buildAuthorTile('Sahl (Team Leader)', 'Flutter Dev & AI Dev'),
            _buildAuthorTile('Ferdi Ananta Salman', 'Flutter Dev'),
            _buildAuthorTile('Kefas Zefannya Agusya', 'AI Train Model'),
            _buildAuthorTile(
              'Salman Faris Aulia',
              'UI/UX Designer & Medsos Assist',
            ),
            _buildAuthorTile(
              'Devina Virgiani',
              'UI/UX Designer and UX Reseacher',
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk setiap baris author
  Widget _buildAuthorTile(String name, String role) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(role, style: TextStyle(color: Colors.grey[600])),
    );
  }
}

// Helper widget yang lebih generik untuk menampilkan info
Widget _buildInfoTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
  );
}
