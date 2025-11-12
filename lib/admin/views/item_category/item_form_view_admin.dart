import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/category.dart';
import '../../../services/category_service.dart';

class ItemFormViewAdmin extends StatefulWidget {
  final ItemMenu? item;
  final int? initialCategoryId;
  final Function(String nombre, double precio, String descripcion,
      bool disponible, int categoryId, String? imageUrl) onSave;
  final bool isLoading;

  const ItemFormViewAdmin({
    super.key,
    this.item,
    this.initialCategoryId,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<ItemFormViewAdmin> createState() => _ItemFormViewAdminState();
}

class _ItemFormViewAdminState extends State<ItemFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final CategoryService _categoryService = CategoryService();
  
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _descripcionController;
  late TextEditingController _imageUrlController;
  
  bool _disponible = true;
  int? _selectedCategoryId;
  List<Category> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.item?.nomItem ?? '',
    );
    _precioController = TextEditingController(
      text: widget.item?.precItem.toString() ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.item?.descItem ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.item?.imgItemMenu ?? '',
    );
    _disponible = widget.item?.estItem ?? true;
    _selectedCategoryId = widget.initialCategoryId;
    
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final restaurantId = int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1');
      final categories = await _categoryService.getCategoriesByRestaurant(restaurantId);
      setState(() {
        _categories = categories;
        _loadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _loadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar categorías: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una categoría'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final imageUrl = _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : null;
          
      widget.onSave(
        _nombreController.text.trim(),
        double.parse(_precioController.text.trim()),
        _descripcionController.text.trim(),
        _disponible,
        _selectedCategoryId!,
        imageUrl,
      );
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
              labelText: 'Nombre del item',
              hintText: 'Ej: Hamburguesa, Pizza, Jugo natural',
              prefixIcon: const Icon(Icons.restaurant_menu),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa el nombre del item';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // Campo de precio
          TextFormField(
            controller: _precioController,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Precio',
              hintText: '0.00',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa el precio';
              }
              final precio = double.tryParse(value.trim());
              if (precio == null) {
                return 'Por favor ingresa un precio válido';
              }
              if (precio <= 0) {
                return 'El precio debe ser mayor a 0';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo de descripción
          TextFormField(
            controller: _descripcionController,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: 'Describe el item del menú',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa una descripción';
              }
              if (value.trim().length < 10) {
                return 'La descripción debe tener al menos 10 caracteres';
              }
              return null;
            },
            textCapitalization: TextCapitalization.sentences,
          ),

          const SizedBox(height: 16),

          // Selector de categoría
          _loadingCategories
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<int>(
                  initialValue: (_selectedCategoryId != null && _categories.isNotEmpty)
                      ? _selectedCategoryId
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.nombre),
                    );
                  }).toList(),
                  onChanged: widget.isLoading
                      ? null
                      : (int? newValue) {
                          setState(() {
                            _selectedCategoryId = newValue;
                          });
                        },
                  validator: (int? validationValue) {
                    if (validationValue == null) {
                      return 'Por favor selecciona una categoría';
                    }
                    return null;
                  },
                ),

          const SizedBox(height: 16),

          // Switch de disponibilidad
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: SwitchListTile(
              title: const Text('Disponible'),
              subtitle: Text(
                _disponible
                    ? 'El item está disponible para ordenar'
                    : 'El item no está disponible',
              ),
              value: _disponible,
              thumbColor: const WidgetStatePropertyAll(Color(0xFF2E7D32)),
              trackColor: const WidgetStatePropertyAll(Color(0xFFB2D8B4)),
              onChanged: widget.isLoading
                  ? null
                  : (bool value) {
                      setState(() {
                        _disponible = value;
                      });
                    },
            ),
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
                    : (widget.item == null ? 'Crear Item' : 'Actualizar Item'),
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
