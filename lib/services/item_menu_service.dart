import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/category.dart';

//! El ItemMenuService es el encargado de hacer las peticiones a la API de items del menú
class ItemMenuService {
  // ! Se obtiene la url de la api desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de todos los items
  Future<List<ItemMenu>> getAllItems() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/items-menu-service/items')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<ItemMenu> items = data.map((itemJson) {
          return ItemMenu.fromJson(itemJson);
        }).toList();
        
        return items;
      } else {
        throw Exception('Error al obtener los items: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getAllItems: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener un item específico por su ID
  Future<ItemMenu> getItemById(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/items-menu-service/items/$itemId')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ItemMenu.fromJson(data);
      } else {
        throw Exception('Error al obtener el item: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getItemById: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener items por categoría
  Future<List<ItemMenu>> getItemsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/items-menu-service/items/categoria/$categoryId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<ItemMenu> items = data.map((itemJson) {
          return ItemMenu.fromJson(itemJson);
        }).toList();
        
        return items;
      } else {
        throw Exception('Error al obtener los items de la categoría: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getItemsByCategory: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener items disponibles por categoría
  Future<List<ItemMenu>> getAvailableItemsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/items-menu-service/items/categoria/$categoryId/disponibles')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<ItemMenu> items = data.map((itemJson) {
          return ItemMenu.fromJson(itemJson);
        }).toList();
        
        return items;
      } else {
        throw Exception('Error al obtener los items disponibles: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getAvailableItemsByCategory: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  //! createItem
  /// Crea un nuevo item en la API.
  /// Recibe un objeto ItemMenu, categoryId y una URL de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> createItem(
    ItemMenu item,
    int categoryId, {
    String? imageUrl,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/items-menu-service/item');

      // Preparar el body con los datos del item
      final Map<String, dynamic> body = {
        'nomItem': item.nomItem,
        'precItem': item.precItem,
        'descItem': item.descItem,
        'estItem': item.estItem,
        'categoriaMenu': {
          'id': categoryId,
        },
      };

      // Agregar imagen si existe
      if (imageUrl != null && imageUrl.isNotEmpty) {
        body['imgItemMenu'] = imageUrl;
      }

      if (kDebugMode) {
        print('=== CREATE ITEM REQUEST ===');
        print('URL: $uri');
        print('Body: ${jsonEncode(body)}');
      }

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        // Intentar extraer el mensaje de error de la API
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Error al crear item';

        // Verificar si hay errores de validación específicos
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          List<String> errorMessages = [];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(messages.cast<String>());
            }
          });
          errorMessage = errorMessages.join('\n');
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en createItem: $e');
      }
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! updateItem
  /// Actualiza un item en la API.
  /// Recibe un objeto ItemMenu, categoryId y una URL de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> updateItem(
    ItemMenu item,
    int categoryId, {
    String? imageUrl,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/items-menu-service/item');

      // Preparar el body con los datos del item
      final Map<String, dynamic> body = {
        'id': item.id,
        'nomItem': item.nomItem,
        'precItem': item.precItem,
        'descItem': item.descItem,
        'estItem': item.estItem,
        'categoriaMenu': {
          'id': categoryId,
        },
      };

      // Agregar imagen
      if (imageUrl != null && imageUrl.isNotEmpty) {
        body['imgItemMenu'] = imageUrl;
      } else if (item.imgItemMenu.isNotEmpty) {
        body['imgItemMenu'] = item.imgItemMenu;
      }

      if (kDebugMode) {
        print('=== UPDATE ITEM REQUEST ===');
        print('URL: $uri');
        print('Body: ${jsonEncode(body)}');
      }

      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Error al actualizar item';

        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          List<String> errorMessages = [];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(messages.cast<String>());
            }
          });
          errorMessage = errorMessages.join('\n');
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en updateItem: $e');
      }
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! deleteItem
  /// Realiza un borrado lógico de un item por ID.
  /// Retorna true si fue exitoso.
  Future<bool> deleteItem(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/items-menu-service/items/$id'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Error al eliminar el item';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }
}
