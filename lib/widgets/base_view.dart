import 'package:flutter/material.dart';

import 'custom_drawer.dart';
import 'custom_bottom_navbar.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBottomNavbar;
  final Widget? floatingActionButton;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.showBottomNavbar = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const CustomDrawer(), // Drawer persistente para todas las vistas
      body: body,
      bottomNavigationBar: showBottomNavbar
          ? const CustomBottomNavbar() // Barra de navegación inferior persistente
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
