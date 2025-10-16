/// Modelo para representar un Usuario (Profile) con sus datos principales
class Profile {
  int id;
  String nomUsuario;
  String emailUsuario;
  String rolUsuario;
  String? telUsuario;
  String? password; // Solo para operaciones de actualización, no se expone normalmente
  String estUsuario;

  // Constructor de la clase Profile con los atributos requeridos
  // esto se hace para que al crear una instancia de Profile, estos atributos sean obligatorios
  // se usa en el fromJson que es un método que convierte un JSON en una instancia de Profile
  Profile({
    required this.id,
    required this.nomUsuario,
    required this.emailUsuario,
    required this.rolUsuario,
    this.telUsuario,
    this.password,
    required this.estUsuario,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este método se usa para convertir un JSON en una instancia de Profile
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      nomUsuario: json['nomUsuario'],
      emailUsuario: json['emailUsuario'],
      rolUsuario: json['rolUsuario'],
      telUsuario: json['telUsuario'],
      // No incluimos password en fromJson por seguridad
      estUsuario: json['estUsuario'],
    );
  }

  // Método para convertir una instancia de Profile a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'nomUsuario': nomUsuario,
      'emailUsuario': emailUsuario,
      'rolUsuario': rolUsuario,
      'telUsuario': telUsuario,
      'estUsuario': estUsuario,
    };
    
    // Solo incluir password si existe (para operaciones de actualización)
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    
    return data;
  }

  // Getters de conveniencia para obtener información formateada

  /// Obtiene la descripción del rol del usuario
  String get roleDescription {
    switch (rolUsuario.toUpperCase()) {
      case 'ADMIN':
        return 'Administrador';
      case 'MANAGER':
        return 'Gerente';
      case 'WAITER':
        return 'Mesero';
      case 'CHEF':
        return 'Chef';
      case 'CUSTOMER':
        return 'Cliente';
      case 'USER':
        return 'Usuario';
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

  /// Verifica si el usuario está suspendido
  bool get isSuspended => estUsuario.toUpperCase() == 'SUSPENDIDO';

  /// Verifica si el usuario está bloqueado
  bool get isBlocked => estUsuario.toUpperCase() == 'BLOQUEADO';

  /// Verifica si el usuario es administrador
  bool get isAdmin => rolUsuario.toUpperCase() == 'ADMIN';

  /// Verifica si el usuario es gerente
  bool get isManager => rolUsuario.toUpperCase() == 'MANAGER';

  /// Verifica si el usuario es mesero
  bool get isWaiter => rolUsuario.toUpperCase() == 'WAITER';

  /// Verifica si el usuario es chef
  bool get isChef => rolUsuario.toUpperCase() == 'CHEF';

  /// Verifica si el usuario es cliente
  bool get isCustomer => rolUsuario.toUpperCase() == 'CUSTOMER' || rolUsuario.toUpperCase() == 'USER';

  /// Verifica si tiene permisos administrativos
  bool get hasAdminPermissions => isAdmin || isManager;

  /// Verifica si puede gestionar pedidos
  bool get canManageOrders => isAdmin || isManager || isWaiter || isChef;

  /// Verifica si puede ver reportes
  bool get canViewReports => isAdmin || isManager;

  /// Verifica si el email es válido
  bool get hasValidEmail {
    return emailUsuario.isNotEmpty && 
           emailUsuario.contains('@') && 
           emailUsuario.contains('.');
  }

  /// Verifica si tiene teléfono registrado
  bool get hasPhone => telUsuario != null && telUsuario!.isNotEmpty;

  /// Obtiene el color asociado al rol
  String get roleColor {
    switch (rolUsuario.toUpperCase()) {
      case 'ADMIN':
        return 'red';
      case 'MANAGER':
        return 'purple';
      case 'WAITER':
        return 'blue';
      case 'CHEF':
        return 'orange';
      case 'CUSTOMER':
      case 'USER':
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
      case 'MANAGER':
        return 'manage_accounts';
      case 'WAITER':
        return 'restaurant_menu';
      case 'CHEF':
        return 'restaurant';
      case 'CUSTOMER':
      case 'USER':
        return 'person';
      default:
        return 'account_circle';
    }
  }

  /// Obtiene el color asociado al estado
  String get statusColor {
    switch (estUsuario.toUpperCase()) {
      case 'ACTIVO':
        return 'green';
      case 'INACTIVO':
        return 'grey';
      case 'SUSPENDIDO':
        return 'orange';
      case 'BLOQUEADO':
        return 'red';
      default:
        return 'grey';
    }
  }

  /// Crea una copia del perfil con campos actualizados
  Profile copyWith({
    int? id,
    String? nomUsuario,
    String? emailUsuario,
    String? rolUsuario,
    String? telUsuario,
    String? password,
    String? estUsuario,
  }) {
    return Profile(
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
    return 'Profile{id: $id, nomUsuario: $nomUsuario, emailUsuario: $emailUsuario, rolUsuario: $rolUsuario, estUsuario: $estUsuario}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          emailUsuario == other.emailUsuario;

  @override
  int get hashCode => id.hashCode ^ emailUsuario.hashCode;
}
