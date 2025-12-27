import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pengaduan/views/auth/login_page.dart';
import 'package:app_pengaduan/views/dashboard.dart';
import 'package:app_pengaduan/views/kategori_pengaduan.dart';
import 'package:app_pengaduan/views/keluarga_berencana.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Pelaporan',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
      ),

      home: const LoginPage(),
      //Initial Route
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/kategori': (context) => const KategoriPengaduanPage(),
        '/KeluargaBerencana': (context) => const KbFormPage(),
      },
    );
  }
}
