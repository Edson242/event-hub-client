import 'package:dio/dio.dart';
import 'package:myapp/dto/role.dto.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/services/secure_storage_service.dart';

class UserService {
  final Dio _dio = ApiService().dio;
  final SecureStorageService _storageService = SecureStorageService();

  final String _endpoint = '/users'; 

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required RoleType role,
  }) async {
    try {
      final response = await _dio.post(
        _endpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        
        final String? token = response.data['token'];

        if (token != null && token.isNotEmpty) {
          await _storageService.saveToken(token);

          // print("Usuário cadastrado E logado com sucesso.");
        } else {
          // print("Usuário cadastrado. Faça o login.");
        }
        
        return null;
      } else {
        return "Erro inesperado do servidor.";
      }

    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 409) {
          return "Este e-mail já está em uso.";
        }

        return e.response?.data['message'] ?? "Erro ao cadastrar.";
      } else {
        return "Erro de conexão. Verifique sua internet.";
      }
    } catch (e) {
      return "Ocorreu um erro inesperado: $e";
    }
  }

  Future<UserDTO> getCurrentUser() async {
    try {
      final response = await _dio.get('$_endpoint/me');

      if (response.statusCode == 200) {
        return UserDTO.fromJson(response.data);
      } else {
        throw Exception("Erro ao buscar dados do usuário.");
      }
    } on DioException catch (e) {
      throw Exception("Erro de rede: ${e.message}");
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<String?> updateUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _dio.put(
        '$_endpoint/me',
        data: {
          'name': name,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return "Erro inesperado do servidor.";
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? "Erro ao atualizar perfil.";
      } else {
        return "Erro de conexão. Verifique sua internet.";
      }
    } catch (e) {
      return "Ocorreu um erro inesperado: $e";
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      final response = await _dio.delete('$_endpoint/me');

      if (response.statusCode == 200) {
        await _storageService.deleteToken();
      } else {
        throw Exception("Erro ao deletar conta.");
      }
    } on DioException catch (e) {
      throw Exception("Erro de rede: ${e.message}");
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }
}