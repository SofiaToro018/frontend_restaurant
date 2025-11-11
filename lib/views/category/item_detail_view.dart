import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../themes/category_theme/item_detail_view_theme.dart';
import '../../utils/currency_formatter.dart';

class ItemDetailView extends StatefulWidget {
  final String itemId;
  
  const ItemDetailView({super.key, required this.itemId});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  final CategoryService _categoryService = CategoryService();
  late Future<ItemMenu?> _futureItem;

  @override
  void initState() {
    super.initState();
    _futureItem = _getItemById(int.parse(widget.itemId));
  }

  // Método para encontrar un item específico por ID
  Future<ItemMenu?> _getItemById(int itemId) async {
    try {
      // Obtener todas las categorías para buscar el item
      final categories = await _categoryService.getCategoriesByRestaurant(1);
      
      for (final category in categories) {
        for (final item in category.itemsMenu) {
          if (item.id == itemId) {
            return item;
          }
        }
      }
      return null; // Item no encontrado
    } catch (e) {
      throw Exception('Error al buscar el item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ItemMenu?>(
        future: _futureItem,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final item = snapshot.data;
            if (item == null) {
              return _buildNotFoundView();
            }
            return _buildItemDetail(item);
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildItemDetail(ItemMenu item) {
    return CustomScrollView(
      slivers: [
        // App Bar con imagen de fondo
        SliverAppBar(
          expandedHeight: ItemDetailViewTheme.appBarExpandedHeight,
          floating: false,
          pinned: true,
          backgroundColor: ItemDetailViewTheme.appBarBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen del item
                item.imgItemMenu.isNotEmpty
                    ? Image.network(
                        item.imgItemMenu,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderBackground(),
                      )
                    : _buildPlaceholderBackground(),
                
                // Gradiente sobre la imagen
                Container(
                  decoration: ItemDetailViewTheme.imageGradientDecoration,
                ),

                // Indicador de estado si no está disponible
                if (!item.estItem)
                  Positioned(
                    top: ItemDetailViewTheme.notAvailableTop,
                    right: ItemDetailViewTheme.notAvailableRight,
                    child: Container(
                      padding: ItemDetailViewTheme.notAvailablePadding,
                      decoration: ItemDetailViewTheme.notAvailableDecoration,
                      child: const Text(
                        'NO DISPONIBLE',
                        style: ItemDetailViewTheme.notAvailableTextStyle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Contenido principal
        SliverToBoxAdapter(
          child: Padding(
            padding: ItemDetailViewTheme.mainPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del item
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.nomItem,
                        style: item.estItem 
                            ? ItemDetailViewTheme.itemNameStyle
                            : ItemDetailViewTheme.itemNameDisabledStyle,
                      ),
                    ),
                    // Precio
                    Container(
                      padding: ItemDetailViewTheme.priceContainerPadding,
                      decoration: ItemDetailViewTheme.priceContainerDecoration(item.estItem),
                      child: Text(
                        CurrencyFormatter.formatColombianPrice(item.precItem),
                        style: item.estItem 
                            ? ItemDetailViewTheme.priceStyle
                            : ItemDetailViewTheme.priceDisabledStyle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ItemDetailViewTheme.itemNameSpacing),

                // Descripción
                if (item.descItem.isNotEmpty) ...[
                  const Text(
                    'Descripción',
                    style: ItemDetailViewTheme.descriptionTitleStyle,
                  ),
                  const SizedBox(height: ItemDetailViewTheme.descriptionSpacing),
                  Container(
                    width: double.infinity,
                    padding: ItemDetailViewTheme.descriptionPadding,
                    decoration: ItemDetailViewTheme.descriptionDecoration,
                    child: Text(
                      item.descItem,
                      style: ItemDetailViewTheme.descriptionTextStyle,
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: ItemDetailViewTheme.descriptionPadding,
                    decoration: ItemDetailViewTheme.descriptionDecoration,
                    child: Text(
                      'Este producto no tiene descripción disponible.',
                      style: ItemDetailViewTheme.descriptionPlaceholderStyle,
                    ),
                  ),
                ],

                const SizedBox(height: ItemDetailViewTheme.infoCardSpacing),

                // Información adicional
                _buildInfoCard(),

                const SizedBox(height: ItemDetailViewTheme.infoCardSpacing),

                // Botones de acción
                _buildActionButtons(item),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: ItemDetailViewTheme.infoCardPadding,
      decoration: ItemDetailViewTheme.infoCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ItemDetailViewTheme.infoCardIconColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Información del Producto',
                style: ItemDetailViewTheme.infoCardTitleStyle,
              ),
            ],
          ),
          const SizedBox(height: ItemDetailViewTheme.infoCardTitleSpacing),
          _buildInfoRow(Icons.restaurant, 'ID del Producto', '#${widget.itemId}'),
          const SizedBox(height: ItemDetailViewTheme.infoRowSpacing),
          _buildInfoRow(
            Icons.schedule, 
            'Tiempo de preparación', 
            '15-20 minutos'
          ),
          const SizedBox(height: ItemDetailViewTheme.infoRowSpacing),
          _buildInfoRow(
            Icons.local_offer, 
            'Categoría', 
            'Disponible en menú'
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: ItemDetailViewTheme.infoCardRowIconColor,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: ItemDetailViewTheme.infoRowLabelStyle,
        ),
        Expanded(
          child: Text(
            value,
            style: ItemDetailViewTheme.infoRowValueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ItemMenu item) {
    return Column(
      children: [
        // Botón principal
        SizedBox(
          width: double.infinity,
          height: ItemDetailViewTheme.actionButtonHeight,
          child: ElevatedButton(
            onPressed: item.estItem
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.nomItem} añadido'),
                        backgroundColor: ItemDetailViewTheme.primaryOrangeShade600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: ItemDetailViewTheme.primaryButtonStyle(item.estItem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.estItem ? Icons.check_circle_outline : Icons.block,
                  size: ItemDetailViewTheme.buttonIconSize,
                ),
                const SizedBox(width: ItemDetailViewTheme.buttonTextSpacing),
                Text(
                  item.estItem
                      ? 'Ordenar - ${CurrencyFormatter.formatColombianPrice(item.precItem)}'
                      : 'Producto No Disponible',
                  style: ItemDetailViewTheme.primaryButtonTextStyle,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: ItemDetailViewTheme.buttonSpacing),

        // Botón secundario
        SizedBox(
          width: double.infinity,
          height: ItemDetailViewTheme.secondaryButtonHeight,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.nomItem} agregado a favoritos'),
                  backgroundColor: ItemDetailViewTheme.primaryOrangeShade600,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ItemDetailViewTheme.secondaryButtonStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  color: ItemDetailViewTheme.secondaryButtonIconColor,
                  size: ItemDetailViewTheme.secondaryButtonIconSize,
                ),
                SizedBox(width: ItemDetailViewTheme.secondaryButtonTextSpacing),
                Text(
                  'Agregar a Favoritos',
                  style: ItemDetailViewTheme.secondaryButtonTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ItemDetailViewTheme.placeholderBackgroundColor,
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: ItemDetailViewTheme.placeholderIconSize,
              color: ItemDetailViewTheme.placeholderIconColor,
            ),
            SizedBox(height: ItemDetailViewTheme.placeholderSpacing),
            Text(
              'Sin imagen disponible',
              style: ItemDetailViewTheme.placeholderTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item no encontrado'),
        backgroundColor: ItemDetailViewTheme.errorAppBarColor,
        foregroundColor: ItemDetailViewTheme.errorAppBarTextColor,
      ),
      body: Center(
        child: Padding(
          padding: ItemDetailViewTheme.errorPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: ItemDetailViewTheme.errorIconSize,
                color: ItemDetailViewTheme.errorIconColor,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorSpacing),
              Text(
                'Item no encontrado',
                style: ItemDetailViewTheme.errorTitleStyle,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorDescriptionSpacing),
              Text(
                'El item que buscas no existe o ha sido eliminado.',
                textAlign: TextAlign.center,
                style: ItemDetailViewTheme.errorDescriptionStyle,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorButtonSpacing),
              ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al Menú'),
                style: ItemDetailViewTheme.errorButtonStyle.copyWith(
                  padding: WidgetStateProperty.all(ItemDetailViewTheme.errorButtonPadding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(Object? error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: ItemDetailViewTheme.errorAppBarColor,
        foregroundColor: ItemDetailViewTheme.errorAppBarTextColor,
      ),
      body: Center(
        child: Padding(
          padding: ItemDetailViewTheme.errorPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: ItemDetailViewTheme.errorIconSize,
                color: ItemDetailViewTheme.errorIconColor,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorSpacing),
              Text(
                'Error al cargar el item',
                style: ItemDetailViewTheme.errorTitleStyle,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorDescriptionSpacing),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: ItemDetailViewTheme.errorDescriptionStyle,
              ),
              const SizedBox(height: ItemDetailViewTheme.errorButtonSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureItem = _getItemById(int.parse(widget.itemId));
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ItemDetailViewTheme.errorButtonStyle,
                  ),
                  const SizedBox(width: ItemDetailViewTheme.errorButtonRowSpacing),
                  OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}