import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/audit_log.dart';

//! el AuditLogService es el encargado de hacer las peticiones a la API de registro de cambios
class AuditLogService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los registros de cambios
  // * se crea una instancia del modelo AuditLog, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de registros

  Future<List<AuditLog>> getAllAuditLogs() async {
    final response = await http.get(Uri.parse('$apiUrl/registro-cambios-service/registros'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de AuditLog
      return data.map((auditLogJson) => AuditLog.fromJson(auditLogJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de registros de cambios.');
    }
  }

  // Método para obtener el detalle de un registro de cambios por ID
  Future<AuditLog> getAuditLogById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/registro-cambios-service/registros/$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AuditLog.fromJson(data); // se retorna el detalle del registro de cambios
    } else {
      throw Exception('Error al obtener el detalle del registro de cambios');
    }
  }

  // Método para obtener los registros de cambios de un usuario específico
  Future<List<AuditLog>> getAuditLogsByUser(int usuarioId) async {
    final response = await http.get(Uri.parse('$apiUrl/registro-cambios-service/registros/usuario/$usuarioId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((auditLogJson) => AuditLog.fromJson(auditLogJson)).toList(); // se retorna la lista de registros del usuario
    } else {
      throw Exception('Error al obtener los registros de cambios del usuario');
    }
  }

  // Método para obtener registros de cambios por tipo
  Future<List<AuditLog>> getAuditLogsByType(String tipo) async {
    final response = await http.get(Uri.parse('$apiUrl/registro-cambios-service/registros/tipo/$tipo'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((auditLogJson) => AuditLog.fromJson(auditLogJson)).toList();
    } else {
      throw Exception('Error al obtener registros de cambios por tipo: $tipo');
    }
  }

  // Método para obtener registros de cambios por rango de fechas
  Future<List<AuditLog>> getAuditLogsByDateRange(DateTime inicio, DateTime fin) async {
    final String inicioStr = inicio.toIso8601String();
    final String finStr = fin.toIso8601String();
    
    final response = await http.get(
      Uri.parse('$apiUrl/registro-cambios-service/registros/rango?inicio=$inicioStr&fin=$finStr')
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((auditLogJson) => AuditLog.fromJson(auditLogJson)).toList();
    } else {
      throw Exception('Error al obtener registros de cambios por rango de fechas');
    }
  }

  // Método para crear un nuevo registro de cambios
  Future<AuditLog> createAuditLog(AuditLog auditLog) async {
    final response = await http.post(
      Uri.parse('$apiUrl/registro-cambios-service/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(auditLog.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return AuditLog.fromJson(data);
    } else {
      throw Exception('Error al crear el registro de cambios');
    }
  }

  // Método para actualizar un registro de cambios existente
  Future<AuditLog> updateAuditLog(AuditLog auditLog) async {
    final response = await http.put(
      Uri.parse('$apiUrl/registro-cambios-service/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(auditLog.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AuditLog.fromJson(data);
    } else {
      throw Exception('Error al actualizar el registro de cambios');
    }
  }

  // Método para eliminar un registro de cambios
  Future<void> deleteAuditLog(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/registro-cambios-service/registros/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el registro de cambios');
    }
  }

  // Método de utilidad para obtener registros de cambios con filtros comunes
  Future<List<AuditLog>> getAuditLogsWithFilters({
    int? userId,
    String? tipo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      // Si se especifica un userId, obtener registros de ese usuario
      if (userId != null) {
        return await getAuditLogsByUser(userId);
      }
      
      // Si se especifica un tipo, obtener registros por tipo
      if (tipo != null) {
        return await getAuditLogsByType(tipo);
      }
      
      // Si se especifica rango de fechas, obtener por fechas
      if (fechaInicio != null && fechaFin != null) {
        return await getAuditLogsByDateRange(fechaInicio, fechaFin);
      }
      
      // Si no hay filtros específicos, obtener todos los registros
      return await getAllAuditLogs();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getAuditLogsWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar el tipo de cambio
  bool isValidChangeType(String tipo) {
    const validTypes = [
      'ACTUALIZACION_PRECIO',
      'NUEVA_CATEGORIA',
      'CAMBIO_ESTADO_MESA',
      'CREACION_ITEM',
      'ELIMINACION_ITEM',
      'MODIFICACION_RESERVA',
      'CAMBIO_CONFIGURACION'
    ];
    return validTypes.contains(tipo.toUpperCase());
  }

  // Método de utilidad para obtener registros de cambios de hoy
  Future<List<AuditLog>> getTodayAuditLogs() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    return await getAuditLogsByDateRange(startOfDay, endOfDay);
  }

  // Método de utilidad para obtener registros de cambios de esta semana
  Future<List<AuditLog>> getThisWeekAuditLogs() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return await getAuditLogsByDateRange(startOfWeek, endOfWeek);
  }

  // Método de utilidad para obtener registros de cambios recientes (últimas 24 horas)
  Future<List<AuditLog>> getRecentAuditLogs() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    
    return await getAuditLogsByDateRange(yesterday, now);
  }

  // Método de utilidad para obtener registros de cambios por tipo específico
  Future<List<AuditLog>> getPriceUpdateLogs() async {
    return await getAuditLogsByType('ACTUALIZACION_PRECIO');
  }

  Future<List<AuditLog>> getNewCategoryLogs() async {
    return await getAuditLogsByType('NUEVA_CATEGORIA');
  }

  Future<List<AuditLog>> getTableStateChangeLogs() async {
    return await getAuditLogsByType('CAMBIO_ESTADO_MESA');
  }

  Future<List<AuditLog>> getItemCreationLogs() async {
    return await getAuditLogsByType('CREACION_ITEM');
  }

  Future<List<AuditLog>> getItemDeletionLogs() async {
    return await getAuditLogsByType('ELIMINACION_ITEM');
  }

  Future<List<AuditLog>> getReservationModificationLogs() async {
    return await getAuditLogsByType('MODIFICACION_RESERVA');
  }

  Future<List<AuditLog>> getConfigurationChangeLogs() async {
    return await getAuditLogsByType('CAMBIO_CONFIGURACION');
  }
}
