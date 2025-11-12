import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/category.dart';
import '../../../services/item_menu_service.dart';
import '../../widgets/base_view_admin.dart';
import 'item_form_view_admin.dart';

class ItemCreateViewAdmin extends StatefulWidget {
  const ItemCreateViewAdmin({super.key});

  @override
  State<ItemCreateViewAdmin> createState() => _ItemCreateViewAdminState();
}

class _ItemCreateViewAdminState extends State<ItemCreateViewAdmin> {
  final ItemMenuService _itemMenuService = ItemMenuService();
  bool _isLoading = false;

  Future<void> _handleCreate(
    String nombre,
    double precio,
    String descripcion,
    bool disponible,
    int categoryId,
    String? imageUrl,
  ) async {
    setState(() => _isLoading = true);

    try {
      // Crear objeto ItemMenu temporal (el ID será asignado por la API)
      final newItem = ItemMenu(
        id: 0, // Temporal
        nomItem: nombre,
        precItem: precio,
        descItem: descripcion,
        estItem: disponible,
        imgItemMenu: '',
      );

      final success = await _itemMenuService.createItem(
        newItem,
        categoryId,
        imageUrl: imageUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se creó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear item: $e'),
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
      title: 'Crear Item',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: ItemFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
