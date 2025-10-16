import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';

class CategoryItemsListView extends StatefulWidget {
  final String categoryId;
  
  const CategoryItemsListView({super.key, required this.categoryId});

  @override
  State<CategoryItemsListView> createState() => _CategoryItemsListViewState();
}

class _CategoryItemsListViewState extends State<CategoryItemsListView> {
  // Se crea una instancia de la clase CategoryService
  final CategoryService _categoryService = CategoryService();
  // Se declara una variable de tipo Future que contendrá el detalle de la categoría
  late Future<Category> _futureCategory;

  @override
  void initState() {
    super.initState();
    // Se llama al método getCategoryById de la clase CategoryService
    _futureCategory = _categoryService.getCategoryById(int.parse(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items de Categoría #${widget.categoryId}')),
      //* se usa future builder para construir widgets basados en un Future
      body: FutureBuilder<Category>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final category = snapshot.data!; // Se obtiene el detalle de la categoría
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card con información de la categoría
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Ícono de la categoría
                          Icon(
                            _getCategoryIcon(category.nombre),
                            size: 80,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 16),

                          // Nombre de la categoría
                          Text(
                            category.nombre.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Información de items
                          Text(
                            '${category.itemsMenu.length} items en esta categoría',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Lista de items
                  if (category.itemsMenu.isNotEmpty) ...[
                    const Text(
                      'Items del Menú',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...category.itemsMenu.map((item) => _buildItemCard(item)),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Esta categoría no tiene items disponibles',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildItemCard(ItemMenu item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: item.estItem
            ? () {
                // Navegar a detalle del item
                context.push('/item/${item.id}');
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Imagen del item
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: item.imgItemMenu.isNotEmpty
                    ? Image.network(
                        item.imgItemMenu,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.restaurant, color: Colors.grey[400]),
                      )
                    : Icon(Icons.restaurant, color: Colors.grey[400]),
              ),
              const SizedBox(width: 16.0),

              // Información del item
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nomItem,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: item.estItem ? Colors.black87 : Colors.grey[500],
                      ),
                    ),
                    if (item.descItem.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.descItem,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.precItem.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: item.estItem ? Colors.green[600] : Colors.grey[500],
                          ),
                        ),
                        if (!item.estItem)
                          Chip(
                            label: const Text('No disponible'),
                            backgroundColor: Colors.red[100],
                            labelStyle: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          )
                        else
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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