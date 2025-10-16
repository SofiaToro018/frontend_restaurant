import 'package:flutter/material.dart';

import 'custom_drawer.dart';
import 'custom_bottom_navbar.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final int? currentIndex;
  final Function(int)? onTap;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const CustomDrawer(), // Drawer persistente para todas las vistas
      body: body,
      bottomNavigationBar: currentIndex != null && onTap != null
          ? CustomBottomNavbar(
              currentIndex: currentIndex!,
              onTap: onTap!,
            ) // Barra de navegación inferior persistente
          : null,
    );
  }
}
