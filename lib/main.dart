import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // File ini otomatis ada setelah flutterfire configure

// Import ViewModels
import 'package:app_pengaduan/viewmodels/kb_view_model.dart';

// Import Views
import 'package:app_pengaduan/pages/auth/login_page.dart';
import 'package:app_pengaduan/pages/dashboard.dart';
import 'package:app_pengaduan/pages/kategori_pengaduan.dart';
import 'package:app_pengaduan/views/kb_list_page.dart'; // Halaman List Utama KB
import 'package:app_pengaduan/pages/keluarga_berencana.dart'; // Halaman Form Tambah/Edit

void main() async {
  // 1. Memastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase Cloud Firestore
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Membungkus aplikasi dengan MultiProvider
    return MultiProvider(
      providers: [
        // Mendaftarkan KbViewModel agar bisa diakses di semua halaman
        ChangeNotifierProvider(create: (_) => KbViewModel()),
        // Jika nanti ada ViewModel lain (misal Auth), tambahkan di sini
      ],
      child: MaterialApp(
        title: 'Sistem Manajemen KB',
        debugShowCheckedModeBanner: false,
        
        // 4. Pengaturan Tema Global agar warna AppBar seragam
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF66BB6A), // Warna hijau yang kamu minta
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 5. Pengaturan Navigasi
        initialRoute: '/', // Halaman yang pertama kali muncul (Login)
        routes: {
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/kategori': (context) => const KategoriPengaduanPage(),
          
          // Fitur Keluarga Berencana (KB)
          '/KeluargaBerencana': (context) => const KbListPage(), // Menampilkan daftar dulu
          '/FormKB': (context) => const KbFormPage(),           // Form untuk Tambah/Edit
        },
      ),
    );
  }
}