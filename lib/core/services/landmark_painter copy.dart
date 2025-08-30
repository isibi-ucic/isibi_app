// // lib/features/sign_detector/presentation/widgets/landmark_painter.dart

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:hand_landmarker/hand_landmarker.dart';

// class Connection {
//   final int start;
//   final int end;
//   const Connection(this.start, this.end);
// }

// class HandConnections {
//   static const List<Connection> HAND_CONNECTIONS = [
//     Connection(0, 1),
//     Connection(1, 2),
//     Connection(2, 3),
//     Connection(3, 4), // thumb
//     Connection(0, 5),
//     Connection(5, 6),
//     Connection(6, 7),
//     Connection(7, 8), // index
//     Connection(0, 9),
//     Connection(9, 10),
//     Connection(10, 11),
//     Connection(11, 12), // middle
//     Connection(0, 13),
//     Connection(13, 14),
//     Connection(14, 15),
//     Connection(15, 16), // ring
//     Connection(0, 17),
//     Connection(17, 18),
//     Connection(18, 19),
//     Connection(19, 20), // pinky
//   ];
// }

// class LandmarkPainter extends CustomPainter {
//   /// Daftar tangan yang terdeteksi oleh service hand_landmarker.
//   final List<Hand> hands;

//   /// Ukuran widget CameraPreview di layar, untuk konversi koordinat.
//   final Size? cameraPreviewSize;

//   LandmarkPainter({required this.hands, required this.cameraPreviewSize});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Jangan menggambar apa pun jika data tidak siap
//     if (cameraPreviewSize == null || hands.isEmpty) return;

//     // Definisikan kuas untuk titik (biru) dan garis (putih)
//     final pointPaint = Paint()
//       ..color = Colors.lightBlueAccent
//       ..strokeWidth = 8
//       ..strokeCap = StrokeCap.round;

//     final linePaint = Paint()
//       ..color = Colors.white.withOpacity(0.85)
//       ..strokeWidth = 3;

//     // Loop melalui setiap tangan yang terdeteksi
//     for (final hand in hands) {
//       // Ubah setiap landmark menjadi Offset (posisi pixel di layar)
//       final landmarkOffsets = hand.landmarks.map((landmark) {
//         return Offset(
//           // Sesuaikan dengan orientasi kamera depan (mirror) jika perlu
//           (1 - landmark.x) * cameraPreviewSize!.width,
//           landmark.y * cameraPreviewSize!.height,
//         );
//       }).toList();

//       // Gambar garis koneksi antar landmark
//       // Di sini kita menggunakan konstanta HAND_CONNECTIONS dari paket
//       for (final connection in HandConnections.HAND_CONNECTIONS) {
//         canvas.drawLine(
//           landmarkOffsets[connection.start],
//           landmarkOffsets[connection.end],
//           linePaint,
//         );
//       }

//       // Gambar titik di atas setiap landmark
//       canvas.drawPoints(PointMode.points, landmarkOffsets, pointPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant LandmarkPainter oldDelegate) {
//     // Repaint hanya jika ada perubahan pada data tangan
//     return oldDelegate.hands != hands;
//   }
// }
