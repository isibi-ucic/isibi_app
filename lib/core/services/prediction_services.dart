// // lib/services/prediction_service.dart

// // --- Implementasi Sederhana TrieNode ---
// class TrieNode {
//   Map<String, TrieNode> children = {};
//   bool isEndOfWord = false;
// }

// class PredictionService {
//   final TrieNode _root = TrieNode();

//   // Variabel untuk membentuk kalimat
//   String currentSentence = "";
//   String _lastPredictedLetter = "";
//   String _lastAddedLetter = "";
//   int _predictionCounter = 0;
//   static const int PREDICTION_THRESHOLD = 10; // Huruf stabil setelah 10 frame

//   PredictionService() {
//     _loadDictionary();
//   }

//   // Muat daftar kata dan bangun Trie
//   Future<void> _loadDictionary() async {
//     // Ganti ini dengan memuat file kamus dari assets Anda
//     List<String> words = [
//       "MAKAN",
//       "MINUM",
//       "SAYA",
//       "KAMU",
//       "APA",
//       "HALO",
//       "SELAMAT",
//     ];
//     for (var word in words) {
//       _insert(word.toUpperCase());
//     }
//   }

//   void _insert(String word) {
//     TrieNode node = _root;
//     for (var char in word.split('')) {
//       if (!node.children.containsKey(char)) {
//         node.children[char] = TrieNode();
//       }
//       node = node.children[char]!;
//     }
//     node.isEndOfWord = true;
//   }

//   // Fungsi utama yang dipanggil dari UI
//   void addCharacter(String newPrediction) {
//     if (newPrediction.isEmpty) return;

//     // Logika stabilisasi (debouncing)
//     if (newPrediction == _lastPredictedLetter) {
//       _predictionCounter++;
//     } else {
//       _predictionCounter = 1;
//       _lastPredictedLetter = newPrediction;
//     }

//     // Jika huruf sudah stabil dan berbeda dari yang terakhir ditambahkan
//     if (_predictionCounter >= PREDICTION_THRESHOLD &&
//         newPrediction != _lastAddedLetter) {
//       currentSentence += newPrediction;
//       _lastAddedLetter = newPrediction;
//     }
//   }

//   // Ambil saran kata dari Trie
//   List<String> getSuggestions() {
//     // Logika untuk mencari saran berdasarkan kata terakhir di currentSentence
//     // (Untuk kesederhanaan, kita kembalikan list statis dulu)
//     if (currentSentence.endsWith("MA")) return ["MAKAN"];
//     return [];
//   }

//   void clear() {
//     currentSentence = "";
//     _lastPredictedLetter = "";
//     _lastAddedLetter = "";
//     _predictionCounter = 0;
//   }
// }
