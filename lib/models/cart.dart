import '../models/category.dart';

/// Modelo para representar un item en el carrito de compras
class CartItem {
  final ItemMenu item;
  int quantity;
  String? specialInstructions;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.specialInstructions,
  });

  /// Precio total de este item (precio unitario × cantidad)
  double get totalPrice => item.precItem * quantity;

  /// Crear una copia del CartItem con nuevos valores
  CartItem copyWith({
    ItemMenu? item,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  /// Convertir a JSON para serialización
  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  /// Crear desde JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: ItemMenu.fromJson(json['item']),
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['specialInstructions'],
    );
  }
}

/// Modelo para gestionar el carrito completo
class Cart {
  final List<CartItem> _items = [];

  /// Constructor por defecto
  Cart();

  /// Obtener todos los items del carrito
  List<CartItem> get items => List.unmodifiable(_items);

  /// Verificar si el carrito está vacío
  bool get isEmpty => _items.isEmpty;

  /// Obtener la cantidad total de items
  int get totalItems => _items.fold(0, (total, item) => total + item.quantity);

  /// Obtener el precio total del carrito
  double get totalPrice => _items.fold(0.0, (total, item) => total + item.totalPrice);

  /// Agregar un item al carrito
  void addItem(ItemMenu item, {int quantity = 1, String? specialInstructions}) {
    // Buscar si ya existe el mismo item
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    
    if (existingIndex != -1) {
      // Si existe, aumentar la cantidad
      _items[existingIndex].quantity += quantity;
    } else {
      // Si no existe, agregarlo como nuevo item
      _items.add(CartItem(
        item: item,
        quantity: quantity,
        specialInstructions: specialInstructions,
      ));
    }
  }

  /// Remover un item del carrito
  void removeItem(int itemId) {
    _items.removeWhere((cartItem) => cartItem.item.id == itemId);
  }

  /// Actualizar la cantidad de un item
  void updateItemQuantity(int itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }
    
    final index = _items.indexWhere((cartItem) => cartItem.item.id == itemId);
    if (index != -1) {
      _items[index].quantity = newQuantity;
    }
  }

  /// Limpiar todo el carrito
  void clear() {
    _items.clear();
  }

  /// Obtener un item específico por ID
  CartItem? getItem(int itemId) {
    try {
      return _items.firstWhere((cartItem) => cartItem.item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Verificar si un item existe en el carrito
  bool hasItem(int itemId) {
    return _items.any((cartItem) => cartItem.item.id == itemId);
  }

  /// Obtener resumen del carrito para mostrar
  Map<String, dynamic> getSummary() {
    return {
      'totalItems': totalItems,
      'totalPrice': totalPrice,
      'itemCount': _items.length,
      'isEmpty': isEmpty,
    };
  }

  /// Convertir todo el carrito a JSON
  Map<String, dynamic> toJson() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
      'summary': getSummary(),
    };
  }

  /// Crear carrito desde JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    final cart = Cart();
    if (json['items'] != null) {
      final itemsList = json['items'] as List;
      for (final itemJson in itemsList) {
        cart._items.add(CartItem.fromJson(itemJson));
      }
    }
    return cart;
  }
}