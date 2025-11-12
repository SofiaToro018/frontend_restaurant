import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/services/auth_service.dart';

class CustomDrawerAdmin extends StatelessWidget {
  const CustomDrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUsuario;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header del drawer con información del admin
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2E7D32), // Verde acento
                    const Color(0xFF388E3C), // Verde highlight
                  ],
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUser?.initials ?? 'A',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // Verde acento
                  ),
                ),
              ),
              accountName: Text(
                currentUser?.formattedName ?? 'Administrador',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                currentUser?.emailUsuario ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ),

            // Sección: Dashboard
            _buildSectionTitle('PANEL DE CONTROL'),
            _buildDrawerItem(
              context: context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              route: '/admin',
            ),

            const Divider(),

            // Sección: Configuración
            _buildSectionTitle('CONFIGURACIÓN'),
            _buildDrawerItem(
              context: context,
              icon: Icons.settings,
              title: 'Configuración',
              route: '/admin/settings',
            ),

            const Divider(),

            // Opción de cerrar sesión
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF2E7D32)), // Verde
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Color(0xFF2E7D32)), // Verde
              ),
              onTap: () async {
                // Mostrar confirmación
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32), // Verde
                        ),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true && context.mounted) {
                  await authService.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
            ),

            // Versión de la app (opcional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Versión 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = GoRouterState.of(context).uri.path == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade700, // Verde acento
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.black87, // Verde acento
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0x1A2E7D32), // Verde con 10% opacity
      onTap: () {
        Navigator.pop(context); // Cerrar el drawer
        context.go(route);
      },
    );
  }
}
