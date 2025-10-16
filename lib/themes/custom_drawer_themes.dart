import 'package:flutter/material.dart';

class CustomDrawerThemes {
  // Colores del header del drawer
  static const List<Color> headerGradientColors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
  ];
  
  static const Alignment headerGradientBegin = Alignment.topLeft;
  static const Alignment headerGradientEnd = Alignment.bottomRight;
  
  // Colores del header
  static const Color headerIconColor = Color.fromARGB(255, 0, 0, 0);
  static const Color headerTitleColor = Color.fromARGB(255, 0, 0, 0);
  static const Color headerSubtitleColor = Color.fromARGB(179, 0, 0, 0);
  
  // Estilos de texto del header
  static const TextStyle headerTitleStyle = TextStyle(
    color: Color.fromARGB(255, 4, 4, 4),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headerSubtitleStyle = TextStyle(
    color: headerSubtitleColor,
    fontSize: 16,
  );
  
  // Configuración del icono principal
  static const IconData headerIcon = Icons.restaurant;
  static const double headerIconSize = 48.0;
  
  // Estilos para los ListTile del menú
  static const Color listTileIconColor = Colors.black54;
  static const Color listTileTitleColor = Colors.black87;
  static const Color listTileSubtitleColor = Colors.black54;
  
  // Estilo para el texto de sección
  static const TextStyle sectionTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );
  
  // Padding y espaciado
  static const EdgeInsets sectionPadding = EdgeInsets.all(16.0);
  static const double headerSpacing = 8.0;
  
  // Decoración del header
  static BoxDecoration get headerDecoration {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: headerGradientColors,
        begin: headerGradientBegin,
        end: headerGradientEnd,
      ),
    );
  }
  
  // Tema para los iconos de los ListTile
  static IconThemeData get listTileIconTheme {
    return const IconThemeData(
      color: listTileIconColor,
    );
  }
  
  // Tema para los textos de los ListTile
  static TextStyle get listTileTitleStyle {
    return const TextStyle(
      color: listTileTitleColor,
      fontWeight: FontWeight.w500,
    );
  }
  
  static TextStyle get listTileSubtitleStyle {
    return const TextStyle(
      color: listTileSubtitleColor,
    );
  }
}