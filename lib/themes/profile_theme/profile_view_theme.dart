import 'package:flutter/material.dart';
import '../category_theme/category_list_view_theme.dart';

class ProfileViewTheme {
  // ========== PALETA DE COLORES CONSISTENTE ==========
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeLight = Color(0xFFFFF2EE);
  static const Color primaryOrangeDark = Color(0xFFD3542A);
  static const Color primaryOrangeShade50 = Color(0xFFFFF7F5);
  static const Color primaryOrangeShade100 = Color(0xFFFFEDE8);
  static const Color primaryOrangeShade600 = Color(0xFFE55A2B);
  static const Color primaryOrangeShade700 = Color(0xFFCC4A1F);
  static const Color primaryOrangeShade800 = Color(0xFFB23F1A);
  static const Color primaryOrangeShade900 = Color(0xFF993316);

  // Reuse category theme colors so profile visually matches /menu
  static const Color textPrimary = CategoryListViewTheme.primaryTextColor;
  static const Color textSecondary = CategoryListViewTheme.secondaryTextColor;
  static const Color textMuted = Color(0xFF90A4AE);
  static const Color backgroundColor = CategoryListViewTheme.primaryBackgroundColor;
  // Divider and card border explicit colors
  static const Color dividerColor = Color(0xFFE0E6EA);
  static const Color cardBorderColor = Color(0xFFECEFF3);
  
  // ========== CONFIGURACIÓN GENERAL ==========
  static const EdgeInsets mainPadding = EdgeInsets.all(16.0);
  static const double cardSpacing = 18.0;
  
  // ========== PROFILE CARD PRINCIPAL ULTRA ELEGANTE ==========
  static const double profileCardElevation = 4.0; // align with menu cards
  static const double profileCardBorderRadius = CategoryListViewTheme.cardBorderRadius;
  static const EdgeInsets profileCardPadding = CategoryListViewTheme.cardPadding;
  
  // Avatar más elegante
  static const double avatarSize = 96.0;
  static const double avatarBorderRadius = 48.0;
  static const double avatarShadowBlurRadius = 16.0;
  static const double avatarShadowSpreadRadius = 2.0;
  static const double avatarShadowOpacity = 0.22;
  static const double avatarBorderWidth = 3.0;
  
  // Estilos de texto del avatar
  static const TextStyle avatarTextStyle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 1.6,
  );
  
  // Nombre y email con más elegancia
  static const double nameSpacing = 18.0;
  static const double emailSpacing = 8.0;
  static const double statusSpacing = 14.0;
  
  static TextStyle nameStyle = CategoryListViewTheme.cardTitleStyle.copyWith(color: textPrimary);

  static TextStyle emailStyle = CategoryListViewTheme.cardDescriptionStyle.copyWith(color: textSecondary);
  
  // Status badge más elegante
  static const EdgeInsets statusPadding = EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0);
  static const double statusBorderRadius = 12.0;
  static const double statusBorderWidth = 0.0; // Sin borde, más moderno
  static const double statusIconSize = 16.0;
  static const double statusIconSpacing = 6.0;
  
  static const TextStyle statusTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
  
  // ========== CONTACT CARD ==========
  static const double contactCardElevation = 2.0;
  static const double contactCardBorderRadius = CategoryListViewTheme.cardBorderRadius;
  static const EdgeInsets contactCardPadding = CategoryListViewTheme.cardPadding;
  
  // Header del contact card
  static const double contactHeaderIconSize = 24.0;
  static const double contactHeaderSpacing = 12.0;
  static const double contactSectionSpacing = 20.0;
  static const double contactInfoSpacing = 16.0;
  
  static const TextStyle contactHeaderStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  // ========== ROLE STATUS CARD ==========
  static const double roleCardElevation = 2.0;
  static const double roleCardBorderRadius = CategoryListViewTheme.cardBorderRadius;
  static const EdgeInsets roleCardPadding = CategoryListViewTheme.cardPadding;
  
  // Header del role card
  static const double roleHeaderIconSize = 24.0;
  static const double roleHeaderSpacing = 12.0;
  static const double roleSectionSpacing = 20.0;
  static const double roleInfoSpacing = 16.0;
  
  static const TextStyle roleHeaderStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  // ========== INFO ROWS ==========
  static const EdgeInsets infoRowPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0);
  static const double infoRowBorderRadius = 10.0;
  static const double infoRowIconSize = 18.0;
  static const double infoRowIconSpacing = 12.0;
  static const double infoRowLabelSpacing = 4.0;
  static const double infoRowOpacity = 0.06;

  static TextStyle infoRowLabelStyle = CategoryListViewTheme.cardCategoryStyle.copyWith(color: textSecondary);
  
  static const TextStyle infoRowValueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  
  // ========== PERMISSIONS SECTION ==========
  static const double permissionSpacing = 8.0;
  static const EdgeInsets permissionChipPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const double permissionChipBorderRadius = 12.0;
  static const double permissionChipOpacity = 0.1;
  static const double permissionChipBorderOpacity = 0.3;
  static const double permissionChipBorderWidth = 1.0;
  
  static TextStyle permissionLabelStyle = TextStyle(
    fontSize: 12,
    color: textSecondary,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle permissionChipTextStyle = TextStyle(
    fontSize: 12,
    color: CategoryListViewTheme.accentColor,
    fontWeight: FontWeight.w600,
  );
  
  // ========== ACTION BUTTONS ==========
  static const double buttonSpacing = 12.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 14.0);
  static const double buttonBorderRadius = 12.0;
  
  // Primary button
  static const Color primaryButtonColor = CategoryListViewTheme.accentColor;
  static const Color primaryButtonTextColor = Colors.white;
  static const double primaryButtonElevation = 4.0;
  
  static const TextStyle primaryButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryButtonTextColor,
  );
  
  // Secondary button
  static const Color secondaryButtonColor = Colors.white;
  static const Color secondaryButtonBorderColor = CategoryListViewTheme.viewAllButtonBorderColor;
  static const Color secondaryButtonTextColor = CategoryListViewTheme.accentColor;
  
  static const TextStyle secondaryButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: secondaryButtonTextColor,
  );
  
  // ========== ERROR VIEW ==========
  static const EdgeInsets errorPadding = EdgeInsets.all(32.0);
  static const double errorIconSize = 80.0;
  static const double errorSpacing = 24.0;
  static const double errorDescriptionSpacing = 12.0;
  static const double errorButtonSpacing = 24.0;
  
  static Color errorIconColor = CategoryListViewTheme.errorIconColor;
  static Color errorTitleColor = CategoryListViewTheme.errorTitleColor;
  static Color errorDescriptionColor = CategoryListViewTheme.errorDescriptionColor;
  
  static TextStyle errorTitleStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: errorTitleColor,
  );
  
  static TextStyle errorDescriptionStyle = TextStyle(
    fontSize: 16,
    color: errorDescriptionColor,
  );
  
  static const EdgeInsets errorButtonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  
  // ========== ROLE COLORS ==========
  static const Color adminRoleColor = Color(0xFFDC2626);
  static const Color managerRoleColor = Color(0xFF7C3AED);
  static const Color waiterRoleColor = Color(0xFF2563EB);
  static const Color chefRoleColor = primaryOrangeShade600;
  static const Color customerRoleColor = Color(0xFF059669);
  static const Color defaultRoleColor = Color(0xFF6B7280);
  
  // ========== STATUS COLORS ==========
  static const Color activeStatusColor = Color(0xFF059669);
  static const Color inactiveStatusColor = Color(0xFF6B7280);
  static const Color suspendedStatusColor = primaryOrangeShade600;
  static const Color blockedStatusColor = Color(0xFFDC2626);
  static const Color defaultStatusColor = Color(0xFF6B7280);
  
  // ========== CONTACT INFO COLORS ==========
  static const Color emailColor = Color(0xFF2563EB);
  static const Color phoneColor = Color(0xFF059669);
  static const Color phoneDisabledColor = Color(0xFF6B7280);
  static const Color contactHeaderColor = primaryOrangeShade600;
  
  // ========== ROLE INFO COLORS ==========
  static const Color roleHeaderColor = primaryOrangeShade700;
  static const Color permissionColor = Color(0xFF4F46E5);
  
  // ========== DECORACIONES ULTRA ELEGANTES ==========
  static BoxDecoration get profileCardDecoration {
    return CategoryListViewTheme.buildCardDecoration();
  }
  
  static BoxDecoration avatarDecoration(Color roleColor) {
    return CategoryListViewTheme.buildCardButtonSmallDecoration().copyWith(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
    colors: [roleColor, roleColor.withValues(alpha: 0.88)],
      ),
      borderRadius: BorderRadius.circular(avatarBorderRadius),
      border: Border.all(color: Colors.white, width: avatarBorderWidth),
    );
  }
  
  static BoxDecoration statusDecoration(Color statusColor) {
    return CategoryListViewTheme.newNotAvailableDecoration.copyWith(
  color: statusColor.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(statusBorderRadius),
    
    );
  }
  
  static BoxDecoration get contactCardDecoration {
    return CategoryListViewTheme.buildCardDecoration();
  }
  
  static BoxDecoration get roleCardDecoration {
    return CategoryListViewTheme.buildCardDecoration();
  }
  
  static BoxDecoration infoRowDecoration(Color color) {
    return CategoryListViewTheme.buildCardDecoration().copyWith(
      color: CategoryListViewTheme.newMenuItemBackgroundColor,
      borderRadius: BorderRadius.circular(infoRowBorderRadius),
  border: Border.all(color: color.withValues(alpha: 0.06), width: 1),
    );
  }
  
  static BoxDecoration get permissionChipDecoration {
    return CategoryListViewTheme.buildCardCategoryDecoration();
  }
  
  // ========== BUTTON STYLES ==========
  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryButtonColor,
      foregroundColor: primaryButtonTextColor,
      padding: buttonPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      elevation: primaryButtonElevation,
      shadowColor: const Color.fromARGB(255, 53, 255, 77).withValues(alpha: 0.3),
    );
  }
  
  static ButtonStyle get secondaryButtonStyle {
    return OutlinedButton.styleFrom(
      backgroundColor: secondaryButtonColor,
      foregroundColor: secondaryButtonTextColor,
      side: const BorderSide(color: secondaryButtonBorderColor),
      padding: buttonPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
    );
  }
  
  // ========== SHAPES ==========
  static RoundedRectangleBorder get profileCardShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(profileCardBorderRadius),
    );
  }
  
  static RoundedRectangleBorder get contactCardShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(contactCardBorderRadius),
    );
  }
  
  static RoundedRectangleBorder get roleCardShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(roleCardBorderRadius),
    );
  }
}