import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/table.dart';

//! el TableService es el encargado de hacer las peticiones a la API de mesas
class TableService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todas las mesas
  // * se crea una instancia del modelo Table, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de mesas

  Future<List<Table>> getAllTables() async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de Table
      return data.map((tableJson) => Table.fromJson(tableJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de mesas.');
    }
  }

  // Método para obtener las mesas de un restaurante específico
  Future<List<Table>> getTablesByRestaurant(int restauranteId) async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas/restaurante/$restauranteId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((tableJson) => Table.fromJson(tableJson)).toList(); // se retorna la lista de mesas del restaurante
    } else {
      throw Exception('Error al obtener las mesas del restaurante');
    }
  }

  // Método para obtener el detalle de una mesa por ID
  Future<Table> getTableById(int tableId) async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas/$tableId'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Table.fromJson(data); // se retorna el detalle de la mesa
    } else {
      throw Exception('Error al obtener el detalle de la mesa');
    }
  }

  // Método para obtener mesas disponibles por restaurante
  Future<List<Table>> getAvailableTablesByRestaurant(int restauranteId) async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas/disponibles/restaurante/$restauranteId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((tableJson) => Table.fromJson(tableJson)).toList();
    } else {
      throw Exception('Error al obtener mesas disponibles del restaurante');
    }
  }

  // Método para obtener mesas con capacidad mínima
  Future<List<Table>> getTablesWithCapacity(int numSillas) async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas/disponibles/capacidad/$numSillas'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((tableJson) => Table.fromJson(tableJson)).toList();
    } else {
      throw Exception('Error al obtener mesas con capacidad: $numSillas');
    }
  }

  // Método para obtener mesa por código
  Future<Table> getTableByCode(String codMesa) async {
    final response = await http.get(Uri.parse('$apiUrl/mesa-service/mesas/codigo/$codMesa'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Table.fromJson(data);
    } else {
      throw Exception('Error al obtener mesa por código');
    }
  }

  // Método para crear una nueva mesa
  Future<Table> createTable(Table table) async {
    final response = await http.post(
      Uri.parse('$apiUrl/mesa-service/mesa'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(table.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Table.fromJson(data);
    } else {
      throw Exception('Error al crear la mesa');
    }
  }

  // Método para actualizar una mesa existente
  Future<Table> updateTable(Table table) async {
    final response = await http.put(
      Uri.parse('$apiUrl/mesa-service/mesa'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(table.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Table.fromJson(data);
    } else {
      throw Exception('Error al actualizar la mesa');
    }
  }

  // Método para eliminar una mesa
  Future<void> deleteTable(int tableId) async {
    final response = await http.delete(Uri.parse('$apiUrl/mesa-service/mesas/$tableId'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la mesa');
    }
  }

  // Método de utilidad para obtener mesas con filtros comunes
  Future<List<Table>> getTablesWithFilters({
    int? restauranteId,
    bool? disponible,
    int? minCapacidad,
    String? codMesa,
  }) async {
    try {
      // Si se especifica un restauranteId, obtener mesas de ese restaurante
      if (restauranteId != null) {
        if (disponible == true) {
          return await getAvailableTablesByRestaurant(restauranteId);
        } else {
          return await getTablesByRestaurant(restauranteId);
        }
      }
      
      // Si se especifica un código, obtener mesa por código
      if (codMesa != null) {
        final table = await getTableByCode(codMesa);
        return [table];
      }
      
      // Si se especifica capacidad mínima, obtener por capacidad
      if (minCapacidad != null) {
        return await getTablesWithCapacity(minCapacidad);
      }
      
      // Si no hay filtros específicos, obtener todas las mesas
      return await getAllTables();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getTablesWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar la capacidad de la mesa
  bool isValidTableCapacity(int numSillas) {
    return numSillas > 0 && numSillas <= 20; // Capacidad válida entre 1 y 20 sillas
  }

  // Método de utilidad para validar el código de mesa
  bool isValidTableCode(String codMesa) {
    return codMesa.isNotEmpty && codMesa.length >= 2 && codMesa.length <= 20;
  }
}