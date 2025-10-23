import 'package:flutter/material.dart';

/// Tema para la pantalla de login siguiendo especificaciones de diseño exactas
class LoginViewTheme {
  // === COLORES ===
  static const Color backgroundColor = Color(0xFFF9F9FB); // Fondo lavanda suave
  static const Color titleTextColor = Color(0xFF000000); // Negro para título
  static const Color fieldBackgroundColor = Color(0xFFFFFFFF); // Fondo blanco campos
  static const Color fieldBorderColor = Color(0x0F000000); // Border rgba(0,0,0,0.06)
  static const Color placeholderColor = Color(0xFFBDBDBD); // Placeholder gris
  static const Color buttonBackgroundColor = Color(0xFF000000); // Botón negro
  static const Color buttonTextColor = Color(0xFFFFFFFF); // Texto blanco botón
  static const Color helpTextColor = Color(0xFF8A8A8A); // Texto ayuda gris
  static const Color linkColor = Color(0xFFFF7A00); // Link naranja
  static const Color focusedBorderColor = Color(0xFF2196F3); // Azul suave para focus
  static const Color backButtonColor = Color(0xFFFFFFFF); // Fondo botón retroceso
  static const Color backButtonBorder = Color(0xFFEBEBF0); // Borde botón retroceso
  static const Color backButtonIcon = Color(0xFF333333); // Ícono negro

  // === MEDIDAS EXACTAS ===
  static const double screenWidth = 360.0; // Referencia móvil
  static const double horizontalPadding = 24.0; // Padding horizontal general
  static const double characterHeight = 280.0; // Aumentado de 220 a 280
  static const double characterTopMargin = 28.0; // Margin-top personaje
  static const double titleTopMargin = 16.0; // Margin desde imagen
  static const double fieldWidth = 0.88; // 88% del ancho
  static const double fieldHeight = 48.0; // Altura campos
  static const double fieldSpacing = 12.0; // Espacio entre campos
  static const double buttonTopMargin = 20.0; // Margin-top botón
  static const double helpTextTopMargin = 12.0; // Margin-top texto ayuda
  static const double safeAreaBottom = 20.0; // Safe area inferior

  // === BORDER RADIUS ===
  static const double fieldBorderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;

  // === SOMBRAS ===
  static const double shadowBlurRadius = 8.0;
  static const Offset shadowOffset = Offset(0, 4);
  static const double shadowOpacity = 0.06;
  static const double buttonElevation = 2.0;
  static const double backButtonSize = 40.0; // Botón cuadrado 40x40
  static const double backButtonTopPadding = 8.0; // Padding superior
  static const double backButtonLeftPadding = 4.0; // Padding izquierdo
  static const double backButtonBorderWidth = 1.2; // Grosor borde
  static const double backButtonBorderRadius = 12.0; // Bordes redondeados

  // === TEXTO STYLES ===
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: titleTextColor,
    height: 1.2,
  );

  static const TextStyle fieldStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle placeholderStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: placeholderColor,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: buttonTextColor,
  );

  static const TextStyle helpTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: helpTextColor,
  );

  static const TextStyle linkStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: linkColor,
  );

  // === DECORATIONS ===
  static BoxDecoration buildFieldDecoration({bool focused = false}) {
    return BoxDecoration(
      color: fieldBackgroundColor,
      borderRadius: BorderRadius.circular(fieldBorderRadius),
      border: Border.all(
        color: focused ? focusedBorderColor : fieldBorderColor,
        width: focused ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: shadowOpacity),
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }

  static ButtonStyle buildPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonTextColor,
      elevation: buttonElevation,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
      ),
      minimumSize: Size(screenWidth * fieldWidth, fieldHeight),
    );
  }

  static InputDecoration buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: placeholderStyle,
      prefixIcon: Icon(
        prefixIcon,
        color: placeholderColor,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fieldBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius),
        borderSide: BorderSide(
          color: fieldBorderColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius),
        borderSide: BorderSide(
          color: fieldBorderColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  // === ASSETS ===
  static const String characterAsset = 'assets/images/signIn.png';
  static const String registerCharacterAsset = 'assets/images/signUp.png';
  static const String fallbackCharacterAsset = 'assets/images/logo_dinner_lock.png';

  static BoxDecoration buildBackButtonDecoration() {
    return BoxDecoration(
      color: backButtonColor,
      borderRadius: BorderRadius.circular(backButtonBorderRadius),
      border: Border.all(
        color: backButtonBorder,
        width: backButtonBorderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // === ANIMACIONES ===
  static const Duration characterAnimationDuration = Duration(milliseconds: 420);
  static const Duration staggeredAnimationDelay = Duration(milliseconds: 100);
  static const Curve animationCurve = Curves.easeOutCubic;
  static const double characterSlideDistance = 18.0;
  static const Duration buttonPressAnimationDuration = Duration(milliseconds: 120);
  static const double buttonPressScale = 0.98;
}