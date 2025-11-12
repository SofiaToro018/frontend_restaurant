import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/services/auth_service.dart';
import '../widgets/base_view_admin.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUsuario;

    return BaseViewAdmin(
      title: 'Panel de Administración',
      body: Container(
        color: const Color(0xFFF5F5F5), // Fondo gris claro elegante
        child: CustomScrollView(
          slivers: [
            // Banner de bienvenida estilo menu
            SliverToBoxAdapter(
              child: _buildWelcomeBanner(currentUser?.formattedName ?? 'Administrador'),
            ),
            
            // Contenido principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Título de acciones
                    const Text(
                      'Gestión del Sistema',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildQuickActionsGrid(context),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(String userName) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000), // Black with 0.05 opacity - sombra muy sutil
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'assets/images/encabezado.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si no se encuentra la imagen
                  return Container(
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
                  );
                },
              ),
            ),
            // Overlay semitransparente para desvanecer la imagen
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x66000000), // Negro con 0.4 opacity para desvanecer
                ),
              ),
            ),
            
            // Contenido principal del banner
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Panel de Control',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xE6FFFFFF), // White with 0.9 opacity
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x1A000000), // Black with 0.1 opacity
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Administrador • Sistema • Gestión',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          context: context,
          icon: Icons.restaurant_menu,
          title: 'Gestionar\nCategorías',
          color: Colors.blue,
          route: '/admin/categories',
        ),
        _buildActionCard(
          context: context,
          icon: Icons.fastfood,
          title: 'Gestionar\nItems',
          color: Colors.green,
          route: '/admin/items',
        ),
        _buildActionCard(
          context: context,
          icon: Icons.receipt_long,
          title: 'Gestionar\nPedidos',
          color: Colors.orange,
          route: '/admin/orders',
        ),
        _buildActionCard(
          context: context,
          icon: Icons.people,
          title: 'Gestionar\nUsuarios',
          color: Colors.purple,
          route: '/admin/users',
        ),
        _buildActionCard(
          context: context,
          icon: Icons.local_parking,
          title: 'Gestionar\nParqueadero',
          color: Colors.teal,
          route: '/admin/parking',
        ),
        _buildActionCard(
          context: context,
          icon: Icons.table_restaurant,
          title: 'Gestionar\nMesas',
          color: Colors.indigo,
          route: '/admin/tables',
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required String route,
  }) {
    // Definir colores base para cada color
    Color iconColor;
    Color bgColor;
    
    if (color == Colors.blue) {
      iconColor = const Color(0xFF2196F3);
      bgColor = const Color(0x1A2196F3); // Blue with 10% opacity
    } else if (color == Colors.green) {
      iconColor = const Color(0xFF4CAF50);
      bgColor = const Color(0x1A4CAF50);
    } else if (color == Colors.orange) {
      iconColor = const Color(0xFFFF9800);
      bgColor = const Color(0x1AFF9800);
    } else if (color == Colors.purple) {
      iconColor = const Color(0xFF9C27B0);
      bgColor = const Color(0x1A9C27B0);
    } else if (color == Colors.teal) {
      iconColor = const Color(0xFF009688);
      bgColor = const Color(0x1A009688);
    } else if (color == Colors.indigo) {
      iconColor = const Color(0xFF3F51B5);
      bgColor = const Color(0x1A3F51B5);
    } else {
      iconColor = const Color(0xFF757575);
      bgColor = const Color(0x1A757575);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20), // Bordes más redondeados como en /menu
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navegar a la ruta correspondiente
          if (route == '/admin/categories') {
            context.push(route);
          } else {
            // Para las rutas que aún no están implementadas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Función "$title" en desarrollo'),
                backgroundColor: iconColor,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0D000000), // Sombra muy sutil como en /menu
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A), // Color de texto principal como en /menu
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
