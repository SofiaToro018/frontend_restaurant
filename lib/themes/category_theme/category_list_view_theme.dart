import 'package:flutter/material.dart';

class CategoryListViewTheme {
  // ========== CONFIGURACIÓN GENERAL ==========
  // Fondo de la aplicación
  static Color backgroundColor = Colors.grey[50]!;
  
  // Padding principal del contenido
  static const EdgeInsets mainContentPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const double mainContentTopSpacing = 20.0;
  
  // ========== BANNER SUPERIOR ==========
  // Configuración del banner
  static const double bannerHeight = 200.0;
  static const EdgeInsets bannerMargin = EdgeInsets.all(16.0);
  static const double bannerBorderRadius = 20.0;
  
  // Gradiente del banner
  static List<Color> bannerGradientColors = [
    Colors.orange[100]!,
    Colors.orange[50]!,
  ];
  static const Alignment bannerGradientBegin = Alignment.topCenter;
  static const Alignment bannerGradientEnd = Alignment.bottomCenter;
  
  // Sombra del banner
  static List<BoxShadow> bannerShadow = [
    BoxShadow(
      color: Colors.orange.withValues(alpha: 0.2),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Icono decorativo del banner
  static const double bannerDecorationIconSize = 150.0;
  static const double bannerDecorationIconOpacity = 0.1;
  static const double bannerDecorationIconRight = -20.0;
  static const double bannerDecorationIconTop = 20.0;
  static Color bannerDecorationIconColor = Colors.orange[800]!;
  
  // Posicionamiento del contenido del banner
  static const double bannerContentLeft = 24.0;
  static const double bannerContentRight = 24.0;
  static const double bannerContentBottom = 30.0;
  
  // Estilos de texto del banner
  static const String bannerFontFamily = 'Georgia';
  
  static TextStyle bannerSubtitleStyle = TextStyle(
    fontFamily: bannerFontFamily,
    fontSize: 16,
    color: Colors.orange[800],
    fontWeight: FontWeight.w300,
  );
  
  static TextStyle bannerTitleStyle = TextStyle(
    fontFamily: bannerFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.orange[900],
    fontStyle: FontStyle.italic,
    letterSpacing: 1.2,
  );
  
  // Configuración del contenedor del descripción del banner
  static const EdgeInsets bannerDescriptionPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const double bannerDescriptionBorderRadius = 20.0;
  static Color bannerDescriptionBackgroundColor = Colors.white.withValues(alpha: 0.9);
  static List<BoxShadow> bannerDescriptionShadow = [
    BoxShadow(
      color: Colors.orange.withValues(alpha: 0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static TextStyle bannerDescriptionStyle = TextStyle(
    fontSize: 13,
    color: Colors.grey[700],
    fontWeight: FontWeight.w500,
  );
  
  // Espaciado interno del banner
  static const double bannerInternalSpacing1 = 8.0;
  static const double bannerInternalSpacing2 = 12.0;
  
  // ========== SECCIONES DE CATEGORÍAS ==========
  // Espaciado entre secciones
  static const double categorySectionBottomMargin = 32.0;
  static const double categoryTitleBottomMargin = 20.0;
  
  // Estilos del título de categoría
  static const TextStyle categoryTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: 0.5,
  );
  
  // Configuración del botón "Ver todo"
  static const EdgeInsets viewAllButtonPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const double viewAllButtonBorderRadius = 16.0;
  static Color viewAllButtonBackgroundColor = Colors.orange[50]!;
  static Color viewAllButtonBorderColor = Colors.orange[200]!;
  static const double viewAllButtonSpacing = 4.0;
  
  static TextStyle viewAllButtonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.orange[700],
  );
  
  static Color viewAllButtonIconColor = Colors.orange[700]!;
  static const double viewAllButtonIconSize = 16.0;
  
  // ========== TARJETAS DE ITEMS ==========
  // Configuración general de las tarjetas
  static const double newMenuItemHeight = 280.0;
  static const double newMenuItemWidth = 200.0;
  static const double cardHorizontalWidth = 200.0; // Alias para compatibilidad
  static const EdgeInsets newMenuItemMargin = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets cardHorizontalMargin = EdgeInsets.symmetric(horizontal: 8); // Alias para compatibilidad
  static const double newMenuItemBorderRadius = 20.0;
  static const double cardBorderRadius = 20.0; // Alias para compatibilidad
  static const Color newMenuItemBackgroundColor = Colors.white;
  
  // Configuración de tarjetas adicionales
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardCategoryPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
  static const EdgeInsets cardButtonPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const EdgeInsets cardImageMargin = EdgeInsets.only(left: 12.0);
  static const EdgeInsets cardUnavailablePadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
  static const EdgeInsets cardUnavailableMargin = EdgeInsets.only(bottom: 8.0);
  static const double cardImageWidth = 80.0;
  static const double cardElementSpacing = 8.0;
  static const double cardButtonIconSize = 16.0;
  static const double cardButtonSpacing = 4.0;
  static const double cardButtonSmallIconSize = 20.0;
  static const double loadingStrokeWidth = 2.0;
  
  // Sombras de las nuevas tarjetas
  static List<BoxShadow> newMenuItemShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  // Configuración de la imagen de las tarjetas
  static const double newMenuItemImageHeight = 140.0;
  static const double cardImageHeight = 140.0; // Alias para compatibilidad
  static Color newMenuItemImageBackgroundColor = Colors.grey[100]!;
  static Color cardImageBackgroundColor = Colors.grey[100]!; // Alias para compatibilidad
  static const Color loadingColor = Colors.orange;
  
  // Padding del contenido de las tarjetas
  static const EdgeInsets newMenuItemContentPadding = EdgeInsets.all(16);
  static const EdgeInsets cardButtonSmallPadding = EdgeInsets.all(8);
  
  // Configuración del estado "No disponible" en tarjetas
  static const EdgeInsets newNotAvailablePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const EdgeInsets newNotAvailableMargin = EdgeInsets.only(bottom: 8);
  static const double newNotAvailableBorderRadius = 12.0;
  static Color newNotAvailableBackgroundColor = Colors.red[50]!;
  static Color newNotAvailableBorderColor = Colors.red[200]!;
  
  static TextStyle newNotAvailableTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.red[700],
  );
  
  static TextStyle cardUnavailableTextStyle = TextStyle( // Alias para compatibilidad
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.red[700],
  );
  
  // Estilos de texto de las nuevas tarjetas
  static const TextStyle newMenuItemTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  
  static const TextStyle cardTitleStyle = TextStyle( // Alias para compatibilidad
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  
  static TextStyle newMenuItemTitleDisabledStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
    height: 1.2,
  );
  
  static TextStyle cardTitleDisabledStyle = TextStyle( // Alias para compatibilidad
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
    height: 1.2,
  );
  
  static TextStyle newMenuItemDescriptionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    height: 1.3,
  );
  
  static TextStyle cardDescriptionStyle = TextStyle( // Alias para compatibilidad
    fontSize: 14,
    color: Colors.grey[600],
    height: 1.3,
  );
  
  static TextStyle newMenuItemPriceStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.orange[700],
  );
  
  static TextStyle cardPriceStyle = TextStyle( // Alias para compatibilidad
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.orange[700],
  );
  
  static TextStyle newMenuItemPriceDisabledStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
  );
  
  static TextStyle cardPriceDisabledStyle = TextStyle( // Alias para compatibilidad
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
  );
  
  // Estilos de categoría en tarjetas
  static TextStyle cardCategoryStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.orange[700],
    letterSpacing: 0.5,
  );
  
  // Estilos de botones en tarjetas
  static const TextStyle cardButtonTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Configuración del botón de agregar en tarjetas
  static const EdgeInsets addButtonPadding = EdgeInsets.all(8);
  static const double addButtonBorderRadius = 12.0;
  static Color addButtonBackgroundColor = Colors.orange[50]!;
  static Color addButtonIconColor = Colors.orange[700]!;
  static const double addButtonIconSize = 20.0;
  
  // Colores de iconos en tarjetas
  static const Color cardButtonIconColor = Colors.white;
  static Color cardPlaceholderIconColor = Colors.orange[300]!;
  
  // Espaciado interno de las tarjetas
  static const double cardInternalSpacing = 8.0;
  
  // ========== PLACEHOLDER DE IMAGEN ==========
  static Color placeholderImageBackgroundColor = Colors.grey[100]!;
  static Color placeholderImageIconColor = Colors.grey[400]!;
  static const double placeholderImageIconSize = 48.0;
  static const double placeholderImageSpacing = 8.0;
  
  static TextStyle placeholderImageTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey[500],
  );
  
  // ========== CATEGORÍA VACÍA ==========
  static const double emptyCategoryHeight = 200.0;
  static const EdgeInsets emptyCategoryMargin = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets emptyCategoryPadding = EdgeInsets.all(32);
  static const double emptyCategoryBorderRadius = 16.0;
  static Color emptyCategoryBackgroundColor = Colors.grey[50]!;
  static Color emptyCategoryBorderColor = Colors.grey[200]!;
  
  static Color emptyCategoryIconColor = Colors.grey[400]!;
  static const double emptyCategoryIconSize = 48.0;
  static const double emptyCategorySpacing = 12.0;
  
  static TextStyle emptyCategoryTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[600],
    fontWeight: FontWeight.w500,
  );
  
  // ========== SCROLL HORIZONTAL ==========
  static const EdgeInsets horizontalScrollPadding = EdgeInsets.symmetric(horizontal: 4);
  
  // ========== CONFIGURACIÓN DE VISTA VACÍA GENERAL ==========
  static const double emptyViewIconSize = 64.0;
  static Color emptyViewIconColor = Colors.grey[400]!;
  static Color emptyViewTextColor = Colors.grey[600]!;
  static const double emptyViewSpacing = 16.0;
  
  static const TextStyle emptyViewTitleStyle = TextStyle(
    fontSize: 18,
  );
  
  // ========== CONFIGURACIÓN DE ERROR VIEW ==========
  static Color errorIconColor = Colors.red[300]!;
  static Color errorTitleColor = Colors.red[600]!;
  static Color errorDescriptionColor = Colors.red[500]!;
  
  static TextStyle errorTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: errorTitleColor,
  );
  
  static TextStyle errorDescriptionStyle = TextStyle(
    fontSize: 14,
    color: errorDescriptionColor,
  );
  
  // ========== DECORACIONES ==========
  // Decoración del banner
  static BoxDecoration get bannerDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: bannerGradientBegin,
        end: bannerGradientEnd,
        colors: bannerGradientColors,
      ),
      borderRadius: BorderRadius.circular(bannerBorderRadius),
      boxShadow: bannerShadow,
    );
  }
  
  // Decoración del contenedor de descripción del banner
  static BoxDecoration get bannerDescriptionDecoration {
    return BoxDecoration(
      color: bannerDescriptionBackgroundColor,
      borderRadius: BorderRadius.circular(bannerDescriptionBorderRadius),
      boxShadow: bannerDescriptionShadow,
    );
  }
  
  // Decoración del botón "Ver todo"
  static BoxDecoration get viewAllButtonDecoration {
    return BoxDecoration(
      color: viewAllButtonBackgroundColor,
      borderRadius: BorderRadius.circular(viewAllButtonBorderRadius),
      border: Border.all(color: viewAllButtonBorderColor),
    );
  }
  
  // Decoración de las nuevas tarjetas de items
  static BoxDecoration get newMenuItemDecoration {
    return BoxDecoration(
      color: newMenuItemBackgroundColor,
      borderRadius: BorderRadius.circular(newMenuItemBorderRadius),
      boxShadow: newMenuItemShadow,
    );
  }
  
  // Métodos de decoración para compatibilidad
  static BoxDecoration buildCardDecoration() {
    return BoxDecoration(
      color: newMenuItemBackgroundColor,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      boxShadow: newMenuItemShadow,
    );
  }
  
  static BoxDecoration buildCardImageDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange.withValues(alpha: 0.02),
          Colors.white,
        ],
      ),
    );
  }
  
  static BoxDecoration buildCardCategoryDecoration() {
    return BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.orange.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration buildCardButtonDecoration() {
    return BoxDecoration(
      color: Colors.orange[600],
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration buildCardButtonSmallDecoration() {
    return BoxDecoration(
      color: addButtonBackgroundColor,
      borderRadius: BorderRadius.circular(addButtonBorderRadius),
    );
  }
  
  static BoxDecoration buildCardPlaceholderDecoration() {
    return BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.orange.withValues(alpha: 0.2),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration buildCardUnavailableDecoration() {
    return BoxDecoration(
      color: newNotAvailableBackgroundColor,
      borderRadius: BorderRadius.circular(newNotAvailableBorderRadius),
      border: Border.all(color: newNotAvailableBorderColor),
    );
  }
  
  // Decoración del estado "No disponible" en nuevas tarjetas
  static BoxDecoration get newNotAvailableDecoration {
    return BoxDecoration(
      color: newNotAvailableBackgroundColor,
      borderRadius: BorderRadius.circular(newNotAvailableBorderRadius),
      border: Border.all(color: newNotAvailableBorderColor),
    );
  }
  
  // Decoración del botón de agregar
  static BoxDecoration get addButtonDecoration {
    return BoxDecoration(
      color: addButtonBackgroundColor,
      borderRadius: BorderRadius.circular(addButtonBorderRadius),
    );
  }
  
  // Decoración de categoría vacía
  static BoxDecoration get emptyCategoryDecoration {
    return BoxDecoration(
      color: emptyCategoryBackgroundColor,
      borderRadius: BorderRadius.circular(emptyCategoryBorderRadius),
      border: Border.all(color: emptyCategoryBorderColor),
    );
  }
  
  // ========== CONFIGURACIÓN LEGACY (Para compatibilidad) ==========
  // Mantengo algunos valores legacy para evitar errores en otras partes
  static List<Color> categoryHeaderGradientColors = [
    Colors.orange.shade400,
    Colors.deepOrange.shade500,
  ];
  
  static const double menuItemHeight = 220.0;
  static const EdgeInsets listViewPadding = EdgeInsets.all(16.0);
  static const double categorySectionSpacing = 24.0;
}