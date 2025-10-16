import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/order.dart';
import '../../services/orders_service.dart';
import '../../widgets/base_view.dart';

class OrdersListView extends StatefulWidget {
  const OrdersListView({super.key});

  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {
  //* Se crea una instancia de la clase OrderService
  final OrderService _orderService = OrderService();
  //* Se declara una variable de tipo Future que contendrá la lista de Orders
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getOrdersByUser de la clase OrderService
    // Obtener pedidos del usuario por defecto del .env
    final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
    _futureOrders = _orderService.getOrdersByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Mis Pedidos',
      //! Se crea un FutureBuilder que se encargará de construir la lista de Orders
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de Orders
            final orders = snapshot.data!;
            
            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tienes pedidos aún',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  //* gestureDetector se utiliza para detectar gestos del usuario
                  //* en este caso se utiliza para navegar a la vista de detalle del Order
                  child: GestureDetector(
                    onTap: () {
                      context.push('/order/${order.id}');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Icono del estado del pedido
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.estPedido),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                _getStatusIcon(order.estPedido),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Número de pedido
                                  Text(
                                    'PEDIDO #${order.id}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Estado del pedido
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.estPedido).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      order.statusDescription,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getStatusColor(order.estPedido),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Precio total
                                  Text(
                                    '\$${order.preTotPedido.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Número de items
                                  Text(
                                    '${order.totalItems} ${order.totalItems == 1 ? 'item' : 'items'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar pedidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
                        _futureOrders = _orderService.getOrdersByUser(userId);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Método para obtener el color según el estado del pedido
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'EN_PREPARACION':
        return Colors.blue;
      case 'COMPLETADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el icono según el estado del pedido
  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
        return Icons.schedule;
      case 'EN_PREPARACION':
        return Icons.restaurant;
      case 'COMPLETADO':
        return Icons.check_circle;
      case 'CANCELADO':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }
}
