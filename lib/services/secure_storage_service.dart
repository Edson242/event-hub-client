import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();

  static const _keyUserToken = 'user_token';

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyUserToken, value: token);
    } catch (e) {
      print("Erro ao salvar token: $e");
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyUserToken);
    } catch (e) {
      print("Erro ao ler token: $e");
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyUserToken);
    } catch (e) {
      print("Erro ao deletar token: $e");
    }
  }

  // --- Métodos para dados do usuário ---

  static const _keyUserData = 'user_data';

  Future<void> saveUser(String userJson) async {
    try {
      await _storage.write(key: _keyUserData, value: userJson);
    } catch (e) {
      print("Erro ao salvar dados do usuário: $e");
    }
  }

  Future<String?> getUserJson() async {
    try {
      return await _storage.read(key: _keyUserData);
    } catch (e) {
      print("Erro ao ler dados do usuário: $e");
      return null;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _storage.delete(key: _keyUserData);
    } catch (e) {
      print("Erro ao deletar dados do usuário: $e");
    }
  }
}