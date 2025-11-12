import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../themes/splash_intro_theme/splash_intro_view_theme.dart';

/// Pantalla de bienvenida (Splash Intro) con animaciones
class SplashIntroView extends StatefulWidget {
  const SplashIntroView({super.key});

  @override
  State<SplashIntroView> createState() => _SplashIntroViewState();
}

class _SplashIntroViewState extends State<SplashIntroView>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  // Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<double> _buttonsFadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Scale animation para el logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animations con stagger
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutQuart),
    ));

    _subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOutQuart),
    ));

    _buttonsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutQuart),
    ));

    // Button press animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scaleController.forward();
      _fadeController.forward();
    });
  }

  void _onGetStartedPressed() async {
    // Animación de botón presionado
    await _buttonController.forward();
    await _buttonController.reverse();
    
    // Navegación a registro
    if (mounted) {
      context.go('/register');
    }
  }

  void _onLoginPressed() {
    context.go('/login');
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashIntroViewTheme.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SplashIntroViewTheme.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top spacing flexible (reducido)
              const Spacer(flex: 1),
              
              // App Title Section
              _buildAppTitleSection(),
              
              // Increased spacing to separate welcome text from logo
              const SizedBox(height: 40),
              
              // Logo Section with Animation
              _buildLogoSection(),
              
              // Flexible spacing after logo (aumentado para bajar contenido)
              const Spacer(flex: 2),
              
              // Main Content Section
              _buildMainContentSection(),
              
              // Flexible spacing to push buttons down
              const Spacer(flex: 3),
              
              // Page indicator
              _buildPageIndicatorSection(),
              
              // Medium spacing before buttons
              const SizedBox(height: 24),
              
              // Buttons Section
              _buildButtonsSection(),
              
              // Bottom spacing flexible
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // Sección del título de la aplicación
  Widget _buildAppTitleSection() {
    return Text(
      'Welcome to',
      style: SplashIntroViewTheme.appTitleStyle,
    );
  }

  // Sección del logo con animación
  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildLogoContainer(),
        );
      },
    );
  }

  // Sección de contenido principal (título y subtítulo)
  Widget _buildMainContentSection() {
    return Column(
      children: [
        // Animated main title
        FadeTransition(
          opacity: _titleFadeAnimation,
          child: Text(
            'Best thing since\nsliced bread',
            style: SplashIntroViewTheme.mainHeadingStyle,
            textAlign: TextAlign.center,
          ),
        ),
        
        // Small spacing
        const SizedBox(height: 12),
        
        // Animated subtitle
        FadeTransition(
          opacity: _subtitleFadeAnimation,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: SplashIntroViewTheme.subtitleMaxWidth,
            ),
            child: Text(
              'Discover amazing recipes and manage your dining experience',
              style: SplashIntroViewTheme.subtitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  // Sección del indicador de página
  Widget _buildPageIndicatorSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: SplashIntroViewTheme.dotSpacing / 2,
          ),
          width: SplashIntroViewTheme.dotSize,
          height: SplashIntroViewTheme.dotSize,
          decoration: BoxDecoration(
            color: index == 1 
                ? SplashIntroViewTheme.activeDot 
                : SplashIntroViewTheme.inactiveDot,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  // Sección de botones con animaciones
  Widget _buildButtonsSection() {
    return FadeTransition(
      opacity: _buttonsFadeAnimation,
      child: Column(
        children: [
          // Primary button with press animation
          AnimatedBuilder(
            animation: _buttonScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _buttonScaleAnimation.value,
                child: _buildPrimaryButton(),
              );
            },
          ),
          
          // Secondary button spacing
          const SizedBox(height: SplashIntroViewTheme.secondaryButtonTopMargin),
          
          // Secondary button
          _buildSecondaryButton(),
        ],
      ),
    );
  }

  // Contenedor del logo
  Widget _buildLogoContainer() {
    return Container(
      width: SplashIntroViewTheme.logoContainerSize,
      height: SplashIntroViewTheme.logoContainerSize,
      decoration: SplashIntroViewTheme.buildLogoContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(SplashIntroViewTheme.logoInternalPadding),
        child: Center(
          child: _buildLogoWidget(),
        ),
      ),
    );
  }

  // Botón primario
  Widget _buildPrimaryButton() {
    return SizedBox(
      width: SplashIntroViewTheme.buttonWidth,
      height: SplashIntroViewTheme.buttonHeight,
      child: ElevatedButton(
        onPressed: _onGetStartedPressed,
        style: SplashIntroViewTheme.buildPrimaryButtonStyle(),
        child: Text(
          'Get started',
          style: SplashIntroViewTheme.buttonPrimaryStyle,
          semanticsLabel: 'Get started button',
        ),
      ),
    );
  }

  // Botón secundario
  Widget _buildSecondaryButton() {
    return SizedBox(
      width: SplashIntroViewTheme.buttonWidth,
      height: SplashIntroViewTheme.buttonHeight,
      child: OutlinedButton(
        onPressed: _onLoginPressed,
        style: SplashIntroViewTheme.buildSecondaryButtonStyle(),
        child: Text(
          'Login',
          style: SplashIntroViewTheme.buttonSecondaryStyle,
          semanticsLabel: 'Login button',
        ),
      ),
    );
  }

  // Widget del logo
  Widget _buildLogoWidget() {
    return Container(
      width: SplashIntroViewTheme.logoMaxWidth,
      height: SplashIntroViewTheme.logoMaxWidth,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 239, 239, 238),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        'assets/images/logo_dinner_lock.png',
        width: SplashIntroViewTheme.logoMaxWidth,
        fit: BoxFit.contain,
        semanticLabel: 'Dinner Lock Logo',
        errorBuilder: (context, error, stackTrace) {
          // Fallback al ícono si el logo no carga
          return const Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.white,
          );
        },
      ),
    );
  }
}