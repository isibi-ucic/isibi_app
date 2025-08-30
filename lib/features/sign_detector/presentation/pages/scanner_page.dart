// lib/pages/scanner_page.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:isibi_app/core/services/prediction_services.dart';
import 'package:isibi_app/core/services/tflite_service.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Controller & State Management
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  // Inisialisasi Services
  final PredictionService _predictionService = PredictionService();
  final TFLiteService _tfliteService = TFLiteService();

  // Variabel untuk menampilkan hasil di UI
  String? _currentPrediction;
  String _currentSentence = "";
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _tfliteService.loadModel();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      // imageFormatGroup:
      //     ImageFormatGroup.yuv420, // Tetap gunakan ini untuk stabilitas
    );
    await _cameraController!.initialize();

    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });

    _cameraController!.startImageStream((image) {
      if (_isProcessing) return;

      setState(() {
        _isProcessing = true;
      });

      // Panggil runInference dengan int dari orientasi perangkat
      _tfliteService
          .runInference(image, _cameraController!.value.deviceOrientation.index)
          .then((prediction) {
            // Logika disederhanakan karena 'prediction' kini adalah String?
            if (prediction != null && prediction.isNotEmpty) {
              _predictionService.addCharacter(prediction);

              if (mounted) {
                setState(() {
                  _currentPrediction = prediction;
                  _currentSentence = _predictionService.currentSentence;
                  _suggestions = _predictionService.getSuggestions();
                });
              }
            }
          })
          .whenComplete(() {
            if (mounted) {
              setState(() {
                _isProcessing = false;
              });
            }
          });
    });
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _tfliteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Center(child: CircularProgressIndicator()),

          _buildBackButton(),
          _buildBottomPanel(),
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
              Text(
                _currentPrediction ?? "-",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 24,
                ),
              ),
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
