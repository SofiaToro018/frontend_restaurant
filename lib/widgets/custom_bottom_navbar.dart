import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  int _hoveredIndex = -1;

  void _onItemTapped(int index, BuildContext context) {
    widget.onTap(index);
    switch (index) {
      case 0:
        context.go('/menu');
        break;
      case 1:
        context.go('/reservas');
        break;
      case 2:
        context.go('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final surface = colorScheme.surface;
    final iconInactive = Colors.grey[700];

    final items = [
      {'icon': Icons.home_outlined, 'active': Icons.home, 'label': 'Inicio'},
      {
        'icon': Icons.calendar_month_outlined,
        'active': Icons.calendar_month,
        'label': 'Reservas',
      },
      {'icon': Icons.person_outline, 'active': Icons.person, 'label': 'Perfil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = widget.currentIndex == index;
          final isHovered = _hoveredIndex == index;

          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            child: GestureDetector(
              onTap: () => _onItemTapped(index, context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? primary
                      : isHovered
                      ? primary.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isActive || isHovered ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isActive
                            ? item['active'] as IconData
                            : item['icon'] as IconData,
                        color: isActive ? onPrimary : iconInactive,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: isActive
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                item['label'] as String,
                                style: TextStyle(
                                  color: onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
