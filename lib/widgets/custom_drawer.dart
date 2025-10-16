import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Restaurant App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Menú Digital',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Opción: Inicio
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          
          
          // Opción: Menú Completo
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menú Completo'),
            subtitle: const Text('Ver todos los platillos'),
            onTap: () {
              Navigator.pop(context);
              context.go('/menu');
            },
          ),
          
          const Divider(),
          
          // Sección de pruebas/desarrollo
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Desarrollo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Opción: Test API
          ListTile(
            leading: const Icon(Icons.api),
            title: const Text('Test API'),
            subtitle: const Text('Probar conexión'),
            onTap: () {
              Navigator.pop(context);
              // Aquí se puede añadir una ruta de prueba más adelante
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad en desarrollo'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}