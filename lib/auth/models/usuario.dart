/// Modelo para representar un Usuario basado en tu API backend
class Usuario {
  final int id;
  final String nomUsuario;
  final String emailUsuario;
  final String rolUsuario;
  final String? telUsuario;
  final String? password; // Solo para operaciones de login/registro
  final String estUsuario;

  Usuario({
    required this.id,
    required this.nomUsuario,
    required this.emailUsuario,
    required this.rolUsuario,
    this.telUsuario,
    this.password,
    required this.estUsuario,
  });

  // Factory para crear desde JSON de tu API
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nomUsuario: json['nomUsuario'],
      emailUsuario: json['emailUsuario'],
      rolUsuario: json['rolUsuario'],
      telUsuario: json['telUsuario'],
      estUsuario: json['estUsuario'],
    );
  }

  // Convertir a JSON (para envío a la API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomUsuario': nomUsuario,
      'emailUsuario': emailUsuario,
      'rolUsuario': rolUsuario,
      'telUsuario': telUsuario,
      'password': password, // Solo incluir si existe
      'estUsuario': estUsuario,
    };
  }

  // Getters de conveniencia para la UI

  /// Obtiene las iniciales del nombre del usuario
  String get initials {
    if (nomUsuario.isEmpty) return 'U';
    
    List<String> nameParts = nomUsuario.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      return (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
    }
  }

  /// Obtiene el nombre formateado (primera letra mayúscula)
  String get formattedName {
    return nomUsuario.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Obtiene el teléfono formateado
  String get formattedPhone {
    if (telUsuario == null || telUsuario!.isEmpty) {
      return 'No registrado';
    }
    return telUsuario!;
  }

  // Métodos de utilidad para verificar el estado y rol

  /// Verifica si el usuario está activo
  bool get isActive => estUsuario.toUpperCase() == 'ACTIVO';

  /// Verifica si el usuario está inactivo
  bool get isInactive => estUsuario.toUpperCase() == 'INACTIVO';

  /// Verifica si el usuario es administrador
  bool get isAdmin => rolUsuario.toUpperCase() == 'ADMIN';

  /// Verifica si el usuario es cliente
  bool get isCliente => rolUsuario.toUpperCase() == 'CLIENTE';

  /// Verifica si el usuario es mesero
  bool get isMesero => rolUsuario.toUpperCase() == 'MESERO';

  /// Verifica si el usuario es chef
  bool get isChef => rolUsuario.toUpperCase() == 'CHEF';

  /// Obtiene la descripción del rol del usuario
  String get roleDescription {
    switch (rolUsuario.toUpperCase()) {
      case 'ADMIN':
        return 'Administrador';
      case 'MESERO':
        return 'Mesero';
      case 'CHEF':
        return 'Chef';
      case 'CLIENTE':
        return 'Cliente';
      default:
        return rolUsuario;
    }
  }

  /// Obtiene la descripción del estado del usuario
  String get statusDescription {
    switch (estUsuario.toUpperCase()) {
      case 'ACTIVO':
        return 'Activo';
      case 'INACTIVO':
        return 'Inactivo';
      case 'SUSPENDIDO':
        return 'Suspendido';
      case 'BLOQUEADO':
        return 'Bloqueado';
      default:
        return estUsuario;
    }
  }

  /// Obtiene el color asociado al rol
  String get roleColor {
    switch (rolUsuario.toUpperCase()) {
      case 'ADMIN':
        return 'red';
      case 'MESERO':
        return 'blue';
      case 'CHEF':
        return 'orange';
      case 'CLIENTE':
        return 'green';
      default:
        return 'grey';
    }
  }

  /// Obtiene el icono asociado al rol
  String get roleIcon {
    switch (rolUsuario.toUpperCase()) {
      case 'ADMIN':
        return 'admin_panel_settings';
      case 'MESERO':
        return 'restaurant_menu';
      case 'CHEF':
        return 'restaurant';
      case 'CLIENTE':
        return 'person';
      default:
        return 'account_circle';
    }
  }

  /// Verifica si el email es válido
  bool get hasValidEmail {
    return emailUsuario.isNotEmpty && 
           emailUsuario.contains('@') && 
           emailUsuario.contains('.');
  }

  /// Verifica si tiene teléfono registrado
  bool get hasPhone => telUsuario != null && telUsuario!.isNotEmpty;

  /// Crea una copia del usuario con campos actualizados
  Usuario copyWith({
    int? id,
    String? nomUsuario,
    String? emailUsuario,
    String? rolUsuario,
    String? telUsuario,
    String? password,
    String? estUsuario,
  }) {
    return Usuario(
      id: id ?? this.id,
      nomUsuario: nomUsuario ?? this.nomUsuario,
      emailUsuario: emailUsuario ?? this.emailUsuario,
      rolUsuario: rolUsuario ?? this.rolUsuario,
      telUsuario: telUsuario ?? this.telUsuario,
      password: password ?? this.password,
      estUsuario: estUsuario ?? this.estUsuario,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nomUsuario: $nomUsuario, emailUsuario: $emailUsuario, rolUsuario: $rolUsuario, estUsuario: $estUsuario}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          emailUsuario == other.emailUsuario;

  @override
  int get hashCode => id.hashCode ^ emailUsuario.hashCode;
}

/// Modelo para solicitud de login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // Validaciones básicas
  bool get isValidEmail {
    return email.isNotEmpty && 
           email.contains('@') && 
           email.contains('.');
  }

  bool get isValidPassword {
    return password.isNotEmpty && password.length >= 6;
  }

  bool get isValid => isValidEmail && isValidPassword;

  @override
  String toString() {
    return 'LoginRequest{email: $email}'; // No mostrar password en logs
  }
}