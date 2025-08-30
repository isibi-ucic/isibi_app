import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ScannerWebPage extends StatefulWidget {
  const ScannerWebPage({super.key});

  @override
  State<ScannerWebPage> createState() => _ScannerWebPageState();
}

class _ScannerWebPageState extends State<ScannerWebPage> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    const url =
        'https://scanner-web-eight.vercel.app/'; // GANTI DENGAN URL VERCEL ANDA

    // Langkah 1: Buat WebViewController terlebih dahulu
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _webViewController.runJavaScript('''
              var resetButton = document.getElementById('reset-button');
              if (resetButton) { resetButton.style.display = 'none'; }
              var debugOutput = document.getElementById('debug-output');
              if (debugOutput) { debugOutput.style.display = 'none'; }
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    // Langkah 2: Lakukan setup spesifik untuk Android setelah controller dibuat
    if (_webViewController.platform is AndroidWebViewController) {
      final androidController =
          _webViewController.platform as AndroidWebViewController;

      // Mengaktifkan mode Hybrid Composition
      AndroidWebViewController.enableDebugging(true);
      androidController.setMediaPlaybackRequiresUserGesture(false);

      // Mengatur handler untuk permintaan izin kamera dari WebView
      androidController.setOnPlatformPermissionRequest((request) {
        print('WebView meminta izin untuk: ${request.types.join(", ")}');
        // Secara otomatis memberikan izin untuk kamera
        request.grant();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan Stack untuk menumpuk WebView dan tombol
      body: Stack(
        children: [
          // Tampilan WebView
          WebViewWidget(controller: _webViewController),

          // Tampilkan loading indicator selagi halaman web dimuat
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Tombol Reset Native di Flutter
          _buildResetButton(),

          // Tombol Kembali
          _buildBackButton(),
        ],
      ),
    );
  }

  // Tombol kembali sederhana
  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back, color: Colors.grey),
      ),
    );
  }

  // Tombol reset yang memanggil fungsi JavaScript di WebView
  Widget _buildResetButton() {
    return Positioned(
      top: 50,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Panggil fungsi resetSentence() yang ada di script.js
          _webViewController.runJavaScript('resetSentence();');
        },
        child: const Icon(Icons.refresh, color: Colors.grey),
      ),
    );
  }
}
