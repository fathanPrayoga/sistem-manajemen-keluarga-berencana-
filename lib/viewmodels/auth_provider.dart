import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    _user = _authService.currentUser;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signUp(email, password, name);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // Check if email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Reload user to get latest status (e.g. after clicking email link)
  Future<void> reloadUser() async {
    User? currentUser = _authService.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      _user = _authService.currentUser;
      notifyListeners();
    }
  }

  // Send verification email
  Future<void> sendVerificationEmail() async {
    if (_user != null && !_user!.emailVerified) {
      await _authService.sendVerificationEmail(_user!);
    }
  }
}
