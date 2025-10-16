import 'package:go_router/go_router.dart';
import '../views/home/home_view.dart';
import '../views/category/category_list_view.dart';
import '../views/category/category_items_list_view.dart';
import '../views/category/item_detail_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal - Home/Inicio
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    
    // Ruta para menú completo (categorías con todos sus items)
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
  ],

);