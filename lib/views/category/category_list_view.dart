import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../widgets/base_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final CategoryService _categoryService = CategoryService();

  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    //! Obtiene las categorías con todos sus items
    final restaurantId = int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1');
    _futureCategories = _categoryService.getCategoriesByRestaurant(
      restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Menú Completo',
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay menú disponible',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategorySection(category);
              },
            );
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCategorySection(Category category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de la categoría
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                // Navegar al detalle de la categoría
                context.push('/category/${category.id}');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(category.nombre),
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.nombre.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${category.itemsMenu.where((item) => item.estItem).length} items disponibles',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Lista horizontal de items de la categoría
        if (category.itemsMenu.isEmpty)
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                'No hay items en esta categoría',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 220, // Altura fija para el scroll horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemCount: category.itemsMenu.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(category.itemsMenu[index], category.id);
              },
            ),
          ),

        const SizedBox(height: 24.0), // Separador entre categorías
      ],
    );
  }

  Widget _buildMenuItem(ItemMenu item, int categoryId) {
    return Container(
      width: 180, // Ancho fijo para cada tarjeta horizontal
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: item.estItem ? Colors.transparent : Colors.red[200]!,
          width: item.estItem ? 0 : 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: item.estItem
              ? () {
                  // Navegar al detalle del item individual
                  context.push('/item/${item.id}');
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del item
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    color: Colors.grey[200],
                    child: item.imgItemMenu.isNotEmpty
                        ? Image.network(
                            item.imgItemMenu,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholderImage(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          )
                        : _placeholderImage(),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Estado del item (si no está disponible)
                if (!item.estItem)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    margin: const EdgeInsets.only(bottom: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'No disponible',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // Nombre del item
                Text(
                  item.nomItem,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: item.estItem ? Colors.black87 : Colors.grey[500],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),

                // Descripción
                if (item.descItem.isNotEmpty)
                  Text(
                    item.descItem,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const Spacer(), // Empuja el precio hacia abajo
                // Precio y botón de agregar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.precItem.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.estItem
                            ? Colors.green[600]
                            : Colors.grey[500],
                      ),
                    ),
                    if (item.estItem)
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.orange[600],
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar el menú',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.red[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final restaurantId = int.parse(
                  dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1',
                );
                _futureCategories = _categoryService.getCategoriesByRestaurant(
                  restaurantId,
                );
              });
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Icon(Icons.restaurant, size: 32, color: Colors.grey[400]),
    );
  }

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
