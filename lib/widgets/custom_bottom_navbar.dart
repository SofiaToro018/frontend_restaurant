import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener la ruta actual para determinar qué opción está activa
    final currentRoute = GoRouterState.of(context).uri.path;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Opción: Menú
          Expanded(
            child: InkWell(
              onTap: () {
                context.go('/menu');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: currentRoute == '/menu' ? Colors.orange : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Menú',
                      style: TextStyle(
                        color: currentRoute == '/menu' ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Opción: Reservas
          Expanded(
            child: InkWell(
              onTap: () {
                context.go('/bookings');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_seat,
                      color: currentRoute == '/bookings' ? Colors.orange : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reservas',
                      style: TextStyle(
                        color: currentRoute == '/bookings' ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Opción: Perfil
          Expanded(
            child: InkWell(
              onTap: () {
                context.go('/profile');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: currentRoute == '/profile' ? Colors.orange : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Perfil',
                      style: TextStyle(
                        color: currentRoute == '/profile' ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
