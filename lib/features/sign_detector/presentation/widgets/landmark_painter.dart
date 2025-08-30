// // lib/features/sign_detector/presentation/widgets/landmark_painter.dart

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:hand_landmarker/hand_landmarker.dart';

// class LandmarkPainter extends CustomPainter {
//   /// The hand landmarks to be painted.
//   final List<Hand> hands;

//   /// The size of the camera preview widget.
//   final Size? cameraPreviewSize;

//   LandmarkPainter({required this.hands, required this.cameraPreviewSize});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (cameraPreviewSize == null) return;

//     // Definisikan kuas untuk titik dan garis
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
//           landmark.x * cameraPreviewSize!.width,
//           landmark.y * cameraPreviewSize!.height,
//         );
//       }).toList();

//       // Gambar garis koneksi antar landmark
//       for (final connection in HandLandmarker.HAND_CONNECTIONS) {
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
//     return oldDelegate.hands != hands;
//   }
// }
