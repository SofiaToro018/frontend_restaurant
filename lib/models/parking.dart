/// Modelo para representar un espacio de parqueadero
class Parking {
  final int id;
  final String codParqueadero;
  final bool estParqueadero;
  final int? restauranteId; // Solo el ID, no la entidad completa

  // Constructor con atributos requeridos
  Parking({
    required this.id,
    required this.codParqueadero,
    required this.estParqueadero,
    this.restauranteId,
  });

  // Factory método que convierte un JSON en una instancia de Parking
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      codParqueadero: json['codParqueadero'],
      estParqueadero: json['estParqueadero'],
      restauranteId: json['restaurante']?['id'], // Extraer ID del objeto restaurante
    );
  }

  // Método para convertir una instancia de Parking a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codParqueadero': codParqueadero,
      'estParqueadero': estParqueadero,
      if (restauranteId != null) 'restaurante': {'id': restauranteId},
    };
  }

  // Métodos de utilidad para facilitar el uso del modelo

  /// Verifica si el parqueadero está disponible
  bool get isAvailable {
    return estParqueadero;
  }

  /// Verifica si el parqueadero está ocupado
  bool get isOccupied {
    return !estParqueadero;
  }

  /// Obtiene el estado como texto amigable
  String get statusText {
    return estParqueadero ? 'Disponible' : 'Ocupado';
  }

  /// Obtiene el color del estado para la UI
  String get statusColor {
    return estParqueadero ? 'green' : 'red';
  }
}