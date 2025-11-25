import 'package:dio/dio.dart';
import 'package:myapp/services/secure_storage_service.dart';

/*
 * Este é o seu "Controlador de Requisições" centralizado.
 * Usamos o Dio para criar um cliente HTTP com interceptadores.
 * * O Interceptor 'onRequest' é a mágica:
 * 1. Antes de CADA requisição, ele é acionado.
 * 2. Ele busca o token no SecureStorage.
 * 3. Se o token existir, ele o adiciona ao Header 'Authorization'.
 * * Todas as chamadas feitas por este 'ApiService.dio' 
 * automaticamente incluirão o token de autenticação.
 */
class ApiService {
  // Instância singleton
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  late final Dio dio;
  final SecureStorageService _storageService = SecureStorageService();

  // URL base da sua API
  static const String _baseUrl =
      "https://event-hub-api-bjjd.onrender.com/eventHub/";

  ApiService._internal() {
    // Configuração base do Dio
    final baseOptions = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(baseOptions);

    // Adiciona o interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("[API_DEBUG] Request: ${options.method} ${options.path}");
          print("[API_DEBUG] Headers: ${options.headers}");
          if (options.data != null) {
            // ATENÇÃO: Logar dados sensíveis (senhas, etc.) em produção é uma má prática.
            // Este log é apenas para depuração local.
            print("[API_DEBUG] Data: ${options.data}");
          }

          // 1. Pega o token do storage
          final token = await _storageService.getToken();

          // 2. Adiciona o token ao Header, se existir
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print("[API_DEBUG] Token added to headers.");
          }

          // 3. Continua a requisição
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("[API_DEBUG] Response: ${response.statusCode} ${response.requestOptions.path}");
          print("[API_DEBUG] Response Data: ${response.data}"); // Pode conter dados sensíveis
          // Pode inspecionar respostas aqui, se necessário
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          print("[API_DEBUG] Error: ${e.response?.statusCode} ${e.requestOptions.path}");
          print("[API_DEBUG] Error Message: ${e.message}");
          print("[API_DEBUG] Error Response Data: ${e.response?.data}");
          /* * Aqui você pode tratar erros globalmente.
           * Ex: Se for um erro 401 (Não Autorizado),
           * talvez o token expirou. Você pode tentar
           * dar "refresh" no token ou deslogar o usuário.
           */
          if (e.response?.statusCode == 401) {
            // Ex: Deslogar o usuário
            await _storageService.deleteToken();
            // TODO: Navegar para a tela de Login
            print("Token inválido ou expirado. Usuário deslogado.");
          }
          return handler.next(e);
        },
      ),
    );
  }
}
