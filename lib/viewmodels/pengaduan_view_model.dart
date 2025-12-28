import 'dart:io';
import 'package:flutter/material.dart';
import '../model/pengaduan_model.dart';
import '../services/pengaduan_service.dart';

class PengaduanViewModel extends ChangeNotifier {
  final PengaduanService _service = PengaduanService();
  bool isLoading = false;
  String? errorMessage;
  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final noHpController = TextEditingController();
  final alamatController = TextEditingController();
  final keluhanController = TextEditingController();
  File? selectedImage;

  void setImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<bool> submitPengaduan({required String kategori}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      String? imageUrl;
      if (selectedImage != null) {
        imageUrl = await _service.uploadFoto(selectedImage!);
      }

      final pengaduan = PengaduanModel(
        kategori: kategori,
        nama: namaController.text.trim(),
        nik: nikController.text.trim(),
        noHp: noHpController.text.trim(),
        alamat: alamatController.text.trim(),
        keluhan: keluhanController.text.trim(),
        imageUrl: imageUrl,
        status: 'menunggu',
        createdAt: DateTime.now(),
      );

      await _service.submitPengaduan(pengaduan);

      _clearForm();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _clearForm() {
    namaController.clear();
    nikController.clear();
    noHpController.clear();
    alamatController.clear();
    keluhanController.clear();
    selectedImage = null;
  }

  @override
  void dispose() {
    namaController.dispose();
    nikController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    keluhanController.dispose();
    super.dispose();
  }
}
