import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/event.dart';

//! el EventService es el encargado de hacer las peticiones a la API de eventos
class EventService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los eventos
  // * se crea una instancia del modelo Event, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de eventos

  Future<List<Event>> getAllEvents() async {
    final response = await http.get(Uri.parse('$apiUrl/analista-eventos-service/analistas'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de Event
      return data.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de eventos.');
    }
  }

  // Método para obtener los eventos de un restaurante específico
  Future<List<Event>> getEventsByRestaurant(int restaurantId) async {
    final response = await http.get(Uri.parse('$apiUrl/analista-eventos-service/analistas/restaurante/$restaurantId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((eventJson) => Event.fromJson(eventJson)).toList(); // se retorna la lista de eventos del restaurante
    } else {
      throw Exception('Error al obtener los eventos del restaurante');
    }
  }

  // Método para obtener el detalle de un evento por ID
  Future<Event> getEventById(int eventId) async {
    final response = await http.get(Uri.parse('$apiUrl/analista-eventos-service/analistas/$eventId'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Event.fromJson(data); // se retorna el detalle del evento
    } else {
      throw Exception('Error al obtener el detalle del evento');
    }
  }

  // Método para obtener eventos por tipo
  Future<List<Event>> getEventsByType(String tipoEvento) async {
    final allEvents = await getAllEvents();
    return allEvents.where((event) => 
      event.tipEvento.toLowerCase().contains(tipoEvento.toLowerCase())
    ).toList();
  }

  // Método para obtener eventos corporativos
  Future<List<Event>> getCorporateEvents() async {
    final allEvents = await getAllEvents();
    return allEvents.where((event) => event.isCorporateEvent).toList();
  }

  // Método para obtener eventos de celebración
  Future<List<Event>> getCelebrationEvents() async {
    final allEvents = await getAllEvents();
    return allEvents.where((event) => event.isCelebrationEvent).toList();
  }

  // Método para crear un nuevo evento
  Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse('$apiUrl/analista-eventos-service/analista'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(event.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Event.fromJson(data);
    } else {
      throw Exception('Error al crear el evento');
    }
  }

  // Método para actualizar un evento existente
  Future<Event> updateEvent(Event event) async {
    final response = await http.put(
      Uri.parse('$apiUrl/analista-eventos-service/analista'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(event.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Event.fromJson(data);
    } else {
      throw Exception('Error al actualizar el evento');
    }
  }

  // Método para eliminar un evento
  Future<void> deleteEvent(int eventId) async {
    final response = await http.delete(Uri.parse('$apiUrl/analista-eventos-service/analistas/$eventId'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento');
    }
  }

  // Método de utilidad para obtener eventos con filtros comunes
  Future<List<Event>> getEventsWithFilters({
    int? restaurantId,
    String? tipoEvento,
    bool? corporativo,
    bool? celebracion,
  }) async {
    try {
      // Si se especifica un restaurantId, obtener eventos de ese restaurante
      if (restaurantId != null) {
        return await getEventsByRestaurant(restaurantId);
      }
      
      // Si se especifica un tipo, obtener eventos por tipo
      if (tipoEvento != null) {
        return await getEventsByType(tipoEvento);
      }
      
      // Si se especifica filtro corporativo
      if (corporativo == true) {
        return await getCorporateEvents();
      }
      
      // Si se especifica filtro celebración
      if (celebracion == true) {
        return await getCelebrationEvents();
      }
      
      // Si no hay filtros específicos, obtener todos los eventos
      return await getAllEvents();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getEventsWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar el tipo de evento
  bool isValidEventType(String tipoEvento) {
    return tipoEvento.isNotEmpty && tipoEvento.length >= 3 && tipoEvento.length <= 100;
  }

  // Método de utilidad para validar el ID del restaurante
  bool isValidRestaurantId(int restaurantId) {
    return restaurantId > 0;
  }

  // Método de utilidad para obtener tipos de eventos sugeridos
  List<String> getSuggestedEventTypes() {
    return [
      'CUMPLEANOS',
      'BODAS',
      'EVENTO_CORPORATIVO',
      'CONFERENCIA',
      'REUNION_NEGOCIOS',
      'FIESTA_PRIVADA',
      'CELEBRACION_FAMILIAR',
      'LANZAMIENTO_PRODUCTO',
      'NETWORKING',
      'CAPACITACION',
    ];
  }
}