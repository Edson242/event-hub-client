import 'package:dio/dio.dart';
import 'package:myapp/dto/role.dto.dart';
import 'package:myapp/dto/user.dto.dart';
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

  Future<UserDTO?> getCurrentUser() async {
    try {
      final userJson = await _storageService.getUserJson();
      if (userJson != null) {
        print("[USER_SERVICE_DEBUG] User found in local storage.");
        final user = User.fromJsonString(userJson);
        return UserDTO.fromUser(user);
      }

      print("[USER_SERVICE_DEBUG] User not in storage, fetching from API '/users/me'...");
      final response = await _dio.get('$_endpoint/me');
      print("[USER_SERVICE_DEBUG] API response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _storageService.saveUser(user.toJson());
        print("[USER_SERVICE_DEBUG] User fetched from API and saved to storage.");
        return UserDTO.fromUser(user);
      } else {
        print("[USER_SERVICE_DEBUG] Error fetching user data from API, status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      print("[USER_SERVICE_DEBUG] Network error fetching user: ${e.message}");
      return null;
    } catch (e) {
      print("[USER_SERVICE_DEBUG] Unexpected error fetching user: $e");
      return null;
    }
  }

  Future<String?> updateUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _dio.put(
        '$_endpoint/me',
        data: {'name': name, 'email': email},
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
