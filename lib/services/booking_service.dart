import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/booking.dart';

//! el BookingService es el encargado de hacer las peticiones a la API de reservas
class BookingService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todas las reservas
  // * se crea una instancia del modelo Booking, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de reservas

  Future<List<Booking>> getAllBookings() async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de Booking
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de reservas.');
    }
  }

  // Método para obtener el detalle de una reserva por ID
  Future<Booking> getBookingById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas/$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Booking.fromJson(data); // se retorna el detalle de la reserva
    } else {
      throw Exception('Error al obtener el detalle de la reserva');
    }
  }

  // Método para obtener las reservas de un usuario específico
  Future<List<Booking>> getBookingsByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas/usuario/$userId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList(); // se retorna la lista de reservas del usuario
    } else {
      throw Exception('Error al obtener las reservas del usuario');
    }
  }

  // Método para obtener las reservas de una mesa específica
  Future<List<Booking>> getBookingsByTable(int mesaId) async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas/mesa/$mesaId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener las reservas de la mesa');
    }
  }

  // Método para obtener reservas por estado
  Future<List<Booking>> getBookingsByStatus(String estado) async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas/estado/$estado'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener reservas por estado: $estado');
    }
  }

  // Método para obtener reservas activas de una mesa específica
  Future<List<Booking>> getActiveBookingsByTable(int mesaId) async {
    final response = await http.get(Uri.parse('$apiUrl/reserva-service/reservas/mesa/$mesaId/activas'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener reservas activas de la mesa');
    }
  }

  // Método para obtener reservas por rango de fechas
  Future<List<Booking>> getBookingsByDateRange(DateTime inicio, DateTime fin) async {
    final String inicioStr = inicio.toIso8601String();
    final String finStr = fin.toIso8601String();
    
    final response = await http.get(
      Uri.parse('$apiUrl/reserva-service/reservas/rango?inicio=$inicioStr&fin=$finStr')
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener reservas por rango de fechas');
    }
  }

  // Método para obtener reservas de un usuario en una fecha específica
  Future<List<Booking>> getBookingsByUserAndDate(int usuarioId, DateTime fecha) async {
    final String fechaStr = fecha.toIso8601String();
    
    final response = await http.get(
      Uri.parse('$apiUrl/reserva-service/reservas/usuario/$usuarioId/fecha?fecha=$fechaStr')
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((bookingJson) => Booking.fromJson(bookingJson)).toList();
    } else {
      throw Exception('Error al obtener reservas del usuario por fecha');
    }
  }

  // Método para crear una nueva reserva
  Future<Booking> createBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse('$apiUrl/reserva-service/reserva'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(booking.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Booking.fromJson(data);
    } else {
      throw Exception('Error al crear la reserva');
    }
  }

  // Método para actualizar una reserva existente
  Future<Booking> updateBooking(Booking booking) async {
    final response = await http.put(
      Uri.parse('$apiUrl/reserva-service/reserva'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(booking.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Booking.fromJson(data);
    } else {
      throw Exception('Error al actualizar la reserva');
    }
  }

  // Método para eliminar una reserva
  Future<void> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/reserva-service/reservas/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la reserva');
    }
  }

  // Método de utilidad para obtener reservas con filtros comunes
  Future<List<Booking>> getBookingsWithFilters({
    int? userId,
    int? mesaId,
    String? estado,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? onlyActive = false,
  }) async {
    try {
      // Si se especifica un userId, obtener reservas de ese usuario
      if (userId != null) {
        return await getBookingsByUser(userId);
      }
      
      // Si se especifica una mesa y solo activas, obtener reservas activas de esa mesa
      if (mesaId != null && onlyActive == true) {
        return await getActiveBookingsByTable(mesaId);
      }
      
      // Si se especifica una mesa, obtener todas las reservas de esa mesa
      if (mesaId != null) {
        return await getBookingsByTable(mesaId);
      }
      
      // Si se especifica un estado, obtener reservas por estado
      if (estado != null) {
        return await getBookingsByStatus(estado);
      }
      
      // Si se especifica rango de fechas, obtener por fechas
      if (fechaInicio != null && fechaFin != null) {
        return await getBookingsByDateRange(fechaInicio, fechaFin);
      }
      
      // Si no hay filtros específicos, obtener todas las reservas
      return await getAllBookings();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getBookingsWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar el estado de la reserva
  bool isValidBookingStatus(String estado) {
    const validStatuses = [
      'ACTIVA',
      'COMPLETADA',
      'CANCELADA',
      'PENDIENTE'
    ];
    return validStatuses.contains(estado.toUpperCase());
  }

  // Método de utilidad para obtener reservas de hoy
  Future<List<Booking>> getTodayBookings() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    return await getBookingsByDateRange(startOfDay, endOfDay);
  }

  // Método de utilidad para obtener reservas futuras
  Future<List<Booking>> getFutureBookings() async {
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 365)); // Un año en el futuro
    
    return await getBookingsByDateRange(now, futureDate);
  }
}
