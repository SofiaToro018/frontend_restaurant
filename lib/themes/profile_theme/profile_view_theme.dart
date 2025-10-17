import 'package:flutter/material.dart';

class ProfileViewTheme {
  // ========== PALETA DE COLORES CONSISTENTE ==========
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeLight = Color(0xFFFFE5D9);
  static const Color primaryOrangeDark = Color(0xFFE55A2B);
  static const Color primaryOrangeShade50 = Color(0xFFFFF3F0);
  static const Color primaryOrangeShade100 = Color(0xFFFFE0D1);
  static const Color primaryOrangeShade600 = Color(0xFFE55A2B);
  static const Color primaryOrangeShade700 = Color(0xFFCC4A1F);
  static const Color primaryOrangeShade800 = Color(0xFFB23F1A);
  static const Color primaryOrangeShade900 = Color(0xFF993316);
  
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFFA0AEC0);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  
  // ========== CONFIGURACIÓN GENERAL ==========
  static const EdgeInsets mainPadding = EdgeInsets.all(16.0);
  static const double cardSpacing = 20.0;
  
  // ========== PROFILE CARD PRINCIPAL ULTRA ELEGANTE ==========
  static const double profileCardElevation = 12.0;
  static const double profileCardBorderRadius = 24.0;
  static const EdgeInsets profileCardPadding = EdgeInsets.all(32.0);
  
  // Avatar más elegante
  static const double avatarSize = 120.0;
  static const double avatarBorderRadius = 60.0;
  static const double avatarShadowBlurRadius = 24.0;
  static const double avatarShadowSpreadRadius = 8.0;
  static const double avatarShadowOpacity = 0.4;
  static const double avatarBorderWidth = 4.0;
  
  // Estilos de texto del avatar
  static const TextStyle avatarTextStyle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 2.0,
  );
  
  // Nombre y email con más elegancia
  static const double nameSpacing = 24.0;
  static const double emailSpacing = 12.0;
  static const double statusSpacing = 20.0;
  
  static const TextStyle nameStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  static TextStyle emailStyle = TextStyle(
    fontSize: 18,
    color: Colors.grey[600],
    fontWeight: FontWeight.w500,
  );
  
  // Status badge más elegante
  static const EdgeInsets statusPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  static const double statusBorderRadius = 16.0;
  static const double statusBorderWidth = 0.0; // Sin borde, más moderno
  static const double statusIconSize = 18.0;
  static const double statusIconSpacing = 8.0;
  
  static const TextStyle statusTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
  
  // ========== CONTACT CARD ==========
  static const double contactCardElevation = 4.0;
  static const double contactCardBorderRadius = 16.0;
  static const EdgeInsets contactCardPadding = EdgeInsets.all(20.0);
  
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
  static const double roleCardElevation = 4.0;
  static const double roleCardBorderRadius = 16.0;
  static const EdgeInsets roleCardPadding = EdgeInsets.all(20.0);
  
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
  static const EdgeInsets infoRowPadding = EdgeInsets.all(12.0);
  static const double infoRowBorderRadius = 8.0;
  static const double infoRowIconSize = 20.0;
  static const double infoRowIconSpacing = 12.0;
  static const double infoRowLabelSpacing = 2.0;
  static const double infoRowOpacity = 0.1;
  
  static TextStyle infoRowLabelStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
    fontWeight: FontWeight.w500,
  );
  
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
    color: Colors.grey[600],
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle permissionChipTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.indigo,
    fontWeight: FontWeight.w600,
  );
  
  // ========== ACTION BUTTONS ==========
  static const double buttonSpacing = 12.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 16.0);
  static const double buttonBorderRadius = 12.0;
  
  // Primary button
  static const Color primaryButtonColor = primaryOrangeShade600;
  static const Color primaryButtonTextColor = Colors.white;
  static const double primaryButtonElevation = 4.0;
  
  static const TextStyle primaryButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryButtonTextColor,
  );
  
  // Secondary button
  static const Color secondaryButtonColor = primaryOrangeShade50;
  static const Color secondaryButtonBorderColor = primaryOrange;
  static const Color secondaryButtonTextColor = primaryOrangeShade700;
  
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
  
  static Color errorIconColor = Colors.red[300]!;
  static Color errorTitleColor = Colors.red[600]!;
  static Color errorDescriptionColor = Colors.red[500]!;
  
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
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          primaryOrangeShade50.withValues(alpha: 0.3),
        ],
      ),
      borderRadius: BorderRadius.circular(profileCardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: primaryOrange.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
      border: Border.all(
        color: primaryOrange.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration avatarDecoration(Color roleColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          roleColor,
          roleColor.withValues(alpha: 0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(avatarBorderRadius),
      boxShadow: [
        BoxShadow(
          color: roleColor.withValues(alpha: avatarShadowOpacity),
          blurRadius: avatarShadowBlurRadius,
          spreadRadius: avatarShadowSpreadRadius,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: Colors.white,
        width: avatarBorderWidth,
      ),
    );
  }
  
  static BoxDecoration statusDecoration(Color statusColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          statusColor.withValues(alpha: 0.15),
          statusColor.withValues(alpha: 0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(statusBorderRadius),
      boxShadow: [
        BoxShadow(
          color: statusColor.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration get contactCardDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          primaryOrangeShade50.withValues(alpha: 0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(contactCardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: primaryOrange.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: primaryOrange.withValues(alpha: 0.08),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration get roleCardDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          primaryOrangeShade50.withValues(alpha: 0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(roleCardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: primaryOrange.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: primaryOrange.withValues(alpha: 0.08),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration infoRowDecoration(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.08),
          color.withValues(alpha: 0.03),
        ],
      ),
      borderRadius: BorderRadius.circular(infoRowBorderRadius),
      border: Border.all(
        color: color.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration get permissionChipDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          permissionColor.withValues(alpha: 0.12),
          permissionColor.withValues(alpha: 0.06),
        ],
      ),
      borderRadius: BorderRadius.circular(permissionChipBorderRadius),
      boxShadow: [
        BoxShadow(
          color: permissionColor.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: permissionColor.withValues(alpha: 0.2),
        width: permissionChipBorderWidth,
      ),
    );
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
      shadowColor: primaryOrange.withValues(alpha: 0.3),
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