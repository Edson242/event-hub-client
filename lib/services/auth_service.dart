import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/secure_storage_service.dart';

class AuthService {
  final Dio _dio = ApiService().dio;
  final SecureStorageService _storageService = SecureStorageService();

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    print("[AUTH_DEBUG] Attempting login for email: $email");
    try {
      print("[AUTH_DEBUG] Sending login request to 'auth/login'...");
      // 1. Faz a chamada de API usando o Dio do ApiService
      final response = await _dio.post(
        'auth/login', // Endpoint de login (ex: 'login' ou 'auth/login')
        data: {'email': email, 'password': password},
      );
      print("[AUTH_DEBUG] Login response status: ${response.statusCode}");

      // 2. Verifica se a resposta foi bem-sucedida (status code 200-299)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // 3. Pega o token da resposta
        //    Ajuste 'token' para a chave correta que sua API retorna
        //    (ex: response.data['access_token'] ou response.data['data']['token'])
        final String? token = response.data['token'];

        if (token != null && token.isNotEmpty) {
          print("[AUTH_DEBUG] Token received. Saving token and user data...");

          // 4. Pega os dados do usuário e salva junto com o token
          final user = response.data['user'];
          if (user != null) {
            final userJson = jsonEncode(user);
            await Future.wait([
              _storageService.saveToken(token),
              _storageService.saveUser(userJson),
            ]);
            print("[AUTH_DEBUG] Token and user data saved successfully.");
          } else {
            // Se não vier o usuário, salva só o token
            await _storageService.saveToken(token);
            print("[AUTH_DEBUG] Token saved. User data not found in response.");
          }

          // 5. Retorna null (indicando sucesso para a UI)
          return null;
        } else {
          print("[AUTH_DEBUG] API did not return a valid token.");
          return "API não retornou um token válido.";
        }
      } else {
        // Se a API retornar um status inesperado
        print("[AUTH_DEBUG] Unexpected server status: ${response.statusCode}");
        return "Erro inesperado do servidor.";
      }
    } on DioException catch (e) {
      print("[AUTH_DEBUG] DioException during login: ${e.message}");
      if (e.response != null) {
        print("[AUTH_DEBUG] DioError response data: ${e.response?.data}");
        // Tenta pegar a mensagem de erro da API (ex: "Credenciais inválidas")
        // Ajuste 'message' para a chave de erro da sua API
        return e.response?.data['message'] ?? "Credenciais inválidas.";
      } else {
        // Erro de conexão ou timeout
        print("[AUTH_DEBUG] DioError: No response, likely connection issue.");
        return "Erro de conexão. Verifique sua internet.";
      }
    } catch (e, stackTrace) {
      // Pega qualquer outro erro inesperado
      print("[AUTH_DEBUG] Unexpected error during login: $e");
      print("[AUTH_DEBUG] Stack trace: $stackTrace");
      return "Ocorreu um erro inesperado: $e";
    }
  }

  // Função de Logout
  Future<void> logoutUser() async {
    print("[AUTH_DEBUG] logoutUser() called. Deleting token and user data...");
    // Deleta o token e os dados do usuário
    await Future.wait([
      _storageService.deleteToken(),
      _storageService.deleteUser(),
    ]);
    print("[AUTH_DEBUG] Token and user data deleted. User logged out.");

    // Aqui você também pode limpar qualquer estado local (ex: Provider, Riverpod)

    // NOTA: A navegação para a tela de Login deve ser feita na UI
    // após chamar esta função.
  }
}
