// lib/services/auth_service.dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<bool> isUserLoggedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        // Guardar sesión localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSignedIn', true);
        return true;
      }
    } catch (e) {
      debugPrint('Error al verificar sesión: $e');
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isSignedIn');
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    }
  }
}
