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
          
          // Opción: Menú
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menú'),
            onTap: () {
              Navigator.pop(context);
              context.go('/menu');
            },
          ),

          // Opción: Pedidos
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Mis Pedidos'),
            subtitle: const Text('Ver historial'),
            onTap: () {
              Navigator.pop(context);
              context.go('/orders');
            },
          ),

          // Opción: Reservas
          ListTile(
            leading: const Icon(Icons.event_seat),
            title: const Text('Mis Reservas'),
            subtitle: const Text('Ver reservas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/bookings');
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
          
          // Opción: Registro de Cambios
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Registro de Cambios'),
            subtitle: const Text('Ver audit logs'),
            onTap: () {
              Navigator.pop(context);
              context.go('/audit-logs');
            },
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