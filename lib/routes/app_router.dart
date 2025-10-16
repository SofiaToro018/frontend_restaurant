import 'package:go_router/go_router.dart';
import '../views/category/category_list_view.dart';
import '../views/category/category_items_list_view.dart';
import '../views/category/item_detail_view.dart';
import '../views/orders/orders_list_view.dart';
import '../views/orders/orders_detail_view.dart';
import '../views/booking/booking_list_view.dart';
import '../views/booking/booking_detail_view.dart';
import '../views/audit_log/audit_log_list_view.dart';
import '../views/audit_log/audit_log_detail_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/menu',
  routes: [
    // Redirección desde raíz al menú
    GoRoute(
      path: '/',
      redirect: (context, state) => '/menu',
    ),
    
    // Ruta principal - Menú de Categorías (Vista inicial)
    GoRoute(
      path: '/menu',
      builder: (context, state) => const CategoryListView(),
    ),
    
    // Ruta para lista de items de categoría
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return CategoryItemsListView(categoryId: categoryId);
      },
    ),
    
    // Ruta para detalle de item individual
    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final itemId = state.pathParameters['id']!;
        return ItemDetailView(itemId: itemId);
      },
    ),
    
    // Ruta para lista de pedidos
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersListView(),
    ),
    
    // Ruta para detalle de pedido
    GoRoute(
      path: '/order/:id',
      builder: (context, state) {
        final orderId = state.pathParameters['id']!;
        return OrdersDetailView(orderId: orderId);
      },
    ),
    
    // Ruta para lista de reservas
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingListView(),
    ),
    
    // Ruta para detalle de reserva
    GoRoute(
      path: '/booking/:id',
      builder: (context, state) {
        final bookingId = state.pathParameters['id']!;
        return BookingDetailView(bookingId: bookingId);
      },
    ),
    
    // Ruta para lista de registros de cambios
    GoRoute(
      path: '/audit-logs',
      builder: (context, state) => const AuditLogListView(),
    ),
    
    // Ruta para detalle de registro de cambios
    GoRoute(
      path: '/audit-log/:id',
      builder: (context, state) {
        final auditLogId = state.pathParameters['id']!;
        return AuditLogDetailView(auditLogId: auditLogId);
      },
    ),
  ],

);