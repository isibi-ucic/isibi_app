// lib/core/services/prediction_services.dart

// --- Implementasi Sederhana TrieNode ---
class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class PredictionService {
  final TrieNode _root = TrieNode();

  // Variabel untuk membentuk kalimat
  String currentSentence = "";
  String _lastPredictedLetter = "";
  String _lastAddedLetter = "";
  int _predictionCounter = 0;
  static const int PREDICTION_THRESHOLD = 30; // Huruf stabil setelah 10 frame

  PredictionService() {
    // Memanggil fungsi untuk memuat kamus saat service dibuat
    _loadDictionary();
  }

  // --- FUNGSI YANG HILANG - TAMBAHKAN INI ---
  // Muat daftar kata dan bangun Trie.
  // Nantinya, Anda bisa mengganti ini untuk memuat dari file aset.
  Future<void> _loadDictionary() async {
    List<String> words = [
      "MAKAN",
      "MINUM",
      "SAYA",
      "KAMU",
      "APA",
      "HALO",
      "SELAMAT",
      "PAGI",
      "SIANG",
      "SORE",
      "MALAM",
      "TERIMA",
      "KASIH",
    ];
    for (var word in words) {
      _insert(word.toUpperCase());
    }
    print("Kamus Trie berhasil dimuat dengan ${words.length} kata.");
  }
  // -----------------------------------------

  void _insert(String word) {
    TrieNode node = _root;
    for (var char in word.split('')) {
      if (!node.children.containsKey(char)) {
        node.children[char] = TrieNode();
      }
      node = node.children[char]!;
    }
    node.isEndOfWord = true;
  }

  // Fungsi utama yang dipanggil dari UI
  void addCharacter(String newPrediction) {
    if (newPrediction.isEmpty) return;

    if (newPrediction == _lastPredictedLetter) {
      _predictionCounter++;
    } else {
      _predictionCounter = 1;
      _lastPredictedLetter = newPrediction;
    }

    if (_predictionCounter >= PREDICTION_THRESHOLD &&
        newPrediction != _lastAddedLetter) {
      currentSentence += newPrediction;
      _lastAddedLetter = newPrediction;
    }
  }

  List<String> getSuggestions() {
    final words = currentSentence.split(' ');
    if (words.isEmpty) return [];

    final currentPrefix = words.last.toUpperCase();
    if (currentPrefix.isEmpty) return [];

    return _findWordsWithPrefix(currentPrefix);
  }

  List<String> _findWordsWithPrefix(String prefix) {
    TrieNode node = _root;
    for (var char in prefix.split('')) {
      if (!node.children.containsKey(char)) {
        return [];
      }
      node = node.children[char]!;
    }

    List<String> results = [];
    _collectWords(node, prefix, results);
    return results.take(3).toList();
  }

  void _collectWords(TrieNode node, String currentWord, List<String> results) {
    if (results.length >= 3) return;
    if (node.isEndOfWord) {
      results.add(currentWord);
    }
    node.children.forEach((char, childNode) {
      _collectWords(childNode, currentWord + char, results);
    });
  }

  void clear() {
    currentSentence = "";
    _lastPredictedLetter = "";
    _lastAddedLetter = "";
    _predictionCounter = 0;
  }
}
