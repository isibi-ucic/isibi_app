// lib/pages/materi_detail_page.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MateriDetailPage extends StatefulWidget {
  final String alphabet;

  const MateriDetailPage({super.key, required this.alphabet});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    print("Alphabet: ${widget.alphabet}");

    print(
      "Video URL: http://pmpk.kemdikbud.go.id/sibi/SIBI/katadasar/${widget.alphabet}.webm",
    );
    // Buat dan siapkan controller untuk video dari internet.
    final videoUrl =
        'http://pmpk.kemdikbud.go.id/sibi/SIBI/katadasar/${widget.alphabet}.webm';

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    // Inisialisasi controller. Ini adalah proses async.
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Pastikan video di-looping dan langsung diputar.
      _controller.setLooping(true);
      _controller.play();
      // Panggil setState agar frame pertama ditampilkan setelah video siap.
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller untuk membebaskan resource.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Materi Huruf: ${widget.alphabet}',
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
              // --- Player Video ---
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Jika video sudah siap, tampilkan.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller),
                            // Tambahkan tombol play/pause di sini
                            _buildPlayPauseButton(),
                          ],
                        ),
                      );
                    } else {
                      // Jika video masih loading, tampilkan spinner.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // --- Deskripsi ---
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Berikut adalah cara memperagakan huruf "${widget.alphabet}" dalam Sistem Isyarat Bahasa Indonesia (SIBI). Perhatikan posisi jari dan bentuk tangan dengan saksama. Ulangi beberapa kali hingga Anda terbiasa.',
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

  Widget _buildPlayPauseButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
