import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/kb_view_model.dart';
import '/model/kb_model.dart';

class KbListPage extends StatefulWidget {
  const KbListPage({super.key});

  @override
  State<KbListPage> createState() => _KbListPageState();
}

class _KbListPageState extends State<KbListPage> {
  @override
  void initState() {
    super.initState();
    // Mengambil data terbaru dari Firebase saat halaman dibuka
    Future.delayed(Duration.zero, () {
      context.read<KbViewModel>().fetchPendaftaran();
    });
  }

  // FUNGSI KONFIRMASI HAPUS
  void _confirmDelete(BuildContext context, KbViewModel viewModel, String id) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus data pendaftaran ini?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), // Tutup dialog tanpa hapus
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.hapusPendaftaran(id); // Jalankan hapus di Firebase
                Navigator.pop(ctx); // Tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data berhasil dihapus"), backgroundColor: Colors.red),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<KbViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pendaftaran KB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF66BB6A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.listPendaftaran.isEmpty
              ? const Center(child: Text("Belum ada data pendaftar. Klik + untuk menambah."))
              : RefreshIndicator(
                  onRefresh: () => viewModel.fetchPendaftaran(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: viewModel.listPendaftaran.length,
                    itemBuilder: (context, index) {
                      final data = viewModel.listPendaftaran[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE8F5E9),
                            child: Icon(Icons.person, color: Colors.green[800]),
                          ),
                          title: Text(data.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text("NIK: ${data.nik}\nLayanan: ${data.layanan}"),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Edit
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => Navigator.pushNamed(context, '/FormKB', arguments: data),
                              ),
                              // Tombol Hapus dengan Konfirmasi
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, viewModel, data.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/FormKB'),
        backgroundColor: const Color(0xFF388E3C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}