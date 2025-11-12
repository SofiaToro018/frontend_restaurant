import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/order.dart';

//! el OrderService es el encargado de hacer las peticiones a la API de pedidos
class OrderService {
  // ! Se obtiene la url de la API desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los pedidos
  // * se crea una instancia del modelo Order, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de pedidos

  Future<List<Order>> getAllOrders() async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // se mapea la lista de resultados para obtener las instancias de Order
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de pedidos.');
    }
  }

  // Método para obtener los pedidos de un usuario específico
  Future<List<Order>> getOrdersByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/usuario/$userId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList(); // se retorna la lista de pedidos del usuario
    } else {
      throw Exception('Error al obtener los pedidos del usuario');
    }
  }

  // Método para obtener el detalle de un pedido por ID
  Future<Order> getOrderById(int orderId) async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/$orderId'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Order.fromJson(data); // se retorna el detalle del pedido
    } else {
      throw Exception('Error al obtener el detalle del pedido');
    }
  }

  // Método para obtener pedidos por estado
  Future<List<Order>> getOrdersByStatus(String status) async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/estado/$status'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Error al obtener pedidos por estado: $status');
    }
  }

  // Método para obtener pedidos por reserva
  Future<List<Order>> getOrdersByReservation(int reservationId) async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/reserva/$reservationId'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Error al obtener pedidos por reserva');
    }
  }

  // Método para obtener pedidos pendientes
  Future<List<Order>> getPendingOrders() async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/pendientes'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Error al obtener pedidos pendientes');
    }
  }

  // Método para obtener pedidos por rango de precio
  Future<List<Order>> getOrdersByPriceRange(double minPrice, double maxPrice) async {
    final response = await http.get(
      Uri.parse('$apiUrl/pedido-service/pedidos/precio?min=$minPrice&max=$maxPrice')
    );
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Error al obtener pedidos por rango de precio');
    }
  }

  // Método para obtener el total de ventas de un usuario
  Future<double> getTotalSalesByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/pedido-service/pedidos/ventas/usuario/$userId'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as num).toDouble(); // se retorna el total de ventas como double
    } else {
      throw Exception('Error al obtener total de ventas del usuario');
    }
  }

  // Método para crear un nuevo pedido
  Future<Order> createOrder(Order order) async {
    final response = await http.post(
      Uri.parse('$apiUrl/pedido-service/pedido'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(order.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Order.fromJson(data);
    } else {
      throw Exception('Error al crear el pedido');
    }
  }

  // Método para actualizar un pedido existente
  Future<Order> updateOrder(Order order) async {
    final response = await http.put(
      Uri.parse('$apiUrl/pedido-service/pedido'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(order.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Order.fromJson(data);
    } else {
      throw Exception('Error al actualizar el pedido');
    }
  }

  // Método para eliminar un pedido
  Future<void> deleteOrder(int orderId) async {
    final response = await http.delete(Uri.parse('$apiUrl/pedido-service/pedidos/$orderId'));
    
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el pedido');
    }
  }

  // Método de utilidad para obtener pedidos con filtros comunes
  Future<List<Order>> getOrdersWithFilters({
    int? userId,
    String? status,
    int? reservationId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      // Si se especifica un userId, obtener pedidos de ese usuario
      if (userId != null) {
        return await getOrdersByUser(userId);
      }
      
      // Si se especifica un estado, obtener pedidos por estado
      if (status != null) {
        return await getOrdersByStatus(status);
      }
      
      // Si se especifica una reserva, obtener pedidos por reserva
      if (reservationId != null) {
        return await getOrdersByReservation(reservationId);
      }
      
      // Si se especifica rango de precio, obtener por precio
      if (minPrice != null && maxPrice != null) {
        return await getOrdersByPriceRange(minPrice, maxPrice);
      }
      
      // Si no hay filtros específicos, obtener todos los pedidos
      return await getAllOrders();
    } catch (e) {
      if (kDebugMode) {
        print('Error en getOrdersWithFilters: $e');
      }
      rethrow;
    }
  }

  // Método de utilidad para validar el estado del pedido
  bool isValidOrderStatus(String status) {
    const validStatuses = [
      'PENDIENTE',
      'EN_PREPARACION',
      'COMPLETADO',
      'CANCELADO'
    ];
    return validStatuses.contains(status.toUpperCase());
  }
}