import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/category.dart';
import '../../../services/category_service.dart';
import '../../widgets/base_view_admin.dart';
import 'category_form_view_admin.dart';

class CategoryEditViewAdmin extends StatefulWidget {
  final String categoryId;

  const CategoryEditViewAdmin({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryEditViewAdmin> createState() => _CategoryEditViewAdminState();
}

class _CategoryEditViewAdminState extends State<CategoryEditViewAdmin> {
  final CategoryService _categoryService = CategoryService();
  bool _isLoading = false;
  Category? _category;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    try {
      final categoryId = int.parse(widget.categoryId);
      final category = await _categoryService.getCategoryById(categoryId);
      setState(() {
        _category = category;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar categoría: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(String nombre, String? imageUrl) async {
    if (_category == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto Category
      final updatedCategory = Category(
        id: _category!.id,
        nombre: nombre,
        imgCatMenu: _category!.imgCatMenu,
        itemsMenu: _category!.itemsMenu,
      );

      final success = await _categoryService.updateCategory(
        updatedCategory,
        imageUrl: imageUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoría actualizada exitosamente'),
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
            content: Text('Error al actualizar categoría: $e'),
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
      title: 'Editar Categoría',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _category == null
                ? const Center(
                    child: Text('No se pudo cargar la categoría'),
                  )
                : CategoryFormViewAdmin(
                    category: _category,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}
