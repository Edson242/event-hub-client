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
}