import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/category.dart';

//! El CategoryService es el encargado de hacer las peticiones a la API de categorías
class CategoryService {
  // ! Se obtiene la url de la api desde el archivo .env
  String apiUrl = dotenv.env['API_URL']!;

  // ! Método para obtener la lista de categorías de un restaurante específico
  // * Se hace una petición HTTP a la URL de la API y se obtiene la respuesta
  // * Si el estado de la respuesta es 200 se decodifica la respuesta y se mapea a objetos Category

  Future<List<Category>> getCategoriesByRestaurant(int restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/categoria-menu-service/categorias/restaurante/$restaurantId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Se mapea la lista de JSON a una lista de objetos Category
        List<Category> categories = data.map((categoryJson) {
          return Category.fromJson(categoryJson);
        }).toList();
        
        return categories;
      } else {
        throw Exception('Error al obtener las categorías del restaurante: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getCategoriesByRestaurant: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener una categoría específica por su ID
  Future<Category> getCategoryById(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/categoria-menu-service/categorias/$categoryId')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Category.fromJson(data);
      } else {
        throw Exception('Error al obtener la categoría: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en getCategoryById: $e');
      }
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // ! Método para obtener todos los items de menú de una categoría específica
  Future<List<ItemMenu>> getItemsByCategory(int categoryId) async {
    try {
      final category = await getCategoryById(categoryId);
      return category.itemsMenu;
    } catch (e) {
      if (kDebugMode) {
        print('Error en getItemsByCategory: $e');
      }
      throw Exception('Error al obtener los items de la categoría: $e');
    }
  }

  //! createCategory
  /// Crea una nueva categoría en la API.
  /// Recibe un objeto Category y una URL de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> createCategory(
    Category category, {
    String? imageUrl,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/categoria-menu-service/categoria');

      // Preparar el body con los datos de la categoría
      final Map<String, dynamic> body = {
        'nombre': category.nombre,
        'restaurante': {
          'id': int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1'),
        },
      };

      // Agregar imagen si existe
      if (imageUrl != null && imageUrl.isNotEmpty) {
        body['imgCatMenu'] = imageUrl;
      }

      if (kDebugMode) {
        print('=== CREATE CATEGORY REQUEST ===');
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
        String errorMessage = 'Error al crear categoría';

        // Verificar si hay errores de validación específicos
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          // Construir mensaje con todos los errores
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
        print('Error en createCategory: $e');
      }
      // Si ya es una excepción con mensaje de la API, relanzarla
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! updateCategory
  /// Actualiza una categoría en la API.
  /// Recibe un objeto Category y una URL de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> updateCategory(
    Category category, {
    String? imageUrl,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/categoria-menu-service/categoria');

      // Preparar el body con los datos de la categoría
      // El backend usa el mismo método save() para create y update
      // Necesita el objeto completo como lo espera JPA
      final Map<String, dynamic> body = {
        'id': category.id,
        'nombre': category.nombre,
      };

      // Agregar imagen si existe
      if (imageUrl != null && imageUrl.isNotEmpty) {
        body['imgCatMenu'] = imageUrl;
      } else if (category.imgCatMenu.isNotEmpty) {
        // Mantener la imagen actual si no se proporciona una nueva
        body['imgCatMenu'] = category.imgCatMenu;
      }
      
      // Agregar el restaurante como objeto simple con solo el ID
      // JPA lo convertirá en una referencia usando el ID
      body['restaurante'] = {
        'id': int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1'),
      };

      if (kDebugMode) {
        print('=== UPDATE CATEGORY REQUEST ===');
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
        // Intentar extraer el mensaje de error de la API
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Error al actualizar categoría';

        // Verificar si hay errores de validación específicos
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          // Construir mensaje con todos los errores
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
        print('Error en updateCategory: $e');
      }
      // Si ya es una excepción con mensaje de la API, relanzarla
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! deleteCategory
  /// Realiza un borrado lógico de una categoría por ID.
  /// Retorna true si fue exitoso.
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/categoria-menu-service/categorias/$id'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Error al eliminar la categoría';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }
}