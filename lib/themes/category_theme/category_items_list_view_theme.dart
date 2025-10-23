import 'package:flutter/material.dart';

class CategoryItemsListViewTheme {
  // ========== CONFIGURACIÓN GENERAL ==========
  // Configuración del AppBar
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  // Configuración del padding principal
  static const EdgeInsets mainPadding = EdgeInsets.all(16.0);
  
  // ========== HEADER DE CATEGORÍA CENTRADO ==========
  // Configuración del Card de información de categoría
  static const double categoryCardElevation = 6.0;
  static const double categoryCardBorderRadius = 20.0;
  static const EdgeInsets categoryCardPadding = EdgeInsets.all(24.0);
  static const EdgeInsets categoryCardMargin = EdgeInsets.only(bottom: 24.0);
  static const double categoryCardSpacing = 16.0;
  
  // Configuración del icono de categoría
  static const double categoryIconSize = 80.0;
  static const Color categoryIconColor = Color(0xFF2E7D32);
  
  // Estilos de texto del card de categoría (centrados)
  static const TextStyle categoryTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static TextStyle categorySubtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[600],
  );
  
  // ========== GRID DE ITEMS (2 COLUMNAS) ==========
  // Configuración de la grilla
  static const int gridCrossAxisCount = 2;
  static const double gridCrossAxisSpacing = 12.0;
  static const double gridMainAxisSpacing = 12.0;
  static const double gridChildAspectRatio = 0.75; // Ratio ancho/alto para las tarjetas
  
  // Configuración de sección de items
  static const double sectionSpacing = 24.0;
  static const double itemsSectionTitleSpacing = 16.0;
  
  static const TextStyle itemsSectionTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  // ========== TARJETAS DE ITEMS ELEGANTES ==========
  // Configuración de cards de items (nuevas tarjetas elegantes)
  static const double itemCardElevation = 4.0;
  static const double itemCardBorderRadius = 16.0;
  static const EdgeInsets itemCardMargin = EdgeInsets.all(4.0);
  static const EdgeInsets itemCardPadding = EdgeInsets.all(12.0);
  static const Color itemCardBackgroundColor = Colors.white;
  
  // Sombras para las tarjetas
  static List<BoxShadow> itemCardShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
  
  // ========== IMAGEN DE ITEM EN TARJETA ==========
  // Configuración de imagen de item (parte superior de la tarjeta)
  static const double itemImageHeight = 120.0;
  static const double itemImageBorderRadius = 12.0;
  static const double itemImageSpacing = 12.0;
  static Color itemImagePlaceholderColor = Colors.grey[100]!;
  static const Color itemImageIconColor = Color(0xFF81C784);
  static const double itemImageIconSize = 40.0;
  
  // ========== CONTENIDO DE TARJETA ==========
  // Configuración de información de item
  static const double itemInfoSpacing = 6.0;
  static const double itemPriceSpacing = 8.0;
  static const double itemContentSpacing = 4.0;
  
  // Estilos de texto de items
  static const TextStyle itemTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  
  static TextStyle itemTitleDisabledStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
    height: 1.2,
  );
  
  static TextStyle itemDescriptionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
    height: 1.3,
  );
  
  static const TextStyle itemPriceStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF388E3C),
  );
  
  static TextStyle itemPriceDisabledStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
  );
  
  // ========== ESTADO "NO DISPONIBLE" ==========
  // Configuración del Chip "No disponible"
  static Color chipBackgroundColor = Colors.red[50]!;
  static Color chipTextColor = Colors.red[700]!;
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const double chipBorderRadius = 12.0;
  static const TextStyle chipTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  
  // ========== BOTÓN DE AGREGAR ==========
  // Configuración del botón de agregar
  static const EdgeInsets addButtonPadding = EdgeInsets.all(6);
  static const double addButtonBorderRadius = 8.0;
  static const Color addButtonBackgroundColor = Color(0xFFE8F5E8);
  static const Color addButtonIconColor = Color(0xFF2E7D32);
  static const double addButtonIconSize = 16.0;
  
  // ========== VISTA VACÍA ==========
  // Configuración de vista vacía
  static const double emptyViewIconSize = 64.0;
  static Color emptyViewIconColor = Colors.grey[400]!;
  static Color emptyViewTextColor = Colors.grey[600]!;
  static const double emptyViewSpacing = 16.0;
  static const EdgeInsets emptyViewPadding = EdgeInsets.all(32.0);
  
  static TextStyle emptyViewTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[600],
  );
  
  // ========== VISTA DE ERROR ==========
  // Configuración de vista de error
  static TextStyle errorTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.red[600],
  );
  
  // ========== DECORACIONES ==========
  // Decoración del card de categoría (header)
  static BoxDecoration get categoryCardDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(categoryCardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }
  
  // Decoración de las tarjetas de items
  static BoxDecoration get itemCardDecoration {
    return BoxDecoration(
      color: itemCardBackgroundColor,
      borderRadius: BorderRadius.circular(itemCardBorderRadius),
      boxShadow: itemCardShadows,
      border: Border.all(
        color: Colors.grey.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }
  
  // Decoración de la imagen del item
  static BoxDecoration get itemImageDecoration {
    return BoxDecoration(
      color: itemImagePlaceholderColor,
      borderRadius: BorderRadius.circular(itemImageBorderRadius),
    );
  }
  
  // Decoración del chip "No disponible"
  static BoxDecoration get chipDecoration {
    return BoxDecoration(
      color: chipBackgroundColor,
      borderRadius: BorderRadius.circular(chipBorderRadius),
      border: Border.all(color: Colors.red[200]!),
    );
  }
  
  // Decoración del botón de agregar
  static BoxDecoration get addButtonDecoration {
    return BoxDecoration(
      color: addButtonBackgroundColor,
      borderRadius: BorderRadius.circular(addButtonBorderRadius),
    );
  }
  
  // ========== FORMAS (SHAPES) ==========
  static RoundedRectangleBorder get categoryCardShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(categoryCardBorderRadius),
    );
  }
  
  static RoundedRectangleBorder get itemCardShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(itemCardBorderRadius),
    );
  }
}