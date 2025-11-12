/// Modelo para representar un evento del restaurante
class Event {
  final int id;
  final int restaurantId;
  final String tipEvento;

  // Constructor con atributos requeridos
  Event({
    required this.id,
    required this.restaurantId,
    required this.tipEvento,
  });

  // Factory método que convierte un JSON en una instancia de Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      restaurantId: json['restaurantId'],
      tipEvento: json['tipEvento'],
    );
  }

  // Método para convertir una instancia de Event a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'tipEvento': tipEvento,
    };
  }

  // Métodos de utilidad para facilitar el uso del modelo

  /// Obtiene el tipo de evento como texto capitalizado
  String get eventTypeCapitalized {
    return tipEvento.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Obtiene la categoría del evento basado en el tipo
  String get eventCategory {
    final tipo = tipEvento.toLowerCase();
    if (tipo.contains('cumpleanos') || tipo.contains('birthday')) return 'Celebración';
    if (tipo.contains('bodas') || tipo.contains('wedding')) return 'Matrimonio';
    if (tipo.contains('corporativo') || tipo.contains('corporate')) return 'Corporativo';
    if (tipo.contains('conferencia') || tipo.contains('conference')) return 'Conferencia';
    if (tipo.contains('reunion') || tipo.contains('meeting')) return 'Reunión';
    if (tipo.contains('fiesta') || tipo.contains('party')) return 'Fiesta';
    return 'Evento General';
  }

  /// Verifica si es un evento corporativo
  bool get isCorporateEvent {
    return tipEvento.toLowerCase().contains('corporativo') || 
           tipEvento.toLowerCase().contains('corporate');
  }

  /// Verifica si es un evento de celebración
  bool get isCelebrationEvent {
    final tipo = tipEvento.toLowerCase();
    return tipo.contains('cumpleanos') || 
           tipo.contains('birthday') || 
           tipo.contains('fiesta') ||
           tipo.contains('party');
  }

  /// Obtiene el icono sugerido basado en el tipo de evento
  String get suggestedIcon {
    final tipo = tipEvento.toLowerCase();
    if (tipo.contains('cumpleanos') || tipo.contains('birthday')) return 'cake';
    if (tipo.contains('bodas') || tipo.contains('wedding')) return 'favorite';
    if (tipo.contains('corporativo') || tipo.contains('corporate')) return 'business';
    if (tipo.contains('conferencia') || tipo.contains('conference')) return 'mic';
    if (tipo.contains('reunion') || tipo.contains('meeting')) return 'groups';
    if (tipo.contains('fiesta') || tipo.contains('party')) return 'celebration';
    return 'event';
  }

  /// Obtiene una descripción amigable del evento
  String get friendlyDescription {
    return 'Evento de $eventCategory - $eventTypeCapitalized';
  }
}