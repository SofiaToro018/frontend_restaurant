import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/category.dart';

/// Servicio singleton para gestionar el carrito de compras
class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Cart _cart = Cart();

  /// Obtener el carrito actual
  Cart get cart => _cart;

  /// Obtener la cantidad total de items
  int get totalItems => _cart.totalItems;

  /// Obtener el precio total
  double get totalPrice => _cart.totalPrice;

  /// Verificar si el carrito está vacío
  bool get isEmpty => _cart.isEmpty;

  /// Agregar un item al carrito
  void addItem(ItemMenu item, {int quantity = 1, String? specialInstructions}) {
    _cart.addItem(item, quantity: quantity, specialInstructions: specialInstructions);
    notifyListeners();
    
    if (kDebugMode) {
      print('CartService: Item agregado - ${item.nomItem} (Cantidad: $quantity)');
      print('CartService: Total items en carrito: $totalItems');
    }
  }

  /// Remover un item del carrito
  void removeItem(int itemId) {
    _cart.removeItem(itemId);
    notifyListeners();
    
    if (kDebugMode) {
      print('CartService: Item removido - ID: $itemId');
      print('CartService: Total items en carrito: $totalItems');
    }
  }

  /// Actualizar cantidad de un item
  void updateItemQuantity(int itemId, int newQuantity) {
    _cart.updateItemQuantity(itemId, newQuantity);
    notifyListeners();
    
    if (kDebugMode) {
      print('CartService: Cantidad actualizada - ID: $itemId, Nueva cantidad: $newQuantity');
    }
  }

  /// Limpiar todo el carrito
  void clearCart() {
    _cart.clear();
    notifyListeners();
    
    if (kDebugMode) {
      print('CartService: Carrito limpiado');
    }
  }

  /// Obtener un item específico
  CartItem? getItem(int itemId) {
    return _cart.getItem(itemId);
  }

  /// Verificar si un item existe en el carrito
  bool hasItem(int itemId) {
    return _cart.hasItem(itemId);
  }

  /// Obtener resumen del carrito
  Map<String, dynamic> getSummary() {
    return _cart.getSummary();
  }

  /// Obtener la cantidad de un item específico
  int getItemQuantity(int itemId) {
    final cartItem = _cart.getItem(itemId);
    return cartItem?.quantity ?? 0;
  }
}