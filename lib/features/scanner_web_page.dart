import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ScannerWebPage extends StatefulWidget {
  const ScannerWebPage({super.key});

  @override
  State<ScannerWebPage> createState() => _ScannerWebPageState();
}

class _ScannerWebPageState extends State<ScannerWebPage> {
  WebViewController? _webViewController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initAndRequestPermission();
  }

  // --- Helper function untuk menampilkan SnackBar ---
  void _showDebugSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    // Hapus SnackBar lama jika ada
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // Tampilkan SnackBar baru
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- FUNGSI BARU UNTUK MENGELOLA IZIN DAN INISIALISASI ---
  Future<void> _initAndRequestPermission() async {
    // 2. Minta izin kamera terlebih dahulu
    final cameraPermissionStatus = await Permission.camera.request();

    if (cameraPermissionStatus.isGranted) {
      // 3. JIKA DIIZINKAN: Lanjutkan inisialisasi WebView
      _initializeWebView();
    } else {
      // 4. JIKA DITOLAK: Tampilkan pesan error
      setState(() {
        _errorMessage =
            "Izin kamera ditolak. Aplikasi tidak dapat melanjutkan.\n\n"
            "Silakan berikan izin kamera di pengaturan HP Anda untuk menggunakan fitur ini.";
        _isLoading = false;
      });
    }
  }

  void _initializeWebView() {
    const url = 'https://scanner-web-eight.vercel.app/';

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted)
              setState(() {
                _isLoading = false;
              });
            _webViewController?.runJavaScript('''
              document.getElementById('reset-button')?.remove();
              document.getElementById('debug-output')?.remove();
            ''');
          },
          onWebResourceError: (error) {
            if (mounted)
              setState(
                () => _errorMessage =
                    "Gagal memuat halaman: ${error.description}",
              );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController.setOnPlatformPermissionRequest((request) {
        // Otomatis grant karena izin utama sudah diberikan
        request.grant();
      });
    }

    // Set controller ke state setelah semua konfigurasi selesai
    setState(() {
      _webViewController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_errorMessage != null)
            // Tampilkan pesan error jika izin ditolak
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            )
          else if (_webViewController != null)
            // Tampilkan WebView jika controller sudah siap
            WebViewWidget(controller: _webViewController!)
          else
            // Tampilkan loading indicator selama proses izin/inisialisasi
            const Center(child: CircularProgressIndicator()),

          // Tampilkan loading indicator di atas WebView saat halaman web sedang dimuat
          if (_isLoading && _errorMessage == null)
            const Center(child: CircularProgressIndicator()),

          // Sembunyikan tombol jika ada error
          if (_errorMessage == null && !_isLoading) ...[
            _buildBackButton(),
            _buildResetButton(),
          ],
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
          _webViewController?.runJavaScript('resetSentence();');
        },
        child: const Icon(Icons.refresh, color: Colors.grey),
      ),
    );
  }
}
