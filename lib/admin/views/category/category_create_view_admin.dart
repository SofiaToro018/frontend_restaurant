import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/category.dart';
import '../../../services/category_service.dart';
import '../../widgets/base_view_admin.dart';
import 'category_form_view_admin.dart';

class CategoryCreateViewAdmin extends StatefulWidget {
  const CategoryCreateViewAdmin({super.key});

  @override
  State<CategoryCreateViewAdmin> createState() => _CategoryCreateViewAdminState();
}

class _CategoryCreateViewAdminState extends State<CategoryCreateViewAdmin> {
  final CategoryService _categoryService = CategoryService();
  bool _isLoading = false;

  Future<void> _handleCreate(String nombre, String? imageUrl) async {
    setState(() => _isLoading = true);

    try {
      // Crear objeto Category temporal (el ID será asignado por la API)
      final newCategory = Category(
        id: 0, // Temporal
        nombre: nombre,
        imgCatMenu: '',
        itemsMenu: [],
      );

      final success = await _categoryService.createCategory(
        newCategory,
        imageUrl: imageUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoría creada exitosamente'),
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
            content: Text('Error al crear categoría: $e'),
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
      title: 'Crear Categoría',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: CategoryFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
