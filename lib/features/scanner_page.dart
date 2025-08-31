import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import 'package:isibi_app/core/services/hand_landmarker_service.dart';
import 'package:isibi_app/core/services/landmark_painter.dart';
import 'package:isibi_app/core/services/prediction_services.dart';
import 'package:isibi_app/core/services/tflite_service.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Controller & State
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? _errorMessage;

  // Services (dideklarasikan sebagai late final)
  late final HandLandmarkerService _handLandmarkerService;
  late final TFLiteService _tfliteService;
  late final PredictionService _predictionService;

  // UI State
  List<Hand> _detectedHands = [];
  String? _currentPrediction;
  String _currentSentence = "";
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi service di sini, sesuai praktik terbaik 'late final'
    _handLandmarkerService = HandLandmarkerService();
    _tfliteService = TFLiteService();
    _predictionService = PredictionService();

    // Mulai seluruh proses setup
    _initializeAllServices();
  }

  Future<void> _initializeAllServices() async {
    try {
      // Tunggu semua service siap sebelum memulai kamera
      await _tfliteService.loadModel();
      await _handLandmarkerService.initialize();
      await _initializeCamera();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Gagal inisialisasi: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();

    _cameraController!.startImageStream((image) {
      if (_isProcessing) return; // Gerbang penjaga
      _isProcessing = true; // Kunci gerbangnya

      // Lakukan semua proses secara berurutan dan aman
      _handLandmarkerService
          .detect(image, _cameraController!.description.sensorOrientation)
          .then((hands) {
            if (hands.isNotEmpty) {
              final normalizedLandmarks = _normalizeLandmarks(
                hands.first.landmarks,
              );
              if (normalizedLandmarks.length == 42) {
                // Jalankan inferensi dan teruskan 'hands' untuk UI
                return _tfliteService
                    .runInference(normalizedLandmarks)
                    .then(
                      (prediction) => {
                        'prediction': prediction,
                        'hands': hands,
                      },
                    );
              }
            }
            // Jika tidak ada tangan atau landmarks, teruskan 'hands' saja
            return {'prediction': null, 'hands': hands};
          })
          .then((result) {
            // Lakukan casting pada 'result' menjadi Map<String, dynamic>
            final resultMap = result as Map<String, dynamic>;

            // Sekarang akses data dari resultMap yang sudah jelas tipenya
            final String? prediction = resultMap['prediction'] as String?;
            final List<Hand> hands = resultMap['hands'] as List<Hand>;

            if (prediction != null) {
              _predictionService.addCharacter(prediction);
            }

            // Lakukan satu kali setState di akhir dengan semua data baru
            if (mounted) {
              setState(() {
                _detectedHands = hands;
                _currentPrediction = prediction;
                _currentSentence = _predictionService.currentSentence;
                _suggestions = _predictionService.getSuggestions();
              });
            }
          })
          .whenComplete(() {
            // Selalu buka kembali gerbangnya, baik sukses maupun gagal
            _isProcessing = false;
          });
    });

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  List<double> _normalizeLandmarks(List<Landmark> landmarks) {
    if (landmarks.isEmpty) return [];
    final wrist = landmarks[0];
    List<double> normalized = [];
    for (var landmark in landmarks) {
      normalized.add(landmark.x - wrist.x);
      normalized.add(landmark.y - wrist.y);
    }
    return normalized;
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _handLandmarkerService.dispose();
    _tfliteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- TAMPILAN KONDISIONAL BARU ---
          if (_errorMessage != null)
            // 1. Jika ada error, tampilkan pesan error
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Terjadi Kesalahan:\n\n$_errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            )
          else if (_isCameraInitialized && _cameraController != null)
            // 2. Jika sukses, tampilkan kamera
            Center(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraController!),
                    CustomPaint(
                      size: Size.infinite,
                      painter: LandmarkPainter(
                        hands: _detectedHands,
                        cameraPreviewSize:
                            _cameraController!.value.previewSize!,
                        cameraLensDirection:
                            _cameraController!.description.lensDirection,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // 3. Jika masih loading, tampilkan spinner
            const Center(child: CircularProgressIndicator()),

          if (_errorMessage == null) ...[
            _buildBackButton(),
            _buildBottomPanel(),
          ],
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: GlassmorphicContainer(
        width: 50,
        height: 50,
        borderRadius: 25,
        blur: 10,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width,
        height: 250,
        borderRadius: 0,
        blur: 15,
        alignment: Alignment.center,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Huruf mentah yang terdeteksi secara real-time
              Text(
                _currentPrediction ?? "-",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 24,
                ),
              ),
              // Teks Kalimat yang Terbentuk
              Text(
                _currentSentence.isEmpty
                    ? "Arahkan tangan ke kamera"
                    : _currentSentence,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // Prediksi Kata (BAGIAN YANG DIPERBAIKI)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _suggestions
                      .map(
                        (suggestion) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label: Text(suggestion),
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
