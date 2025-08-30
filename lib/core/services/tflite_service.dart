// lib/core/services/tflite_service.dart
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

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

  // lib/core/services/tflite_service.dart

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/tflite/model_final_tf216.tflite',
      );
      print('Model TFLite 42-fitur berhasil dimuat.');
    } catch (e) {
      print('GAGAL TOTAL MEMUAT MODEL: $e');
      // Lempar error agar proses inisialisasi berhenti
      throw Exception('Gagal memuat model TFLite.');
    }
  }

  Future<String?> runInference(List<double> landmarks) async {
    // Pastikan input memiliki 42 fitur
    if (landmarks.length != 42) return null;

    var input = Float32List.fromList(landmarks).reshape([1, 42]);
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

    if (highestProb > 0.8) {
      // Ambang batas keyakinan 80%
      return _labels[highestProbIndex];
    }
    return null;
  }

  void dispose() {
    _interpreter.close();
  }
}
