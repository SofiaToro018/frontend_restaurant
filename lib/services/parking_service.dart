import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/parking.dart';

//! El ParkingService es el encargado de hacer las peticiones a la API de parqueadero
class ParkingService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los parqueaderos
  Future<List<Parking>> getAllParkingSpaces() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/parqueadero-service/parqueaderos')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<Parking> parkingSpaces = data.map((parkingJson) {
          return Parking.fromJson(parkingJson);
        }).toList();
        
        if (kDebugMode) {
          print('Parqueaderos obtenidos: ${parkingSpaces.length}');
        }
        
        return parkingSpaces;
      } else {
        throw Exception('Error al obtener los parqueaderos: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getAllParkingSpaces: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener un parqueadero por ID
  Future<Parking> getParkingById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/parqueadero-service/parqueaderos/$id')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Parking.fromJson(data);
      } else {
        throw Exception('Error al obtener el parqueadero: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getParkingById: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener parqueaderos por restaurante
  Future<List<Parking>> getParkingByRestaurant(int restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/parqueadero-service/parqueaderos/restaurante/$restaurantId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<Parking> parkingSpaces = data.map((parkingJson) {
          return Parking.fromJson(parkingJson);
        }).toList();
        
        if (kDebugMode) {
          print('Parqueaderos del restaurante $restaurantId: ${parkingSpaces.length}');
        }
        
        return parkingSpaces;
      } else {
        throw Exception('Error al obtener parqueaderos del restaurante: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getParkingByRestaurant: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para crear un nuevo parqueadero
  Future<Parking> createParkingSpace(Parking parking) async {
    try {
      if (kDebugMode) {
        print('Creando parqueadero: ${parking.toJson()}');
      }

      final response = await http.post(
        Uri.parse('$apiUrl/parqueadero-service/parqueadero'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(parking.toJson()),
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Parking.fromJson(data);
      } else {
        throw Exception('Error al crear el parqueadero: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en createParkingSpace: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para actualizar un parqueadero existente
  Future<Parking> updateParkingSpace(Parking parking) async {
    try {
      if (kDebugMode) {
        print('Actualizando parqueadero: ${parking.toJson()}');
      }

      final response = await http.put(
        Uri.parse('$apiUrl/parqueadero-service/parqueadero'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(parking.toJson()),
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Parking.fromJson(data);
      } else {
        throw Exception('Error al actualizar el parqueadero: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en updateParkingSpace: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para eliminar un parqueadero
  Future<void> deleteParkingSpace(int id) async {
    try {
      if (kDebugMode) {
        print('Eliminando parqueadero con ID: $id');
      }

      final response = await http.delete(
        Uri.parse('$apiUrl/parqueadero-service/parqueaderos/$id'),
      );
      
      if (kDebugMode) {
        print('Delete response status: ${response.statusCode}');
      }

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el parqueadero: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en deleteParkingSpace: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}