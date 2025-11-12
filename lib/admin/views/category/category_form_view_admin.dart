import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategoryFormViewAdmin extends StatefulWidget {
  final Category? category;
  final Function(String nombre, String? imageUrl) onSave;
  final bool isLoading;

  const CategoryFormViewAdmin({
    super.key,
    this.category,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<CategoryFormViewAdmin> createState() => _CategoryFormViewAdminState();
}

class _CategoryFormViewAdminState extends State<CategoryFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.category?.nombre ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.category?.imgCatMenu ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final imageUrl = _imageUrlController.text.trim().isNotEmpty 
          ? _imageUrlController.text.trim() 
          : null;
      widget.onSave(_nombreController.text.trim(), imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Preview de la imagen
          if (_imageUrlController.text.isNotEmpty)
            Center(
              child: Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2E7D32),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ),

          // Campo de nombre
          TextFormField(
            controller: _nombreController,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Nombre de la categoría',
              hintText: 'Ej: Entradas, Platos fuertes, Bebidas',
              prefixIcon: const Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa el nombre de la categoría';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 24),

          // Campo de URL de imagen
          TextFormField(
            controller: _imageUrlController,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'URL de la imagen',
              hintText: 'https://ejemplo.com/imagen.jpg',
              prefixIcon: const Icon(Icons.image),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              helperText: 'Ingresa la URL completa de la imagen',
            ),
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final urlPattern = RegExp(
                  r'^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)(\?.*)?$',
                  caseSensitive: false,
                );
                if (!urlPattern.hasMatch(value.trim())) {
                  return 'Por favor ingresa una URL válida de imagen';
                }
              }
              return null;
            },
            keyboardType: TextInputType.url,
            onChanged: (value) {
              // Actualizar el preview cuando cambie la URL
              setState(() {});
            },
          ),

          const SizedBox(height: 32),

          // Botón de guardar
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.isLoading ? null : _handleSave,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                widget.isLoading
                    ? 'Guardando...'
                    : (widget.category == null ? 'Crear Categoría' : 'Actualizar Categoría'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.broken_image,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          'Error al cargar imagen',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
