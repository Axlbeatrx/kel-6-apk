import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Pastikan path ini benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RESTful API Kel 6',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(
        // Ganti LoginScreen dengan LoginPage
        isDarkMode: false,
        toggleTheme: () {}, // Tambahkan toggleTheme jika dibutuhkan
      ),
    );
  }
}
