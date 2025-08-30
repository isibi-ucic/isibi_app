import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

// --- DAFTAR KONEKSI LANDMARK TANGAN ---
// Didefinisikan di sini karena tidak tersedia di paket.
// Setiap list integer adalah sepasang indeks landmark yang harus dihubungkan.
const List<List<int>> kHandConnections = [
  [0, 1], [1, 2], [2, 3], [3, 4], // Thumb
  [0, 5], [5, 6], [6, 7], [7, 8], // Index finger
  [5, 9], [9, 10], [10, 11], [11, 12], // Middle finger
  [9, 13], [13, 14], [14, 15], [15, 16], // Ring finger
  [13, 17], [17, 18], [18, 19], [19, 20], // Pinky
  [0, 17], // Palm
];

class LandmarkPainter extends CustomPainter {
  final List<Hand> hands;
  final Size? cameraPreviewSize;

  LandmarkPainter({required this.hands, required this.cameraPreviewSize});

  @override
  void paint(Canvas canvas, Size size) {
    if (cameraPreviewSize == null || hands.isEmpty) return;

    final pointPaint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..strokeWidth = 3;

    for (final hand in hands) {
      // --- LOGIKA BARU UNTUK MENYESUAIKAN KOORDINAT ---

      // Cek apakah orientasi gambar dari sensor adalah landscape (width > height)
      final bool isLandscape =
          cameraPreviewSize!.width > cameraPreviewSize!.height;

      final landmarkOffsets = hand.landmarks.map((landmark) {
        double dx, dy;

        if (isLandscape) {
          // Jika sensor landscape tapi tampilan portrait, kita "putar" koordinatnya
          // Koordinat Y landmark (atas-bawah) menjadi koordinat X di layar (kiri-kanan)
          // Koordinat X landmark (kiri-kanan) menjadi koordinat Y di layar (atas-bawah)
          dx = landmark.y * size.width;
          dy = landmark.x * size.height;
        } else {
          // Jika sensor sudah portrait, gunakan seperti biasa
          dx = landmark.x * size.width;
          dy = landmark.y * size.height;
        }

        // Karena kamera depan biasanya dicerminkan, kita balik sumbu X-nya
        return Offset(size.width - dx, dy);
      }).toList();

      // Sisa kode untuk menggambar garis dan titik tetap sama
      for (final connection in kHandConnections) {
        if (connection[0] < landmarkOffsets.length &&
            connection[1] < landmarkOffsets.length) {
          canvas.drawLine(
            landmarkOffsets[connection[0]],
            landmarkOffsets[connection[1]],
            linePaint,
          );
        }
      }

      canvas.drawPoints(PointMode.points, landmarkOffsets, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LandmarkPainter oldDelegate) {
    return oldDelegate.hands != hands;
  }
}
