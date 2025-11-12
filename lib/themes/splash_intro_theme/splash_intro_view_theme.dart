import 'package:flutter/material.dart';

/// Clase con todos los estilos y constantes de la pantalla de splash intro
class SplashIntroViewTheme {
  // Colors
  static const Color primaryBackground = Color(0xFFF8F9FA);
  static const Color logoContainerBg = Color(0xFF1F5A3D);
  static const Color logoBorder = Color(0xFFEFEFEE);
  static const Color primaryButton = Color(0xFF000000);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color titleText = Color(0xFF0B0B0B);
  static const Color mainHeading = Color(0xFF000000);
  static const Color subtitleText = Color(0xFF6B6B6B);
  static const Color secondaryButtonText = Color(0xFF000000);
  static const Color activeDot = Color(0xFCC6D6E9);
  static const Color inactiveDot = Color(0xFFE1E1E1);
  static const Color buttonBorder = Color(0xFFE6E6E6);

  // Layout Constants
  static const double screenPadding = 24.0;
  static const double logoContainerSize = 220.0;
  static const double logoMaxWidth = 160.0;
  static const double logoBorderRadius = 40.0;
  static const double logoBorderWidth = 3.0;
  static const double logoInternalPadding = 18.0;

  // Button Specifications
  static const double buttonWidth = 280.0;
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 12.0;
  static const double secondaryButtonBorderWidth = 1.2;

  // Page Indicator
  static const double dotSize = 6.0;
  static const double dotSpacing = 8.0;
  static const double subtitleMaxWidth = 280.0;

  // Spacings
  static const double secondaryButtonTopMargin = 12.0;

  // Text Styles (usando fuentes del sistema temporalmente)
  static const TextStyle appTitleStyle = TextStyle(
    // fontFamily: 'Poppins', // Temporalmente comentado
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: titleText,
  );

  static const TextStyle mainHeadingStyle = TextStyle(
    // fontFamily: 'Poppins', // Temporalmente comentado
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.05,
    color: mainHeading,
  );

  static const TextStyle subtitleStyle = TextStyle(
    // fontFamily: 'Roboto', // Temporalmente comentado
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: subtitleText,
  );

  static const TextStyle buttonPrimaryStyle = TextStyle(
    // fontFamily: 'Poppins', // Temporalmente comentado
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: buttonText,
  );

  static const TextStyle buttonSecondaryStyle = TextStyle(
    // fontFamily: 'Poppins', // Temporalmente comentado
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: secondaryButtonText,
  );

  // Decorations
  static BoxDecoration buildLogoContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(logoBorderRadius),
      border: Border.all(
        color: logoBorder,
        width: logoBorderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(31), // alpha 0.12
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static ButtonStyle buildPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryButton,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
    );
  }

  static ButtonStyle buildSecondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: buttonBorder,
        width: secondaryButtonBorderWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
    );
  }
}