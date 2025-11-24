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
    try {
      // 1. Faz a chamada de API usando o Dio do ApiService
      final response = await _dio.post(
        'auth/login', // Endpoint de login (ex: 'login' ou 'auth/login')
        data: {
          'email': email,
          'password': password,
        },
      );

      // 2. Verifica se a resposta foi bem-sucedida (status code 200-299)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // 3. Pega o token da resposta
        //    Ajuste 'token' para a chave correta que sua API retorna
        //    (ex: response.data['access_token'] ou response.data['data']['token'])
        final String? token = response.data['token'];

        if (token != null && token.isNotEmpty) {
          // 4. Salva o token no cofre
          await _storageService.saveToken(token);
          
          // 5. Retorna null (indicando sucesso para a UI)
          return null;
        } else {
          return "API não retornou um token válido.";
        }
      } else {
        // Se a API retornar um status inesperado
        return "Erro inesperado do servidor.";
      }
    } on DioException catch (e) {
      // Trata erros específicos do Dio (rede, 404, 401, etc.)
      if (e.response != null) {
        // Tenta pegar a mensagem de erro da API (ex: "Credenciais inválidas")
        // Ajuste 'message' para a chave de erro da sua API
        return e.response?.data['message'] ?? "Credenciais inválidas.";
      } else {
        // Erro de conexão ou timeout
        return "Erro de conexão. Verifique sua internet.";
      }
    } catch (e) {
      // Pega qualquer outro erro inesperado
      return "Ocorreu um erro inesperado: $e";
    }
  }
  
  // Função de Logout
  Future<void> logoutUser() async {
    // Deleta o token do cofre
    await _storageService.deleteToken();
    
    // Aqui você também pode limpar qualquer estado local (ex: Provider, Riverpod)
    
    // NOTA: A navegação para a tela de Login deve ser feita na UI
    // após chamar esta função.
  }
}