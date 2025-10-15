import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../views/category/category_list_view.dart';
import '../widgets/custom_drawer.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal - Home/Inicio
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    
    // Ruta para lista de categorías
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoryListView(),
    ),
    
    // Ruta para detalle de categoría (para implementar más adelante)
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return CategoryDetailView(categoryId: categoryId);
      },
    ),
  ],
);

// Vista temporal de Home hasta que la implementemos
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenido al Restaurant App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Usa el menú lateral para navegar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista temporal de detalle de categoría
class CategoryDetailView extends StatelessWidget {
  final String categoryId;
  
  const CategoryDetailView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoría $categoryId'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              'Detalle de Categoría #$categoryId',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Vista en desarrollo...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}