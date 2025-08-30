// Fungsi untuk membuat route dengan animasi FADE
import 'package:flutter/material.dart';

Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    // Halaman tujuan yang akan ditampilkan
    pageBuilder: (context, animation, secondaryAnimation) => page,

    // Builder untuk membuat animasinya
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animation adalah nilai dari 0.0 hingga 1.0 yang dikontrol oleh Flutter
      return FadeTransition(
        opacity: animation,
        child: child, // child adalah halaman tujuan (page)
      );
    },

    // Durasi transisi
    transitionDuration: const Duration(milliseconds: 400),
  );
}
