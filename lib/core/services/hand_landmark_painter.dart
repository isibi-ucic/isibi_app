// // lib/painters/hand_landmark_painter.dart
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// class HandLandmarkPainter extends CustomPainter {
//   final List<PoseLandmark> landmarks;
//   final Size previewSize; // Ukuran widget CameraPreview di layar

//   HandLandmarkPainter({required this.landmarks, required this.previewSize});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final pointPaint = Paint()
//       ..color = Colors.lightBlueAccent
//       ..strokeWidth = 8
//       ..strokeCap = StrokeCap.round;

//     final linePaint = Paint()
//       ..color = Colors.white.withOpacity(0.8)
//       ..strokeWidth = 3;

//     // Definisikan koneksi antar landmark untuk membentuk kerangka
//     final Map<PoseLandmarkType, PoseLandmarkType> connections = {
//       // (Ini contoh untuk pose, Anda harus sesuaikan untuk landmark tangan)
//       PoseLandmarkType.rightWrist: PoseLandmarkType.rightThumb,
//       PoseLandmarkType.rightWrist: PoseLandmarkType.rightIndex,
//       PoseLandmarkType.rightWrist: PoseLandmarkType.rightPinky,
//       // ... tambahkan semua koneksi yang relevan
//     };

//     // Buat map untuk akses cepat ke koordinat landmark
//     final Map<PoseLandmarkType, Offset> landmarkOffsets = {};

//     for (var landmark in landmarks) {
//       // Konversi koordinat relatif ke absolut
//       final dx = landmark.x * previewSize.width;
//       final dy = landmark.y * previewSize.height;
//       final offset = Offset(dx, dy);

//       landmarkOffsets[landmark.type] = offset;

//       // Gambar titik landmark
//       canvas.drawPoints(PointMode.points, [offset], pointPaint);
//     }

//     // Gambar garis koneksi
//     connections.forEach((start, end) {
//       final startOffset = landmarkOffsets[start];
//       final endOffset = landmarkOffsets[end];

//       if (startOffset != null && endOffset != null) {
//         canvas.drawLine(startOffset, endOffset, linePaint);
//       }
//     });
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // Selalu repaint saat ada data baru
//   }
// }
