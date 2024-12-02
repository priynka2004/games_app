import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:games_app/auth/mail/login/model/user_model.dart';
import 'package:games_app/auth/mail/service/firebase_auth_service.dart';
import 'package:games_app/auth/mail/ui/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  bool isVisible = false;
  bool isLoading = false;
  String? error;

  AuthProvider(this.authService);

  void setPasswordFieldStatus() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future<void> registerUser(UserModel user) async {
    _setLoading(true);
    error = null;
    try {
      await authService.signUp(user);
      await _setLoginStatus(true);
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> isUserExists(UserModel user) async {
    _setLoading(true);
    error = null;
    bool result = false;
    try {
      result = await authService.login(user);
      if (result) await _setLoginStatus(true);
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
    return result;
  }

  Future<void> logoutUser(BuildContext context) async {
    await _setLoginStatus(false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
    notifyListeners();
  }

  Future<void> _setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

}
