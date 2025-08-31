import 'dart:ui';
import 'package:camera/camera.dart';
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
  final Size cameraPreviewSize; // Ukuran asli dari sensor (misal: 1280x720)
  final CameraLensDirection cameraLensDirection;

  LandmarkPainter({
    required this.hands,
    required this.cameraPreviewSize,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 'size' adalah ukuran widget di layar (misal: 400x800)
    if (hands.isEmpty) return;

    final pointPaint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    for (final hand in hands) {
      final landmarkOffsets = hand.landmarks.map((landmark) {
        return _transformCoordinates(landmark, size);
      }).toList();

      for (final connection in kHandConnections) {
        canvas.drawLine(
          landmarkOffsets[connection[0]],
          landmarkOffsets[connection[1]],
          linePaint,
        );
      }

      canvas.drawPoints(PointMode.points, landmarkOffsets, pointPaint);
    }
  }

  // Di dalam kelas LandmarkPainter

  Offset _transformCoordinates(Landmark landmark, Size screenSize) {
    // Koordinat x dan y dari MediaPipe (nilai relatif antara 0.0 - 1.0 dari gambar asli)
    final double landmarkX = landmark.x;
    final double landmarkY = landmark.y;

    // Langsung lakukan transformasi "putar" dan "skala" dalam satu langkah
    // Sumbu Y dari data sensor (atas-bawah) menjadi sumbu X di layar (kiri-kanan)
    final double dx = landmarkY * screenSize.width;
    // Sumbu X dari data sensor (kiri-kanan) menjadi sumbu Y di layar (atas-bawah)
    final double dy = landmarkX * screenSize.height;

    // Tangani efek cermin untuk kamera depan
    if (cameraLensDirection == CameraLensDirection.back) {
      return Offset(screenSize.width - dx, dy);
    } else {
      return Offset(dx, dy);
    }
  }

  @override
  bool shouldRepaint(covariant LandmarkPainter oldDelegate) {
    return oldDelegate.hands != hands;
  }
}
