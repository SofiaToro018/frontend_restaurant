import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_restaurant/themes/custom_drawer_themes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener la ruta actual para determinar qué opción está activa
    final currentRoute = GoRouterState.of(context).uri.path;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          DrawerHeader(
            decoration: CustomDrawerThemes.headerDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  CustomDrawerThemes.headerIcon,
                  size: CustomDrawerThemes.headerIconSize,
                  color: CustomDrawerThemes.headerIconColor,
                ),
                const SizedBox(height: CustomDrawerThemes.headerSpacing),
                const Text(
                  'Restaurant App',
                  style: CustomDrawerThemes.headerTitleStyle,
                ),
                const Text(
                  'Menú Digital',
                  style: CustomDrawerThemes.headerSubtitleStyle,
                ),
              ],
            ),
          ),
          
          // Opción: Menú
          ListTile(
            leading: Icon(
              Icons.restaurant_menu,
              color: currentRoute == '/menu' ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Menú',
              style: TextStyle(
                color: currentRoute == '/menu' ? Colors.green : Colors.grey[700],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/menu');
            },
          ),

          // Opción: Pedidos
          ListTile(
            leading: Icon(
              Icons.receipt_long,
              color: currentRoute == '/orders' ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Mis Pedidos',
              style: TextStyle(
                color: currentRoute == '/orders' ? Colors.green : Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Ver historial',
              style: TextStyle(
                color: currentRoute == '/orders' ? Colors.green[700] : Colors.grey[600],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/orders');
            },
          ),

          // Opción: Reservas
          ListTile(
            leading: Icon(
              Icons.event_seat,
              color: currentRoute == '/bookings' ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Mis Reservas',
              style: TextStyle(
                color: currentRoute == '/bookings' ? Colors.green : Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Ver reservas',
              style: TextStyle(
                color: currentRoute == '/bookings' ? Colors.green[700] : Colors.grey[600],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/bookings');
            },
          ),

          // Opción: Perfil
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: currentRoute == '/profile' ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Mi Perfil',
              style: TextStyle(
                color: currentRoute == '/profile' ? Colors.green : Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Ver información',
              style: TextStyle(
                color: currentRoute == '/profile' ? Colors.green[700] : Colors.grey[600],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          
          const Divider(),
          
          // Sección de pruebas/desarrollo
          const Padding(
            padding: CustomDrawerThemes.sectionPadding,
            child: Text(
              'Desarrollo',
              style: CustomDrawerThemes.sectionTextStyle,
            ),
          ),
          
          // Opción: Registro de Cambios
          ListTile(
            leading: Icon(
              Icons.history,
              color: currentRoute == '/audit-logs' ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Registro de Cambios',
              style: TextStyle(
                color: currentRoute == '/audit-logs' ? Colors.green : Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Ver audit logs',
              style: TextStyle(
                color: currentRoute == '/audit-logs' ? Colors.green[700] : Colors.grey[600],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/audit-logs');
            },
          ),
          
          // Opción: Test API
          ListTile(
            leading: const Icon(
              Icons.api,
              color: Colors.grey,
            ),
            title: Text(
              'Test API',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Probar conexión',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
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