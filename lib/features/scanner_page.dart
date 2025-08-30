// // lib/features/sign_detector/presentation/pages/scanner_page.dart

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:hand_landmarker/hand_landmarker.dart'; // Untuk objek Hand dan Landmark
// import 'package:isibi_app/core/services/hand_landmarker_service.dart';
// import 'package:isibi_app/core/services/prediction_services.dart';
// import 'package:isibi_app/core/services/tflite_service.dart';

// class ScannerPage extends StatefulWidget {
//   const ScannerPage({super.key});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   // Controller & State Management
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;
//   bool _isProcessing = false;

//   // Inisialisasi Services
//   final HandLandmarkerService _handLandmarkerService = HandLandmarkerService();
//   final TFLiteService _tfliteService = TFLiteService();
//   final PredictionService _predictionService = PredictionService();

//   // Variabel untuk menampilkan hasil di UI
//   List<Hand> _detectedHands = [];
//   String? _currentPrediction;
//   String _currentSentence = "";
//   final List<String> _suggestions = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeAllServices();
//   }

//   Future<void> _initializeAllServices() async {
//     try {
//       // 1. TUNGGU loadModel BENAR-BENAR SELESAI
//       await _tfliteService.loadModel();
//       await _handLandmarkerService.initialize();

//       // 2. HANYA JIKA service lain berhasil, baru inisialisasi kamera
//       await _initializeCamera();
//     } catch (e) {
//       print("Error saat inisialisasi service: $e");
//       // Tampilkan pesan error ke pengguna jika perlu
//       if (mounted) {
//         setState(() {
//           // Tambahkan variabel state untuk error message jika mau
//         });
//       }
//     }
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final backCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.back,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       backCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//     await _cameraController!.initialize();
//     if (!mounted) return;

//     setState(() {
//       _isCameraInitialized = true;
//     });

//     // 3. LOGIKA BUFFER YANG AMAN DI startImageStream
//     _cameraController!.startImageStream((image) {
//       if (_isProcessing) return;

//       setState(() {
//         _isProcessing = true;
//       });

//       // Lakukan semua proses di dalam try-catch-finally atau .whenComplete
//       _handLandmarkerService
//           .detect(image, _cameraController!.value.deviceOrientation.index)
//           .then((hands) {
//             setState(() {
//               _detectedHands = hands;
//             });

//             if (hands.isNotEmpty) {
//               final List<double> normalizedLandmarks = _normalizeLandmarks(
//                 hands.first.landmarks,
//               );

//               if (normalizedLandmarks.length == 42) {
//                 _tfliteService.runInference(normalizedLandmarks).then((
//                   prediction,
//                 ) {
//                   if (prediction != null) {
//                     _predictionService.addCharacter(prediction);
//                     if (mounted) {
//                       setState(() {
//                         _currentPrediction = prediction;
//                         _currentSentence = _predictionService.currentSentence;
//                       });
//                     }
//                   }
//                 });
//               }
//             }
//           })
//           .catchError((error) {
//             // Tangani error yang mungkin terjadi selama deteksi
//             print("Error dalam stream: $error");
//           })
//           .whenComplete(() {
//             // Bagian ini akan SELALU dijalankan, memastikan flag direset
//             if (mounted) {
//               setState(() {
//                 _isProcessing = false;
//               });
//             }
//           });
//     });

//     setState(() {
//       _isCameraInitialized = true;
//     });
//   }

//   List<double> _normalizeLandmarks(List<Landmark> landmarks) {
//     if (landmarks.isEmpty) return [];
//     final wrist = landmarks[0];
//     List<double> normalized = [];
//     for (var landmark in landmarks) {
//       normalized.add(landmark.x - wrist.x);
//       normalized.add(landmark.y - wrist.y);
//     }
//     return normalized;
//   }

//   @override
//   void dispose() {
//     _cameraController?.stopImageStream();
//     _cameraController?.dispose();
//     _handLandmarkerService.dispose();
//     _tfliteService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (_isCameraInitialized && _cameraController != null)
//             Positioned.fill(child: CameraPreview(_cameraController!))
//           else
//             const Center(child: CircularProgressIndicator()),

//           // // Painter untuk menggambar kerangka tangan
//           // CustomPaint(
//           //   size: Size.infinite,
//           //   painter: LandmarkPainter(
//           //     hands: _detectedHands,
//           //     cameraPreviewSize: _cameraController?.value.previewSize,
//           //   ),
//           // ),
//           _buildBackButton(),
//           _buildBottomPanel(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackButton() {
//     return Positioned(
//       top: 50,
//       left: 20,
//       child: GlassmorphicContainer(
//         width: 50,
//         height: 50,
//         borderRadius: 25,
//         blur: 10,
//         alignment: Alignment.center,
//         border: 1,
//         linearGradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.2),
//             Colors.white.withOpacity(0.1),
//           ],
//         ),
//         borderGradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.5),
//             Colors.white.withOpacity(0.2),
//           ],
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//     );
//   }

//   // Di dalam file scanner_page.dart

//   Widget _buildBottomPanel() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: GlassmorphicContainer(
//         width: MediaQuery.of(context).size.width,
//         height: 250,
//         borderRadius: 0,
//         blur: 15,
//         alignment: Alignment.center,
//         border: 0,
//         linearGradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.black.withOpacity(0.2),
//             Colors.black.withOpacity(0.1),
//           ],
//         ),
//         borderGradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.2),
//             Colors.white.withOpacity(0.1),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Huruf mentah yang terdeteksi secara real-time
//               Text(
//                 _currentPrediction ?? "-",
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.7),
//                   fontSize: 24,
//                 ),
//               ),
//               // Teks Kalimat yang Terbentuk
//               Text(
//                 _currentSentence.isEmpty
//                     ? "Arahkan tangan ke kamera"
//                     : _currentSentence,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               // Prediksi Kata (BAGIAN YANG DIPERBAIKI)
//               SizedBox(
//                 height: 40,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: _suggestions
//                       .map(
//                         (suggestion) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Chip(
//                             label: Text(suggestion),
//                             backgroundColor: Colors.white.withOpacity(0.8),
//                           ),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
