import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  /// Obtener el usuario actual
  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final name = (user.userMetadata?['name'] as String?) ??
        (user.email != null ? user.email!.split('@').first : 'Usuario');

    return AppUser(
      uid: user.id,
      email: user.email ?? '',
      displayName: name,
    );
  }

  /// Stream para escuchar los cambios de estado de autenticación
  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user ?? _client.auth.currentUser;
      if (user == null) return null;

      final name = (user.userMetadata?['name'] as String?) ??
          (user.email != null ? user.email!.split('@').first : 'Usuario');

      return AppUser(
        uid: user.id,
        email: user.email ?? '',
        displayName: name,
      );
    });
  }

  /// Iniciar sesión con Correo y Contraseña
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al iniciar sesión.');
    }
  }

  /// Registrar nuevo usuario con Nombre, Correo y Contraseña
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {'name': name.trim()},
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado durante el registro.');
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Traducir errores comunes de Supabase Auth al español
  String _handleAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') || msg.contains('invalid credentials')) {
      return 'Correo o contraseña incorrectos.';
    } else if (msg.contains('user already registered') || msg.contains('already in use')) {
      return 'Ya existe una cuenta vinculada a este correo electrónico.';
    } else if (msg.contains('invalid email')) {
      return 'El formato de correo electrónico no es válido.';
    } else if (msg.contains('password should be at least')) {
      return 'La contraseña proporcionada es demasiado débil.';
    }
    return e.message;
  }
}
