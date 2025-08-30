// lib/core/services/hand_landmarker_service.dart
import 'package:camera/camera.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import 'package:flutter/material.dart';

class HandLandmarkerService {
  HandLandmarkerPlugin? _plugin;

  Future<void> initialize() async {
    // Inisialisasi plugin dengan konfigurasi yang kita butuhkan
    _plugin = HandLandmarkerPlugin.create(
      numHands: 1, // Kita hanya butuh deteksi satu tangan
      minHandDetectionConfidence: 0.5,
      delegate: HandLandmarkerDelegate.GPU,
    );
  }

  Future<List<Hand>> detect(CameraImage image, int sensorOrientation) async {
    if (_plugin == null) return [];
    try {
      // Panggil fungsi detect dari plugin
      final hands = _plugin!.detect(image, sensorOrientation);
      return hands;
    } catch (e) {
      debugPrint('Error mendeteksi landmarks: $e');
      return [];
    }
  }

  void dispose() {
    _plugin?.dispose();
  }
}
