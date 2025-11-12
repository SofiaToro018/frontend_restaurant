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
}