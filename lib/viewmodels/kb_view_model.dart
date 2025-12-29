import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/kb_service.dart';
import '../model/kb_model.dart';

class KbViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  List<KbModel> _listPendaftaran = [];
  bool _isLoading = false;

  List<KbModel> get listPendaftaran => _listPendaftaran;
  bool get isLoading => _isLoading;

  Future<void> fetchPendaftaran() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _listPendaftaran = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _listPendaftaran = await _service.getPendaftaran(user.uid);
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
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          data.userId = user.uid;
        }
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
