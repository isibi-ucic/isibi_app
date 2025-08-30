import 'package:flutter/material.dart';
// Ganti dengan path file Anda yang benar
import 'main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I-Sibi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor:
            Colors.grey.shade100, // Warna latar belakang app
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}
