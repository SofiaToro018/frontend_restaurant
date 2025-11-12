import 'package:flutter/material.dart';

class ItemDetailViewTheme {
  // ========== PALETA DE COLORES CONSISTENTE ==========
  static const Color primaryOrange = Color(0xFF2E7D32); // Verde medio
  static const Color primaryOrangeLight = Color(0xFFE8F5E8); // Verde muy claro
  static const Color primaryOrangeDark = Color(0xFF1B5E20); // Verde oscuro
  static const Color primaryOrangeShade50 = Color(0xFFF1F8E9);
  static const Color primaryOrangeShade100 = Color(0xFFE8F5E8);
  static const Color primaryOrangeShade600 = Color(0xFF2E7D32);
  static const Color primaryOrangeShade700 = Color(0xFF1B5E20);
  static const Color primaryOrangeShade800 = Color(0xFF2E7D32);
  static const Color primaryOrangeShade900 = Color(0xFF1B5E20);
  
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFFA0AEC0);
  
  // ========== SLIVER APP BAR CON IMAGEN ==========
  static const double appBarExpandedHeight = 300.0;
  static const Color appBarBackgroundColor = primaryOrange;
  
  // Gradiente elegante sobre la imagen
  static List<Color> imageGradientColors = [
    Colors.transparent,
    Colors.black.withValues(alpha: 0.2),
    Colors.black.withValues(alpha: 0.6),
  ];
  static const Alignment imageGradientBegin = Alignment.topCenter;
  static const Alignment imageGradientEnd = Alignment.bottomCenter;
  
  // ========== INDICADOR "NO DISPONIBLE" ELEGANTE ==========
  static const Color notAvailableBackgroundColor = Color(0xFFDC2626);
  static const Color notAvailableTextColor = Colors.white;
  static const EdgeInsets notAvailablePadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const double notAvailableBorderRadius = 20.0;
  static const double notAvailableTop = 100.0;
  static const double notAvailableRight = 20.0;
  
  static const TextStyle notAvailableTextStyle = TextStyle(
    color: notAvailableTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    letterSpacing: 0.5,
  );
  
  // ========== CONTENIDO PRINCIPAL ==========
  static const EdgeInsets mainPadding = EdgeInsets.all(20.0);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  
  // ========== HEADER CON NOMBRE Y PRECIO ==========
  static const double itemNameSpacing = 28.0;
  static const double priceContainerBorderRadius = 16.0;
  static const EdgeInsets priceContainerPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0);
  
  // Estilos de texto del header
  static const TextStyle itemNameStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static TextStyle itemNameDisabledStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
    height: 1.2,
  );
  
  static const TextStyle priceStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static TextStyle priceDisabledStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.grey[600],
  );
  
  // Colores del contenedor del precio (ahora elegante)
  static const Color priceBackgroundColor = primaryOrangeShade700;
  static Color priceDisabledBackgroundColor = Colors.grey[300]!;
  
  // ========== SECCIÓN DE DESCRIPCIÓN ELEGANTE ==========
  static const double descriptionSpacing = 16.0;
  static const double descriptionBorderRadius = 16.0;
  static const EdgeInsets descriptionPadding = EdgeInsets.all(20.0);
  
  static const TextStyle descriptionTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle descriptionTextStyle = TextStyle(
    fontSize: 16,
    color: textSecondary,
    height: 1.6,
  );
  
  static TextStyle descriptionPlaceholderStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[500],
    fontStyle: FontStyle.italic,
  );
  
  // Colores del contenedor de descripción (elegante)
  static const Color descriptionBackgroundColor = Colors.white;
  static Color descriptionBorderColor = Colors.grey.withValues(alpha: 0.1);
  
  // ========== CARD DE INFORMACIÓN ELEGANTE ==========
  static const double infoCardBorderRadius = 20.0;
  static const EdgeInsets infoCardPadding = EdgeInsets.all(24.0);
  static const double infoCardSpacing = 32.0;
  static const double infoCardTitleSpacing = 20.0;
  static const double infoRowSpacing = 12.0;
  
  // Colores del card de información (paleta orange elegante)
  static const Color infoCardBackgroundColor = Colors.white;
  static Color infoCardBorderColor = primaryOrange.withValues(alpha: 0.1);
  static const Color infoCardIconColor = primaryOrangeShade700;
  static const Color infoCardTitleColor = primaryOrangeShade800;
  static const Color infoCardRowIconColor = primaryOrangeShade600;
  static const Color infoCardLabelColor = textSecondary;
  static const Color infoCardValueColor = textPrimary;
  
  // Estilos de texto del card de información
  static const TextStyle infoCardTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: infoCardTitleColor,
  );
  
  static const TextStyle infoRowLabelStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: infoCardLabelColor,
  );
  
  static const TextStyle infoRowValueStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: infoCardValueColor,
  );
  
  // ========== BOTONES DE ACCIÓN ELEGANTES ==========
  static const double actionButtonHeight = 60.0;
  static const double secondaryButtonHeight = 52.0;
  static const double buttonSpacing = 16.0;
  static const double buttonBorderRadius = 16.0;
  static const double buttonIconSize = 24.0;
  static const double secondaryButtonIconSize = 20.0;
  static const double buttonTextSpacing = 12.0;
  static const double secondaryButtonTextSpacing = 8.0;
  
  // Colores de botones (paleta orange consistente)
  static const Color primaryButtonColor = primaryOrangeShade600;
  static Color primaryButtonDisabledColor = Colors.grey[300]!;
  static const Color primaryButtonTextColor = Colors.white;
  static Color secondaryButtonBorderColor = primaryOrange.withValues(alpha: 0.3);
  static const Color secondaryButtonIconColor = primaryOrangeShade600;
  static const Color secondaryButtonTextColor = primaryOrangeShade700;
  static const Color secondaryButtonBackgroundColor = primaryOrangeShade50;
  
  // Estilos de texto de botones
  static const TextStyle primaryButtonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryButtonTextColor,
  );
  
  static const TextStyle secondaryButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: secondaryButtonTextColor,
  );
  
  // ========== PLACEHOLDER DE IMAGEN ==========
  static Color placeholderBackgroundColor = primaryOrangeShade100;
  static Color placeholderIconColor = primaryOrangeShade600;
  static const Color placeholderTextColor = primaryOrangeShade700;
  static const double placeholderIconSize = 80.0;
  static const double placeholderSpacing = 16.0;
  
  static const TextStyle placeholderTextStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: placeholderTextColor,
  );
  
  // ========== VISTAS DE ERROR ==========
  static const Color errorAppBarColor = Color(0xFFDC2626);
  static const Color errorAppBarTextColor = Colors.white;
  static const EdgeInsets errorPadding = EdgeInsets.all(32.0);
  static const double errorIconSize = 100.0;
  static const double errorSpacing = 24.0;
  static const double errorDescriptionSpacing = 16.0;
  static const double errorButtonSpacing = 32.0;
  static const double errorButtonRowSpacing = 16.0;
  
  // Colores de error
  static Color errorIconColor = Colors.red[300]!;
  static Color errorTitleColor = Colors.red[600]!;
  static Color errorDescriptionColor = Colors.grey[600]!;
  
  // Estilos de texto de error
  static TextStyle errorTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: errorTitleColor,
  );
  
  static TextStyle errorDescriptionStyle = TextStyle(
    fontSize: 16,
    color: errorDescriptionColor,
  );
  
  // ========== DECORACIONES ELEGANTES ==========
  static BoxDecoration get imageGradientDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: imageGradientBegin,
        end: imageGradientEnd,
        colors: imageGradientColors,
      ),
    );
  }
  
  static BoxDecoration get notAvailableDecoration {
    return BoxDecoration(
      color: notAvailableBackgroundColor,
      borderRadius: BorderRadius.circular(notAvailableBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration priceContainerDecoration(bool isAvailable) {
    return BoxDecoration(
      color: isAvailable ? priceBackgroundColor : priceDisabledBackgroundColor,
      borderRadius: BorderRadius.circular(priceContainerBorderRadius),
      boxShadow: isAvailable ? [
        BoxShadow(
          color: primaryOrange.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ] : [],
    );
  }
  
  static BoxDecoration get descriptionDecoration {
    return BoxDecoration(
      color: descriptionBackgroundColor,
      borderRadius: BorderRadius.circular(descriptionBorderRadius),
      border: Border.all(color: descriptionBorderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration get infoCardDecoration {
    return BoxDecoration(
      color: infoCardBackgroundColor,
      borderRadius: BorderRadius.circular(infoCardBorderRadius),
      border: Border.all(color: infoCardBorderColor),
      boxShadow: [
        BoxShadow(
          color: primaryOrange.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  // ========== ESTILOS DE BOTONES ==========
  static ButtonStyle primaryButtonStyle(bool isAvailable) {
    return ElevatedButton.styleFrom(
      backgroundColor: isAvailable ? primaryButtonColor : primaryButtonDisabledColor,
      foregroundColor: primaryButtonTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      elevation: isAvailable ? 6 : 0,
      shadowColor: isAvailable ? primaryOrange.withValues(alpha: 0.3) : Colors.transparent,
    );
  }
  
  static ButtonStyle get secondaryButtonStyle {
    return OutlinedButton.styleFrom(
      backgroundColor: secondaryButtonBackgroundColor,
      side: BorderSide(color: secondaryButtonBorderColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
    );
  }
  
  static ButtonStyle get errorButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryButtonColor,
      foregroundColor: primaryButtonTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
    );
  }
  
  // ========== PADDING Y MARGINS ADICIONALES ==========
  static const EdgeInsets errorButtonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
}