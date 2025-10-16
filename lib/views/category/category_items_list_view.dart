import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../themes/category_theme/category_items_list_view_theme.dart';

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
      appBar: AppBar(
        title: Text(
          'Items de Categoría #${widget.categoryId}',
          style: CategoryItemsListViewTheme.appBarTitleStyle,
        ),
      ),
      //* se usa future builder para construir widgets basados en un Future
      body: FutureBuilder<Category>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final category = snapshot.data!; // Se obtiene el detalle de la categoría
            return SingleChildScrollView(
              padding: CategoryItemsListViewTheme.mainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card con información de la categoría (COMPLETAMENTE CENTRADO)
                  Center(
                    child: Container(
                      margin: CategoryItemsListViewTheme.categoryCardMargin,
                      child: Card(
                        elevation: CategoryItemsListViewTheme.categoryCardElevation,
                        shape: CategoryItemsListViewTheme.categoryCardShape,
                        child: Container(
                          decoration: CategoryItemsListViewTheme.categoryCardDecoration,
                          child: Padding(
                            padding: CategoryItemsListViewTheme.categoryCardPadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Ícono de la categoría
                                Icon(
                                  _getCategoryIcon(category.nombre),
                                  size: CategoryItemsListViewTheme.categoryIconSize,
                                  color: CategoryItemsListViewTheme.categoryIconColor,
                                ),
                                SizedBox(height: CategoryItemsListViewTheme.categoryCardSpacing),

                                // Nombre de la categoría
                                Text(
                                  category.nombre.toUpperCase(),
                                  style: CategoryItemsListViewTheme.categoryTitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),

                                // Información de items
                                Text(
                                  '${category.itemsMenu.length} items en esta categoría',
                                  style: CategoryItemsListViewTheme.categorySubtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: CategoryItemsListViewTheme.sectionSpacing),

                  // Lista de items en GRID 2x2
                  if (category.itemsMenu.isNotEmpty) ...[
                    const Text(
                      'Items del Menú',
                      style: CategoryItemsListViewTheme.itemsSectionTitleStyle,
                    ),
                    SizedBox(height: CategoryItemsListViewTheme.itemsSectionTitleSpacing),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: CategoryItemsListViewTheme.gridCrossAxisCount,
                        crossAxisSpacing: CategoryItemsListViewTheme.gridCrossAxisSpacing,
                        mainAxisSpacing: CategoryItemsListViewTheme.gridMainAxisSpacing,
                        childAspectRatio: CategoryItemsListViewTheme.gridChildAspectRatio,
                      ),
                      itemCount: category.itemsMenu.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(category.itemsMenu[index]);
                      },
                    ),
                  ] else ...[
                    Container(
                      padding: CategoryItemsListViewTheme.emptyViewPadding,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: CategoryItemsListViewTheme.emptyViewIconSize,
                              color: CategoryItemsListViewTheme.emptyViewIconColor,
                            ),
                            SizedBox(height: CategoryItemsListViewTheme.emptyViewSpacing),
                            Text(
                              'Esta categoría no tiene items disponibles',
                              style: CategoryItemsListViewTheme.emptyViewTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: CategoryItemsListViewTheme.errorTextStyle,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildItemCard(ItemMenu item) {
    return Card(
      elevation: CategoryItemsListViewTheme.itemCardElevation,
      margin: CategoryItemsListViewTheme.itemCardMargin,
      shape: CategoryItemsListViewTheme.itemCardShape,
      child: Container(
        decoration: CategoryItemsListViewTheme.itemCardDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(CategoryItemsListViewTheme.itemCardBorderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(CategoryItemsListViewTheme.itemCardBorderRadius),
            onTap: item.estItem
                ? () {
                    context.push('/item/${item.id}');
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del plato (parte superior)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(CategoryItemsListViewTheme.itemCardBorderRadius),
                    topRight: Radius.circular(CategoryItemsListViewTheme.itemCardBorderRadius),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: CategoryItemsListViewTheme.itemImageHeight,
                    decoration: CategoryItemsListViewTheme.itemImageDecoration,
                    child: item.imgItemMenu.isNotEmpty
                        ? Image.network(
                            item.imgItemMenu,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                ),
                              );
                            },
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
                
                // Contenido de la tarjeta
                Expanded(
                  child: Padding(
                    padding: CategoryItemsListViewTheme.itemCardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estado "No disponible" si aplica
                        if (!item.estItem)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: CategoryItemsListViewTheme.chipPadding,
                            decoration: CategoryItemsListViewTheme.chipDecoration,
                            child: Text(
                              'No disponible',
                              style: CategoryItemsListViewTheme.chipTextStyle.copyWith(
                                color: CategoryItemsListViewTheme.chipTextColor,
                              ),
                            ),
                          ),
                        
                        // Nombre del plato
                        Text(
                          item.nomItem,
                          style: item.estItem 
                            ? CategoryItemsListViewTheme.itemTitleStyle
                            : CategoryItemsListViewTheme.itemTitleDisabledStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: CategoryItemsListViewTheme.itemContentSpacing),
                        
                        // Descripción
                        if (item.descItem.isNotEmpty)
                          Text(
                            item.descItem,
                            style: CategoryItemsListViewTheme.itemDescriptionStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        
                        const Spacer(),
                        
                        // Precio y botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '\$${item.precItem.toStringAsFixed(0)}',
                                style: item.estItem 
                                  ? CategoryItemsListViewTheme.itemPriceStyle
                                  : CategoryItemsListViewTheme.itemPriceDisabledStyle,
                              ),
                            ),
                            if (item.estItem)
                              Container(
                                padding: CategoryItemsListViewTheme.addButtonPadding,
                                decoration: CategoryItemsListViewTheme.addButtonDecoration,
                                child: Icon(
                                  Icons.add,
                                  size: CategoryItemsListViewTheme.addButtonIconSize,
                                  color: CategoryItemsListViewTheme.addButtonIconColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: CategoryItemsListViewTheme.itemImageDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: CategoryItemsListViewTheme.itemImageIconSize,
            color: CategoryItemsListViewTheme.itemImageIconColor,
          ),
          const SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }  IconData _getCategoryIcon(String categoryName) {
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