import 'usuario.dart';

// Modelo para el request de registro
class RegisterRequest {
  final String nomUsuario;
  final String emailUsuario;
  final String rolUsuario;
  final String telUsuario;
  final String password;
  final String estUsuario;

  RegisterRequest({
    required this.nomUsuario,
    required this.emailUsuario,
    required this.rolUsuario,
    required this.telUsuario,
    required this.password,
    this.estUsuario = 'ACTIVO', // Por defecto ACTIVO
  });

  Map<String, dynamic> toJson() {
    return {
      'nomUsuario': nomUsuario,
      'emailUsuario': emailUsuario,
      'rolUsuario': rolUsuario,
      'telUsuario': telUsuario,
      'password': password,
      'estUsuario': estUsuario,
    };
  }
}

// Modelo para el response de registro
class RegisterResponse {
  final bool isSuccess;
  final String? message;
  final String? errorMessage;
  final Usuario? usuario;

  RegisterResponse({
    required this.isSuccess,
    this.message,
    this.errorMessage,
    this.usuario,
  });

  factory RegisterResponse.success({String? message, Usuario? usuario}) {
    return RegisterResponse(
      isSuccess: true,
      message: message ?? '¡Registro exitoso! Redirigiendo al login...',
      usuario: usuario,
    );
  }

  factory RegisterResponse.error(String errorMessage) {
    return RegisterResponse(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }

  bool get hasError => !isSuccess && errorMessage != null;
}

// Enum para los roles de usuario
enum UserRole {
  cliente('CLIENTE'),
  administrador('ADMINISTRADOR');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CLIENTE':
        return UserRole.cliente;
      case 'ADMINISTRADOR':
        return UserRole.administrador;
      default:
        return UserRole.cliente;
    }
  }
}