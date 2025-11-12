/// Modelo para representar una mesa del restaurante
class Table {
  final int id;
  final int numSillas;
  final bool estMesa;
  final String codMesa;
  final int? restauranteId; // Solo el ID, no la entidad completa

  // Constructor con atributos requeridos
  Table({
    required this.id,
    required this.numSillas,
    required this.estMesa,
    required this.codMesa,
    this.restauranteId,
  });

  // Factory método que convierte un JSON en una instancia de Table
  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      numSillas: json['numSillas'],
      estMesa: json['estMesa'],
      codMesa: json['codMesa'],
      restauranteId: json['restaurante']?['id'], // Extraer ID del objeto restaurante
    );
  }

  // Método para convertir una instancia de Table a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numSillas': numSillas,
      'estMesa': estMesa,
      'codMesa': codMesa,
      if (restauranteId != null) 'restaurante': {'id': restauranteId},
    };
  }

  // Métodos de utilidad para facilitar el uso del modelo

  /// Verifica si la mesa está disponible
  bool get isAvailable {
    return estMesa;
  }

  /// Verifica si la mesa está ocupada
  bool get isOccupied {
    return !estMesa;
  }

  /// Obtiene el estado como texto amigable
  String get statusText {
    return estMesa ? 'Disponible' : 'Ocupada';
  }

  /// Obtiene el color del estado para la UI
  String get statusColor {
    return estMesa ? 'green' : 'red';
  }

  /// Obtiene la capacidad como texto amigable
  String get capacityText {
    return numSillas == 1 ? '1 silla' : '$numSillas sillas';
  }

  /// Verifica si la mesa puede acomodar cierto número de personas
  bool canAccommodate(int people) {
    return numSillas >= people && estMesa;
  }

  /// Obtiene el tipo de mesa basado en la capacidad
  String get tableType {
    if (numSillas <= 2) return 'Mesa pequeña';
    if (numSillas <= 4) return 'Mesa mediana';
    if (numSillas <= 6) return 'Mesa grande';
    return 'Mesa familiar';
  }
}