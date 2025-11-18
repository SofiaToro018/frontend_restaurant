import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cart.dart';
import '../models/booking.dart';
import '../services/cart_service.dart';
import '../services/booking_service.dart';
import '../auth/services/auth_service.dart';

/// Widget del carrito que se muestra como drawer desde la derecha
class CartDrawer extends StatefulWidget {
  const CartDrawer({super.key});

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  final CartService _cartService = CartService();
  final BookingService _bookingService = BookingService();
  bool _isProcessingOrder = false;
  List<Booking> _userBookings = [];
  Booking? _selectedBooking;
  bool _isLoadingBookings = false;

  @override
  void initState() {
    super.initState();
    print('DEBUG: CartDrawer initState called');
    _loadUserBookings();
  }

  /// Cargar las reservas activas del usuario logueado
  Future<void> _loadUserBookings() async {
    final authService = AuthService();
    print('DEBUG: Usuario logueado: ${authService.currentUsuario}');
    
    if (authService.currentUsuario == null) {
      print('DEBUG: No hay usuario logueado');
      return;
    }

    print('DEBUG: Cargando reservas para usuario ID: ${authService.currentUsuario!.id}');

    setState(() {
      _isLoadingBookings = true;
    });

    try {
      final bookings = await _bookingService.getBookingsByUser(authService.currentUsuario!.id);
      print('DEBUG: Reservas obtenidas del backend: ${bookings.length}');
      
      for (var booking in bookings) {
        print('DEBUG: Reserva ID: ${booking.id}, Mesa: ${booking.mesaId}, Estado: ${booking.estReserva}, Fecha: ${booking.formattedDateTime}');
      }
      
      // Filtrar solo reservas activas (sin restricción de fecha)
      final activeBookings = bookings.where((booking) => 
        booking.isActive
      ).toList();

      print('DEBUG: Reservas activas filtradas: ${activeBookings.length}');

      setState(() {
        _userBookings = activeBookings;
        // Seleccionar automáticamente la primera reserva si existe
        if (activeBookings.isNotEmpty) {
          _selectedBooking = activeBookings.first;
          print('DEBUG: Reserva seleccionada automáticamente: ${_selectedBooking!.id}');
        } else {
          print('DEBUG: No hay reservas para seleccionar');
        }
      });
    } catch (e) {
      print('Error cargando reservas del usuario: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar tus reservas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingBookings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del carrito
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Mi Carrito',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de items del carrito
          Expanded(
            child: AnimatedBuilder(
              animation: _cartService,
              builder: (context, _) {
                if (_cartService.isEmpty) {
                  return _buildEmptyCart();
                }
                
                return Column(
                  children: [
                    // Lista de items
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cartService.cart.items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final cartItem = _cartService.cart.items[index];
                          return _buildCartItem(cartItem);
                        },
                      ),
                    ),
                    
                    // Resumen y botón de checkout
                    _buildCartSummary(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget selector de reserva
  Widget _buildBookingSelector() {
    if (_isLoadingBookings) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Cargando tus reservas...'),
          ],
        ),
      );
    }

    if (_userBookings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No tienes reservas disponibles',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Necesitas una reserva activa para realizar un pedido',
              style: TextStyle(
                color: Colors.orange.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_seat,
                color: Colors.green.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Seleccionar reserva',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Booking>(
            initialValue: _selectedBooking,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            items: _userBookings.map((booking) {
              return DropdownMenuItem<Booking>(
                value: booking,
                child: Text(
                  'Mesa ${booking.mesaId} - ${booking.formattedDate}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (Booking? newBooking) {
              setState(() {
                _selectedBooking = newBooking;
              });
            },
            hint: const Text('Selecciona una reserva'),
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar cuando el carrito está vacío
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega algunos productos para empezar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para cada item del carrito
  Widget _buildCartItem(CartItem cartItem) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del item
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: cartItem.item.imgItemMenu.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      cartItem.item.imgItemMenu,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fastfood,
                          color: Colors.grey.shade400,
                          size: 30,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.fastfood,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
          ),
          
          const SizedBox(width: 12),
          
          // Información del item
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.item.nomItem,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (cartItem.specialInstructions != null && 
                    cartItem.specialInstructions!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Nota: ${cartItem.specialInstructions}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: 8),
                
                // Precio y controles de cantidad
                Row(
                  children: [
                    Text(
                      '\$${cartItem.item.precItem.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Controles de cantidad
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (cartItem.quantity > 1) {
                                _cartService.updateItemQuantity(
                                  cartItem.item.id,
                                  cartItem.quantity - 1,
                                );
                              } else {
                                _cartService.removeItem(cartItem.item.id);
                              }
                            },
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                cartItem.quantity > 1 ? Icons.remove : Icons.delete_outline,
                                size: 18,
                                color: cartItem.quantity > 1 
                                    ? Colors.grey.shade700 
                                    : Colors.red.shade600,
                              ),
                            ),
                          ),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          
                          InkWell(
                            onTap: () {
                              _cartService.updateItemQuantity(
                                cartItem.item.id,
                                cartItem.quantity + 1,
                              );
                            },
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget del resumen del carrito y botón de checkout
  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Selector de reserva
            _buildBookingSelector(),
            
            const SizedBox(height: 16),
            
            // Resumen de precio
            Row(
              children: [
                Text(
                  '${_cartService.totalItems} productos',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: \$${_cartService.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                // Botón limpiar carrito
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () {
                      _showClearCartDialog();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Limpiar',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Botón realizar pedido
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: (_isProcessingOrder || _selectedBooking == null) ? null : () {
                      _processOrder();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessingOrder
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Procesando...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Realizar Pedido',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Mostrar diálogo de confirmación para limpiar carrito
  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar Carrito'),
          content: const Text('¿Estás seguro de que quieres eliminar todos los productos del carrito?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _cartService.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Carrito limpiado exitosamente'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              },
              child: const Text(
                'Limpiar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Procesar el pedido
  Future<void> _processOrder() async {
    if (_isProcessingOrder) return;

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final cart = _cartService.cart;
      if (cart.items.isEmpty) {
        throw Exception('El carrito está vacío');
      }

      // Verificar que haya un usuario logueado
      final authService = AuthService();
      if (authService.currentUsuario == null) {
        throw Exception('Debes iniciar sesión para realizar un pedido');
      }

      // Verificar que haya una reserva seleccionada
      if (_selectedBooking == null) {
        throw Exception('Debes seleccionar una reserva para realizar el pedido');
      }

      // Preparar los datos en el formato exacto que espera el backend
      // Por ahora enviamos solo el pedido principal, sin detalles
      final orderData = {
        'usuarioId': authService.currentUsuario!.id, // ID del usuario logueado
        'reservaId': _selectedBooking!.id, // ID de la reserva seleccionada
        'estPedido': 'PENDIENTE', // Estado del pedido
        'preTotPedido': cart.totalPrice, // Total del pedido
        'detallesPedido': [], // Lista vacía por ahora para evitar errores
      };

      print('DEBUG: Usuario logueado ID: ${authService.currentUsuario!.id}');
      print('DEBUG: Usuario logueado: ${authService.currentUsuario!.toJson()}');
      print('DEBUG: Reserva seleccionada ID: ${_selectedBooking!.id}');
      print('DEBUG: Reserva seleccionada: Mesa ${_selectedBooking!.mesaId} - ${_selectedBooking!.formattedDateTime}');
      print('DEBUG: Items del carrito: ${cart.items.length}');
      print('DEBUG: Total del carrito: ${cart.totalPrice}');
      print('DEBUG: Enviando pedido con datos: ${json.encode(orderData)}');

      // Hacer petición HTTP directa al backend
      final String apiUrl = dotenv.env['API_URL']!;
      print('DEBUG: URL completa: $apiUrl/pedido-service/pedido');
      
      final response = await http.post(
        Uri.parse('$apiUrl/pedido-service/pedido'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(orderData),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response headers: ${response.headers}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Pedido creado exitosamente
        final createdOrder = json.decode(response.body);
        
        // Limpiar el carrito
        _cartService.clearCart();
        
        // Cerrar el drawer
        if (mounted) Navigator.of(context).pop();
        
        // Mostrar mensaje de éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Pedido #${createdOrder['id']} creado exitosamente para Mesa ${_selectedBooking!.mesaId}!'),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception('Error al crear pedido. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('DEBUG: Error al procesar pedido: $e');
      print('DEBUG: Tipo de error: ${e.runtimeType}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el pedido: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }
}