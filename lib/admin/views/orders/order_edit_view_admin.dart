import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/order.dart';
import '../../../services/orders_service.dart';
import '../../widgets/base_view_admin.dart';
import 'order_form_view_admin.dart';

class OrderEditViewAdmin extends StatefulWidget {
  final String orderId;

  const OrderEditViewAdmin({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderEditViewAdmin> createState() => _OrderEditViewAdminState();
}

class _OrderEditViewAdminState extends State<OrderEditViewAdmin> {
  final OrderService _orderService = OrderService();
  
  bool _isLoading = false;
  Order? _order;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      final orderId = int.parse(widget.orderId);
      final order = await _orderService.getOrderById(orderId);
      
      setState(() {
        _order = order;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(
    int? reservaId,
    int usuarioId,
    String estado,
    double precioTotal,
  ) async {
    if (_order == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto Order
      final updatedOrder = Order(
        id: _order!.id,
        reservaId: reservaId,
        usuarioId: usuarioId,
        estPedido: estado,
        preTotPedido: precioTotal,
        detallesPedido: _order!.detallesPedido, // Mantener los detalles existentes
      );

      final result = await _orderService.updateOrder(updatedOrder);

      if (result.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pedido actualizado exitosamente'),
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
            content: Text('Error al actualizar pedido: $e'),
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
      title: 'Editar Pedido',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _order == null
                ? const Center(
                    child: Text('No se pudo cargar el pedido'),
                  )
                : OrderFormViewAdmin(
                    order: _order,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}