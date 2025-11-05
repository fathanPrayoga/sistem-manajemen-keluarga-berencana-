import 'package:flutter/material.dart';
// import 'package:app_pengaduan/pages/auth/login_page.dart';
import 'package:app_pengaduan/pages/dashboard.dart';

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

      home:  const DashboardPage(),
      //Initial Route
      initialRoute: '/',
      routes: {
        // '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
