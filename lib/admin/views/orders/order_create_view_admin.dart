import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/order.dart';
import '../../../services/orders_service.dart';
import '../../widgets/base_view_admin.dart';
import 'order_form_view_admin.dart';

class OrderCreateViewAdmin extends StatefulWidget {
  const OrderCreateViewAdmin({super.key});

  @override
  State<OrderCreateViewAdmin> createState() => _OrderCreateViewAdminState();
}

class _OrderCreateViewAdminState extends State<OrderCreateViewAdmin> {
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  Future<void> _handleCreate(
    int? reservaId,
    int usuarioId,
    String estado,
    double precioTotal,
  ) async {
    setState(() => _isLoading = true);

    try {
      // Crear el objeto Order para el nuevo pedido
      final newOrder = Order(
        id: 0, // El ID será asignado por el servidor
        reservaId: reservaId,
        usuarioId: usuarioId,
        estPedido: estado,
        preTotPedido: precioTotal,
        detallesPedido: [], // Lista vacía inicialmente
      );

      final createdOrder = await _orderService.createOrder(newOrder);

      if (createdOrder.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pedido creado exitosamente'),
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
            content: Text('Error al crear pedido: $e'),
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
      title: 'Crear Pedido',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: OrderFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}