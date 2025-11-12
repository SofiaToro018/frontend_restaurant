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
import '../views/profile/profile_view.dart';
import '../views/profile/profile_edit_view.dart';
import '../auth/views/login_view.dart';
import '../auth/views/register_view.dart';
import '../views/splash_intro/splash_intro_view.dart';
import '../admin/views/admin_home_view.dart';
import '../admin/views/category/category_list_view_admin.dart';
import '../admin/views/category/category_create_view_admin.dart';
import '../admin/views/category/category_edit_view_admin.dart';
import '../admin/views/item_category/item_list_view_admin.dart';
import '../admin/views/item_category/item_create_view_admin.dart';
import '../admin/views/item_category/item_edit_view_admin.dart';
import '../admin/views/orders/order_list_view_admin.dart';
import '../admin/views/orders/order_create_view_admin.dart';
import '../admin/views/orders/order_edit_view_admin.dart';
import '../admin/views/parking/parking_list_view_admin.dart';
import '../admin/views/parking/parking_create_view_admin.dart';
import '../admin/views/parking/parking_edit_view_admin.dart';
import '../admin/views/tables/table_list_view_admin.dart';
import '../admin/views/tables/table_create_view_admin.dart';
import '../admin/views/tables/table_edit_view_admin.dart';

final GoRouter appRouter = GoRouter(
  
  // ORIGINAL: initialLocation: '/splash',
  initialLocation: '/splash', // TEMPORAL para desarrollo
  routes: [
    
    // ORIGINAL: redirect: (context, state) => '/splash',
    GoRoute(
      path: '/',
      redirect: (context, state) => '/splash', // TEMPORAL para desarrollo
    ),
    
    // Ruta de bienvenida (splash intro)
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashIntroView(),
    ),
    
    // Ruta de autenticación
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    
    // Ruta de registro
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    
    // ========================================
    // RUTAS DE ADMINISTRACIÓN
    // ========================================
    
    // Ruta principal del panel de administración
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminHomeView(),
    ),
    
    // Rutas CRUD para categorías (Admin)
    GoRoute(
      path: '/admin/categories',
      builder: (context, state) => const CategoryListViewAdmin(),
    ),
    GoRoute(
      path: '/admin/categories/create',
      builder: (context, state) => const CategoryCreateViewAdmin(),
    ),
    GoRoute(
      path: '/admin/categories/edit/:id',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return CategoryEditViewAdmin(categoryId: categoryId);
      },
    ),
    
    // Rutas CRUD para items del menú (Admin)
    GoRoute(
      path: '/admin/items',
      builder: (context, state) => const ItemListViewAdmin(),
    ),
    GoRoute(
      path: '/admin/items/create',
      builder: (context, state) => const ItemCreateViewAdmin(),
    ),
    GoRoute(
      path: '/admin/items/edit/:id',
      builder: (context, state) {
        final itemId = state.pathParameters['id']!;
        return ItemEditViewAdmin(itemId: itemId);
      },
    ),
    
    // Rutas CRUD para pedidos (Admin)
    GoRoute(
      path: '/admin/orders',
      builder: (context, state) => const OrderListViewAdmin(),
    ),
    GoRoute(
      path: '/admin/orders/create',
      builder: (context, state) => const OrderCreateViewAdmin(),
    ),
    GoRoute(
      path: '/admin/orders/edit/:id',
      builder: (context, state) {
        final orderId = state.pathParameters['id']!;
        return OrderEditViewAdmin(orderId: orderId);
      },
    ),
    
    // Rutas CRUD para parqueadero (Admin)
    GoRoute(
      path: '/admin/parking',
      builder: (context, state) => const ParkingListViewAdmin(),
    ),
    GoRoute(
      path: '/admin/parking/create',
      builder: (context, state) => const ParkingCreateViewAdmin(),
    ),
    GoRoute(
      path: '/admin/parking/edit/:id',
      builder: (context, state) {
        final parkingId = state.pathParameters['id']!;
        return ParkingEditViewAdmin(parkingId: parkingId);
      },
    ),
    
    // Rutas CRUD para mesas (Admin)
    GoRoute(
      path: '/admin/tables',
      builder: (context, state) => const TableListViewAdmin(),
    ),
    GoRoute(
      path: '/admin/tables/create',
      builder: (context, state) => const TableCreateViewAdmin(),
    ),
    GoRoute(
      path: '/admin/tables/edit/:id',
      builder: (context, state) {
        final tableId = state.pathParameters['id']!;
        return TableEditViewAdmin(tableId: tableId);
      },
    ),
    
    // TODO: Agregar rutas CRUD para administración:
    

    
    // - /admin/bookings (gestión de reservas)
    // - /admin/users (gestión de usuarios)
    // - /admin/audit (auditoría)
    // - /admin/settings (configuración)
    
    // ========================================
    // RUTAS DE CLIENTE
    // ========================================
    
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
    
    // Ruta para perfil de usuario
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),
    
    // Ruta para editar perfil de usuario
    GoRoute(
      path: '/profile/edit/:id',
      builder: (context, state) {
        final userId = int.parse(state.pathParameters['id']!);
        return ProfileEditView(id: userId);
      },
    ),
  ],

);