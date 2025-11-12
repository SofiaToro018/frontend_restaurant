import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import '../../../models/category.dart';
import '../../../services/category_service.dart';
import '../../../services/item_menu_service.dart';
import '../../widgets/base_view_admin.dart';
import 'item_form_view_admin.dart';

class ItemEditViewAdmin extends StatefulWidget {
  final String itemId;

  const ItemEditViewAdmin({
    super.key,
    required this.itemId,
  });

  @override
  State<ItemEditViewAdmin> createState() => _ItemEditViewAdminState();
}

class _ItemEditViewAdminState extends State<ItemEditViewAdmin> {
  final ItemMenuService _itemMenuService = ItemMenuService();
  final CategoryService _categoryService = CategoryService();
  
  bool _isLoading = false;
  ItemMenu? _item;
  int? _categoryId;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    try {
      final itemId = int.parse(widget.itemId);
      final item = await _itemMenuService.getItemById(itemId);
      
      // Buscar en qué categoría está el item
      final restaurantId = int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1');
      final categories = await _categoryService.getCategoriesByRestaurant(restaurantId);
      
      int? foundCategoryId;
      for (final category in categories) {
        for (final categoryItem in category.itemsMenu) {
          if (categoryItem.id == item.id) {
            foundCategoryId = category.id;
            break;
          }
        }
        if (foundCategoryId != null) break;
      }
      
      setState(() {
        _item = item;
        _categoryId = foundCategoryId;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar item: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(
    String nombre,
    double precio,
    String descripcion,
    bool disponible,
    int categoryId,
    String? imageUrl,
  ) async {
    if (_item == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto ItemMenu
      final updatedItem = ItemMenu(
        id: _item!.id,
        nomItem: nombre,
        precItem: precio,
        descItem: descripcion,
        estItem: disponible,
        imgItemMenu: _item!.imgItemMenu,
      );

      final success = await _itemMenuService.updateItem(
        updatedItem,
        categoryId,
        imageUrl: imageUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se actualizó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar item: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewAdmin(
      title: 'Editar Item',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _item == null
                ? const Center(
                    child: Text('No se pudo cargar el item'),
                  )
                : ItemFormViewAdmin(
                    item: _item,
                    initialCategoryId: _categoryId,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}
