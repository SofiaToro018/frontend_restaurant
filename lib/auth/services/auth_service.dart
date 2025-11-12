import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../models/register.dart';

/// Estados de autenticación
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Resultado de una operación de autenticación
class AuthResult {
  final AuthState state;
  final Usuario? usuario;
  final String? errorMessage;

  AuthResult({
    required this.state,
    this.usuario,
    this.errorMessage,
  });

  // Factory methods para diferentes estados
  factory AuthResult.loading() {
    return AuthResult(state: AuthState.loading);
  }

  factory AuthResult.authenticated(Usuario usuario) {
    return AuthResult(
      state: AuthState.authenticated,
      usuario: usuario,
    );
  }

  factory AuthResult.unauthenticated() {
    return AuthResult(state: AuthState.unauthenticated);
  }

  factory AuthResult.error(String message) {
    return AuthResult(
      state: AuthState.error,
      errorMessage: message,
    );
  }

  // Getters de conveniencia
  bool get isLoading => state == AuthState.loading;
  bool get isAuthenticated => state == AuthState.authenticated;
  bool get isUnauthenticated => state == AuthState.unauthenticated;
  bool get hasError => state == AuthState.error;
  bool get hasUsuario => usuario != null;
}

/// Servicio de autenticación principal
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Usuario actual en memoria
  Usuario? _currentUsuario;
  Usuario? get currentUsuario => _currentUsuario;

  // URL de tu API desde el .env
  String get apiUrl => dotenv.env['API_URL']!;

  // Listeners para cambios en el estado de autenticación
  final List<Function(Usuario?)> _authStateListeners = [];

  /// Agregar un listener para cambios en el estado de autenticación
  void addAuthStateListener(Function(Usuario?) listener) {
    _authStateListeners.add(listener);
  }

  /// Remover un listener
  void removeAuthStateListener(Function(Usuario?) listener) {
    _authStateListeners.remove(listener);
  }

  /// Notificar a todos los listeners sobre cambios en el estado
  void _notifyAuthStateChange() {
    for (final listener in _authStateListeners) {
      listener(_currentUsuario);
    }
  }

  /// Inicializar el servicio - verificar si hay una sesión guardada
  Future<AuthResult> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        final usuario = Usuario.fromJson(userMap);
        
        // Verificar si el usuario sigue siendo válido en el servidor
        final isValid = await _validateUser(usuario);
        
        if (isValid) {
          _currentUsuario = usuario;
          _notifyAuthStateChange();
          return AuthResult.authenticated(usuario);
        } else {
          // Usuario ya no válido, limpiar datos locales
          await _clearLocalData();
        }
      }
      
      return AuthResult.unauthenticated();
    } catch (e) {
      if (kDebugMode) {
        print('Error inicializando autenticación: $e');
      }
      return AuthResult.error('Error al inicializar la autenticación');
    }
  }

  /// Realizar login con email y contraseña usando tu endpoint /login
  Future<AuthResult> loginWithEmailAndPassword(LoginRequest request) async {
    try {
      if (!request.isValid) {
        return AuthResult.error('Email o contraseña inválidos');
      }

      // Hacer petición a tu endpoint de login
      // Nota: Tu endpoint usa parámetros, no JSON body
      final uri = Uri.parse('$apiUrl/usuario-service/login')
          .replace(queryParameters: {
        'email': request.email,
        'password': request.password,
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        // Login exitoso, parsear el usuario
        final Map<String, dynamic> data = jsonDecode(response.body);
        final usuario = Usuario.fromJson(data);
        
        // Verificar que el usuario esté activo
        if (!usuario.isActive) {
          return AuthResult.error('Usuario inactivo. Contacta al administrador.');
        }

        // Guardar usuario en memoria y almacenamiento local
        _currentUsuario = usuario;
        await _saveUserToLocal(usuario);
        _notifyAuthStateChange();
        
        return AuthResult.authenticated(usuario);
      } else if (response.statusCode == 401) {
        return AuthResult.error('Email o contraseña incorrectos');
      } else {
        return AuthResult.error('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en login: $e');
      }
      return AuthResult.error('Error de conexión. Verifica tu internet.');
    }
  }

  /// Realizar logout y limpiar todos los datos
  Future<void> logout() async {
    try {
      // Limpiar datos locales y en memoria
      await _clearLocalData();
      _currentUsuario = null;
      _notifyAuthStateChange();
    } catch (e) {
      if (kDebugMode) {
        print('Error en logout: $e');
      }
    }
  }

  /// Verificar si el usuario está autenticado
  bool get isAuthenticated => _currentUsuario != null;

  /// Obtener usuario por email (útil para validaciones)
  Future<Usuario?> getUserByEmail(String email) async {
    try {
      final uri = Uri.parse('$apiUrl/usuario-service/usuarios/email')
          .replace(queryParameters: {'email': email});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Usuario.fromJson(data);
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo usuario por email: $e');
      }
      return null;
    }
  }

  /// Verificar si un email ya existe
  Future<bool> emailExists(String email) async {
    try {
      final uri = Uri.parse('$apiUrl/usuario-service/usuarios/existe')
          .replace(queryParameters: {'email': email});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response.body.toLowerCase() == 'true';
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error verificando email: $e');
      }
      return false;
    }
  }

  /// Métodos privados para manejo de datos locales

  /// Guardar usuario en almacenamiento local
  Future<void> _saveUserToLocal(Usuario usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(usuario.toJson()));
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando usuario localmente: $e');
      }
    }
  }

  /// Limpiar datos locales
  Future<void> _clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
    } catch (e) {
      if (kDebugMode) {
        print('Error limpiando datos locales: $e');
      }
    }
  }

  /// Validar si un usuario sigue siendo válido en el servidor
  Future<bool> _validateUser(Usuario usuario) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/usuario-service/usuarios/${usuario.id}')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final serverUser = Usuario.fromJson(data);
        
        // Verificar que el usuario siga activo
        return serverUser.isActive;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error validando usuario: $e');
      }
      return false;
    }
  }

  /// Actualizar datos del usuario actual
  Future<AuthResult> updateCurrentUser() async {
    if (_currentUsuario == null) {
      return AuthResult.unauthenticated();
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/usuario-service/usuarios/${_currentUsuario!.id}')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final updatedUser = Usuario.fromJson(data);
        
        if (updatedUser.isActive) {
          _currentUsuario = updatedUser;
          await _saveUserToLocal(updatedUser);
          _notifyAuthStateChange();
          return AuthResult.authenticated(updatedUser);
        } else {
          // Usuario fue desactivado
          await logout();
          return AuthResult.error('Tu cuenta ha sido desactivada');
        }
      } else {
        return AuthResult.error('Error actualizando datos del usuario');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error actualizando usuario: $e');
      }
      return AuthResult.error('Error de conexión');
    }
  }

  /// Registra un nuevo usuario
  Future<RegisterResponse> registerUser(RegisterRequest registerRequest) async {
    try {
      // Usar la misma configuración que el resto del servicio
      final url = Uri.parse('$apiUrl/usuario-service/usuario');

      if (kDebugMode) {
        print('Registrando usuario en: $url');
        print('Datos del registro: ${registerRequest.toJson()}');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(registerRequest.toJson()),
      );

      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro exitoso
        try {
          final responseData = jsonDecode(response.body);
          // Opcional: crear objeto Usuario si el servidor lo devuelve
          Usuario? usuario;
          if (responseData is Map<String, dynamic>) {
            usuario = Usuario.fromJson(responseData);
          }
          
          return RegisterResponse.success(
            message: '¡Registro exitoso! Redirigiendo al login...',
            usuario: usuario,
          );
        } catch (e) {
          // Si hay error parseando la respuesta, pero el status es exitoso
          return RegisterResponse.success();
        }
      } else {
        // Error del servidor
        String errorMessage = 'Error en el registro';
        
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'];
            } else if (errorData.containsKey('error')) {
              errorMessage = errorData['error'];
            } else if (errorData.containsKey('details')) {
              errorMessage = errorData['details'];
            }
          }
        } catch (e) {
          // Si no se puede parsear el error, usar mensaje genérico
          switch (response.statusCode) {
            case 400:
              errorMessage = 'Datos inválidos. Verifica la información ingresada.';
              break;
            case 409:
              errorMessage = 'Este email ya está registrado. Intenta con otro.';
              break;
            case 500:
              errorMessage = 'Error interno del servidor. Inténtalo más tarde.';
              break;
            default:
              errorMessage = 'Error en el registro. Código: ${response.statusCode}';
          }
        }
        
        return RegisterResponse.error(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error registrando usuario: $e');
      }
      
      // Determinar tipo de error
      String errorMessage = 'Error de conexión. Verifica tu internet.';
      if (e.toString().contains('SocketException') || 
          e.toString().contains('NetworkException')) {
        errorMessage = 'Sin conexión a internet. Verifica tu conexión.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado. Inténtalo de nuevo.';
      }
      
      return RegisterResponse.error(errorMessage);
    }
  }
}