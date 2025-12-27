import 'package:flutter/material.dart';
import '../services/kb_service.dart';
import '../model/kb_model.dart';

class KbViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  List<KbModel> _listPendaftaran = [];
  bool _isLoading = false;

  List<KbModel> get listPendaftaran => _listPendaftaran;
  bool get isLoading => _isLoading;

  Future<void> fetchPendaftaran() async {
    _isLoading = true;
    notifyListeners();
    try {
      _listPendaftaran = await _service.getPendaftaran();
    } catch (e) {
      debugPrint("Error Fetch: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> simpanPendaftaran({
    required KbModel data,
    bool isEdit = false,
    String? id,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (isEdit) {
        await _service.updatePendaftaran(id!, data);
      } else {
        await _service.addPendaftaran(data);
      }
      await fetchPendaftaran();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> hapusPendaftaran(String id) async {
    await _service.deletePendaftaran(id);
    await fetchPendaftaran();
  }
}
