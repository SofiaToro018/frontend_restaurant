import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_restaurant/themes/custom_drawer_themes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Opción: Perfil
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Mi Perfil'),
            subtitle: const Text('Ver información'),
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