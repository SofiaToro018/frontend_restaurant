import 'package:flutter/material.dart';
import 'custom_drawer_admin.dart';

class BaseViewAdmin extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const BaseViewAdmin({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Verde acento
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: actions,
      ),
      drawer: const CustomDrawerAdmin(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
