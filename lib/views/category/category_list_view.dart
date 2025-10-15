import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../widgets/base_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  //* Se crea una instancia de la clase CategoryService
  final CategoryService _categoryService = CategoryService();
  //* Se declara una variable de tipo Future que contendrá la lista de categorías
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getCategoriesByRestaurant de la clase CategoryService
    // Por ahora usamos el restaurante con ID 1
    _futureCategories = _categoryService.getCategoriesByRestaurant(1);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Categorías del Menú',
      //! Se crea un FutureBuilder que se encargará de construir la lista de categorías
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de categorías
            final categories = snapshot.data!;
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  //* gestureDetector se utiliza para detectar gestos del usuario
                  //* en este caso se utiliza para navegar a la vista de detalle de la categoría
                  child: GestureDetector(
                    onTap: () {
                      context.push('/category/${category.id}');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Imagen de la categoría (placeholder por ahora)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Icon(
                                  _getCategoryIcon(category.nombre),
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.nombre.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${category.itemsMenu.length} items',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureCategories = _categoryService.getCategoriesByRestaurant(1);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  //* Método helper para obtener iconos según el nombre de la categoría
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'entradas':
        return Icons.restaurant;
      case 'platos principales':
        return Icons.dinner_dining;
      case 'postres':
        return Icons.cake;
      case 'bebidas':
        return Icons.local_drink;
      default:
        return Icons.restaurant_menu;
    }
  }
}
