import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/profile.dart';

//! el ProfileService es el encargado de hacer las peticiones a la API de usuarios
class ProfileService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los usuarios
  // * se crea una instancia del modelo Profile, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de usuarios

  Future<List<Profile>> getAllUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de Profile
      return data.map((userJson) => Profile.fromJson(userJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de usuarios.');
    }
  }

  // Método para obtener el detalle de un usuario por ID
  Future<Profile> getUserById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data); // se retorna el detalle del usuario
    } else {
      throw Exception('Error al obtener el detalle del usuario');
    }
  }

  // Método para obtener un usuario por email
  Future<Profile> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/email?email=${Uri.encodeComponent(email)}'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data); // se retorna el usuario encontrado
    } else {
      throw Exception('Error al obtener el usuario por email');
    }
  }

  // Método para login de usuario
  Future<Profile> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/usuario-service/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data); // se retorna el usuario autenticado
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales incorrectas');
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Método para obtener usuarios por rol
  Future<List<Profile>> getUsersByRole(String rol) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/rol/$rol'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((userJson) => Profile.fromJson(userJson)).toList();
    } else {
      throw Exception('Error al obtener usuarios por rol: $rol');
    }
  }

  // Método para obtener usuarios activos
  Future<List<Profile>> getActiveUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/activos'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((userJson) => Profile.fromJson(userJson)).toList();
    } else {
      throw Exception('Error al obtener usuarios activos');
    }
  }

  // Método para buscar usuarios por nombre
  Future<List<Profile>> searchUsersByName(String query) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/buscar?q=${Uri.encodeComponent(query)}'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((userJson) => Profile.fromJson(userJson)).toList();
    } else {
      throw Exception('Error al buscar usuarios por nombre');
    }
  }

  // Método para verificar si existe un email
  Future<bool> emailExists(String email) async {
    final response = await http.get(Uri.parse('$apiUrl/usuario-service/usuarios/existe?email=${Uri.encodeComponent(email)}'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Error al verificar existencia del email');
    }
  }

  // Método para crear un nuevo usuario
  Future<Profile> createUser(Profile user) async {
    final response = await http.post(
      Uri.parse('$apiUrl/usuario-service/usuario'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(user.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('Datos de usuario inválidos');
    } else {
      throw Exception('Error al crear el usuario');
    }
  }

  // Método para actualizar un usuario existente
  Future<Profile> updateUser(Profile user) async {
    final response = await http.put(
      Uri.parse('$apiUrl/usuario-service/usuario'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(user.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('Datos de usuario inválidos');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al actualizar el usuario');
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/usuario-service/usuarios/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  // Método de utilidad para obtener usuarios con filtros comunes
  Future<List<Profile>> getUsersWithFilters({
    String? rol,
    bool? onlyActive = false,
    String? searchQuery,
  }) async {
    try {
      // Si se especifica un rol, obtener usuarios por rol
      if (rol != null) {
        return await getUsersByRole(rol);
      }
      
      // Si solo se quieren usuarios activos
      if (onlyActive == true) {
        return await getActiveUsers();
      }
      
      // Si se especifica una búsqueda, buscar por nombre
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return await searchUsersByName(searchQuery);
      }
      
      // Si no hay filtros específicos, obtener todos los usuarios
      return await getAllUsers();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getUsersWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar el rol del usuario
  bool isValidUserRole(String rol) {
    const validRoles = [
      'ADMIN',
      'MANAGER',
      'WAITER',
      'CHEF',
      'CUSTOMER',
      'USER'
    ];
    return validRoles.contains(rol.toUpperCase());
  }

  // Método de utilidad para validar el estado del usuario
  bool isValidUserStatus(String estado) {
    const validStatuses = [
      'ACTIVO',
      'INACTIVO',
      'SUSPENDIDO',
      'BLOQUEADO'
    ];
    return validStatuses.contains(estado.toUpperCase());
  }

  // Método de utilidad para validar email básico
  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Método de utilidad para obtener usuarios por rol específico
  Future<List<Profile>> getAdminUsers() async {
    return await getUsersByRole('ADMIN');
  }

  Future<List<Profile>> getManagerUsers() async {
    return await getUsersByRole('MANAGER');
  }

  Future<List<Profile>> getWaiterUsers() async {
    return await getUsersByRole('WAITER');
  }

  Future<List<Profile>> getChefUsers() async {
    return await getUsersByRole('CHEF');
  }

  Future<List<Profile>> getCustomerUsers() async {
    return await getUsersByRole('CUSTOMER');
  }

  // Método de utilidad para cambiar estado de usuario
  Future<Profile> activateUser(int userId) async {
    final user = await getUserById(userId);
    final updatedUser = user.copyWith(estUsuario: 'ACTIVO');
    return await updateUser(updatedUser);
  }

  Future<Profile> deactivateUser(int userId) async {
    final user = await getUserById(userId);
    final updatedUser = user.copyWith(estUsuario: 'INACTIVO');
    return await updateUser(updatedUser);
  }

  Future<Profile> suspendUser(int userId) async {
    final user = await getUserById(userId);
    final updatedUser = user.copyWith(estUsuario: 'SUSPENDIDO');
    return await updateUser(updatedUser);
  }

  Future<Profile> blockUser(int userId) async {
    final user = await getUserById(userId);
    final updatedUser = user.copyWith(estUsuario: 'BLOQUEADO');
    return await updateUser(updatedUser);
  }

  // Método de utilidad para cambiar password
  Future<Profile> changePassword(int userId, String newPassword) async {
    final user = await getUserById(userId);
    final updatedUser = user.copyWith(password: newPassword);
    return await updateUser(updatedUser);
  }

  
}
