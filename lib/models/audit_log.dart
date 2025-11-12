/// Modelo para representar un Registro de Cambios (Audit Log) con sus datos principales
class AuditLog {
  int id;
  int usuarioId;
  String tipCambio;
  String reglaAfectada;
  DateTime fechCambio;

  // Constructor de la clase AuditLog con los atributos requeridos
  // esto se hace para que al crear una instancia de AuditLog, estos atributos sean obligatorios
  // se usa en el fromJson que es un método que convierte un JSON en una instancia de AuditLog
  AuditLog({
    required this.id,
    required this.usuarioId,
    required this.tipCambio,
    required this.reglaAfectada,
    required this.fechCambio,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este método se usa para convertir un JSON en una instancia de AuditLog
  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      usuarioId: json['usuarioId'],
      tipCambio: json['tipCambio'],
      reglaAfectada: json['reglaAfectada'],
      // Convierte el string de fecha en DateTime
      fechCambio: DateTime.parse(json['fechCambio']),
    );
  }

  // Método para convertir una instancia de AuditLog a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipCambio': tipCambio,
      'reglaAfectada': reglaAfectada,
      'fechCambio': fechCambio.toIso8601String(),
    };
  }

  // Getters de conveniencia para obtener información formateada

  /// Obtiene la descripción del tipo de cambio
  String get changeTypeDescription {
    switch (tipCambio.toUpperCase()) {
      case 'ACTUALIZACION_PRECIO':
        return 'Actualización de Precio';
      case 'NUEVA_CATEGORIA':
        return 'Nueva Categoría';
      case 'CAMBIO_ESTADO_MESA':
        return 'Cambio Estado Mesa';
      case 'CREACION_ITEM':
        return 'Creación de Item';
      case 'ELIMINACION_ITEM':
        return 'Eliminación de Item';
      case 'MODIFICACION_RESERVA':
        return 'Modificación de Reserva';
      case 'CAMBIO_CONFIGURACION':
        return 'Cambio de Configuración';
      default:
        return tipCambio.replaceAll('_', ' ').toLowerCase();
    }
  }

  /// Obtiene la fecha formateada como string legible
  String get formattedDate {
    return '${fechCambio.day}/${fechCambio.month}/${fechCambio.year}';
  }

  /// Obtiene la hora formateada como string legible
  String get formattedTime {
    String hour = fechCambio.hour.toString().padLeft(2, '0');
    String minute = fechCambio.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Obtiene la fecha y hora formateada completa
  String get formattedDateTime {
    return '$formattedDate a las $formattedTime';
  }

  // Métodos de utilidad para verificar el tipo de cambio

  /// Verifica si es una actualización de precio
  bool get isPriceUpdate => tipCambio.toUpperCase() == 'ACTUALIZACION_PRECIO';

  /// Verifica si es una nueva categoría
  bool get isNewCategory => tipCambio.toUpperCase() == 'NUEVA_CATEGORIA';

  /// Verifica si es un cambio de estado de mesa
  bool get isTableStateChange => tipCambio.toUpperCase() == 'CAMBIO_ESTADO_MESA';

  /// Verifica si es creación de item
  bool get isItemCreation => tipCambio.toUpperCase() == 'CREACION_ITEM';

  /// Verifica si es eliminación de item
  bool get isItemDeletion => tipCambio.toUpperCase() == 'ELIMINACION_ITEM';

  /// Verifica si es modificación de reserva
  bool get isReservationModification => tipCambio.toUpperCase() == 'MODIFICACION_RESERVA';

  /// Verifica si es cambio de configuración
  bool get isConfigurationChange => tipCambio.toUpperCase() == 'CAMBIO_CONFIGURACION';

  /// Verifica si el cambio es de hoy
  bool get isToday {
    final now = DateTime.now();
    return fechCambio.year == now.year &&
           fechCambio.month == now.month &&
           fechCambio.day == now.day;
  }

  /// Verifica si el cambio es reciente (últimas 24 horas)
  bool get isRecent => fechCambio.isAfter(DateTime.now().subtract(const Duration(hours: 24)));

  /// Verifica si el cambio es de esta semana
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return fechCambio.isAfter(startOfWeek);
  }

  /// Obtiene el color asociado al tipo de cambio
  String get changeTypeColor {
    switch (tipCambio.toUpperCase()) {
      case 'ACTUALIZACION_PRECIO':
        return 'orange';
      case 'NUEVA_CATEGORIA':
        return 'green';
      case 'CAMBIO_ESTADO_MESA':
        return 'blue';
      case 'CREACION_ITEM':
        return 'purple';
      case 'ELIMINACION_ITEM':
        return 'red';
      case 'MODIFICACION_RESERVA':
        return 'teal';
      case 'CAMBIO_CONFIGURACION':
        return 'indigo';
      default:
        return 'grey';
    }
  }

  /// Obtiene el icono asociado al tipo de cambio
  String get changeTypeIcon {
    switch (tipCambio.toUpperCase()) {
      case 'ACTUALIZACION_PRECIO':
        return 'attach_money';
      case 'NUEVA_CATEGORIA':
        return 'add_circle';
      case 'CAMBIO_ESTADO_MESA':
        return 'table_restaurant';
      case 'CREACION_ITEM':
        return 'restaurant';
      case 'ELIMINACION_ITEM':
        return 'delete';
      case 'MODIFICACION_RESERVA':
        return 'event_note';
      case 'CAMBIO_CONFIGURACION':
        return 'settings';
      default:
        return 'history';
    }
  }
}
