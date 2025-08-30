// lib/core/services/tflite_service.dart

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';

class TFLiteService {
  late Interpreter _interpreter;
  final List<String> _labels = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      model: PoseDetectionModel.base,
      mode: PoseDetectionMode.stream,
    ),
  );

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/tflite/model.tflite');
      print('Model TFLite berhasil dimuat.');
    } catch (e) {
      print('Gagal memuat model TFLite: $e');
    }
  }

  Future<List<double>?> _processCameraImage(
    CameraImage image,
    int sensorOrientation,
  ) async {
    // --- PERBAIKAN 1: MENGGUNAKAN KONSTRUKTOR MODERN ---
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final inputImageData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation:
          InputImageRotationValue.fromRawValue(sensorOrientation) ??
          InputImageRotation.rotation0deg,
      format:
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    try {
      final List<Pose> poses = await _poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final Map<PoseLandmarkType, PoseLandmark> landmarksMap = pose.landmarks;

        // --- PERBAIKAN 2: MENGAMBIL LANDMARK SPESIFIK & BENAR ---
        // 1. Definisikan landmark tangan yang tersedia di PoseDetector
        final List<PoseLandmarkType> handLandmarks = [
          PoseLandmarkType.rightWrist,
          PoseLandmarkType.rightThumb,
          PoseLandmarkType.rightIndex,
          PoseLandmarkType.rightPinky,
          // Tambahkan landmark lain jika diperlukan, misal: leftWrist, dll.
        ];

        // 2. Pastikan landmark acuan (pergelangan tangan) ada
        final wristLandmark =
            landmarksMap[PoseLandmarkType.rightWrist] ??
            landmarksMap[PoseLandmarkType.leftWrist];

        if (wristLandmark != null) {
          List<double> normalizedLandmarks = [];
          final wristX = wristLandmark.x;
          final wristY = wristLandmark.y;

          // 3. Loop hanya pada landmark tangan yang sudah kita definisikan
          for (final type in handLandmarks) {
            final landmark = landmarksMap[type];
            if (landmark != null) {
              // Lakukan normalisasi
              normalizedLandmarks.add(landmark.x - wristX);
              normalizedLandmarks.add(landmark.y - wristY);
            } else {
              // Jika landmark tidak terdeteksi, tambahkan 0.0 sebagai placeholder
              normalizedLandmarks.add(0.0);
              normalizedLandmarks.add(0.0);
            }
          }
          return normalizedLandmarks;
        }
      }
    } catch (e) {
      print("Error saat memproses gambar dengan ML Kit: $e");
    }
    return null;
  }

  Future<String?> runInference(CameraImage image, int sensorOrientation) async {
    print("[DEBUG] Memproses gambar dengan format: ${image.format.group}");
    print("orientation: $sensorOrientation");

    final processedInput = await _processCameraImage(image, sensorOrientation);

    if (processedInput == null) {
      return null;
    }

    var input = Float32List.fromList(processedInput).reshape([1, 42]);
    var output = List.filled(
      1 * _labels.length,
      0.0,
    ).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    var highestProbIndex = 0;
    var highestProb = 0.0;
    for (int i = 0; i < _labels.length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        highestProbIndex = i;
      }
    }

    if (highestProb > 0.7) {
      return _labels[highestProbIndex];
    }
    return null;
  }

  void dispose() {
    _interpreter.close();
    _poseDetector.close(); // Penting untuk mencegah memory leak
  }
}
