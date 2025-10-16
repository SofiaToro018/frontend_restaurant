/// Modelo para representar una Reserva con sus datos principales
class Booking {
  int id;
  int mesaId;
  int usuarioId;
  String estReserva;
  DateTime fechReserva;

  // Constructor de la clase Booking con los atributos requeridos
  // esto se hace para que al crear una instancia de Booking, estos atributos sean obligatorios
  // se usa en el fromJson que es un método que convierte un JSON en una instancia de Booking
  Booking({
    required this.id,
    required this.mesaId,
    required this.usuarioId,
    required this.estReserva,
    required this.fechReserva,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este método se usa para convertir un JSON en una instancia de Booking
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      mesaId: json['mesaId'],
      usuarioId: json['usuarioId'],
      estReserva: json['estReserva'],
      // Convierte el string de fecha en DateTime
      fechReserva: DateTime.parse(json['fechReserva']),
    );
  }

  // Método para convertir una instancia de Booking a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mesaId': mesaId,
      'usuarioId': usuarioId,
      'estReserva': estReserva,
      'fechReserva': fechReserva.toIso8601String(),
    };
  }

  // Getters de conveniencia para obtener información formateada

  /// Obtiene la descripción del estado de la reserva
  String get statusDescription {
    switch (estReserva.toUpperCase()) {
      case 'ACTIVA':
        return 'Activa';
      case 'COMPLETADA':
        return 'Completada';
      case 'CANCELADA':
        return 'Cancelada';
      case 'PENDIENTE':
        return 'Pendiente';
      default:
        return estReserva;
    }
  }

  /// Obtiene la fecha formateada como string legible
  String get formattedDate {
    return '${fechReserva.day}/${fechReserva.month}/${fechReserva.year}';
  }

  /// Obtiene la hora formateada como string legible
  String get formattedTime {
    String hour = fechReserva.hour.toString().padLeft(2, '0');
    String minute = fechReserva.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Obtiene la fecha y hora formateada completa
  String get formattedDateTime {
    return '$formattedDate a las $formattedTime';
  }

  // Métodos de utilidad para verificar el estado

  /// Verifica si la reserva está activa
  bool get isActive => estReserva.toUpperCase() == 'ACTIVA';

  /// Verifica si la reserva está completada
  bool get isCompleted => estReserva.toUpperCase() == 'COMPLETADA';

  /// Verifica si la reserva está cancelada
  bool get isCancelled => estReserva.toUpperCase() == 'CANCELADA';

  /// Verifica si la reserva está pendiente
  bool get isPending => estReserva.toUpperCase() == 'PENDIENTE';

  /// Verifica si la reserva es para hoy
  bool get isToday {
    final now = DateTime.now();
    return fechReserva.year == now.year &&
           fechReserva.month == now.month &&
           fechReserva.day == now.day;
  }

  /// Verifica si la reserva es para una fecha futura
  bool get isFuture => fechReserva.isAfter(DateTime.now());

  /// Verifica si la reserva es para una fecha pasada
  bool get isPast => fechReserva.isBefore(DateTime.now());
}
