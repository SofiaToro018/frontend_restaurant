import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../../themes/auth_theme/login_view_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Animation Controllers
  late AnimationController _characterAnimationController;
  late AnimationController _contentAnimationController;
  late AnimationController _buttonAnimationController;

  // Animations
  late Animation<double> _characterFadeAnimation;
  late Animation<double> _characterSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _fieldsFadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _characterAnimationController.dispose();
    _contentAnimationController.dispose();
    _buttonAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Character animation (fade-in + slide-up)
    _characterAnimationController = AnimationController(
      duration: LoginViewTheme.characterAnimationDuration,
      vsync: this,
    );

    _characterFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterAnimationController,
      curve: LoginViewTheme.animationCurve,
    ));

    _characterSlideAnimation = Tween<double>(
      begin: LoginViewTheme.characterSlideDistance,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _characterAnimationController,
      curve: LoginViewTheme.animationCurve,
    ));

    // Content animation (staggered fade-in)
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _fieldsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    ));

    // Button press animation
    _buttonAnimationController = AnimationController(
      duration: LoginViewTheme.buttonPressAnimationDuration,
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: LoginViewTheme.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start character animation immediately
    _characterAnimationController.forward();
    
    // Start content animation with stagger delay
    Future.delayed(LoginViewTheme.staggeredAnimationDelay, () {
      if (mounted) {
        _contentAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginViewTheme.backgroundColor,
      resizeToAvoidBottomInset: true, // Importante para el teclado
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: LoginViewTheme.horizontalPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button
                  _buildBackButton(),
                  
                  // Top spacing
                  const SizedBox(height: 20),
                  
                  // Title Section (Welcome Back arriba)
                  _buildTitleSection(),
                  
                  // Spacing between title and character
                  const SizedBox(height: 24),
                  
                  // Character Section with Animation
                  _buildCharacterSection(),
                  
                  // Spacing after character
                  const SizedBox(height: 32),
                  
                  // Form Section
                  _buildFormSection(),
                  
                  // Push help text to available space
                  const Spacer(),
                  
                  // Help Text Section
                  _buildHelpTextSection(),
                  
                  // Bottom spacing
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Botón de retroceso
  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: LoginViewTheme.backButtonTopPadding,
        left: LoginViewTheme.backButtonLeftPadding,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(LoginViewTheme.backButtonBorderRadius),
            onTap: () {
              context.go('/splash');
            },
            child: Container(
              width: LoginViewTheme.backButtonSize,
              height: LoginViewTheme.backButtonSize,
              decoration: LoginViewTheme.buildBackButtonDecoration(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: LoginViewTheme.backButtonIcon,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sección del personaje con animación
  Widget _buildCharacterSection() {
    return AnimatedBuilder(
      animation: _characterAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _characterSlideAnimation.value),
          child: Opacity(
            opacity: _characterFadeAnimation.value,
            child: SizedBox(
              height: LoginViewTheme.characterHeight,
              child: Image.asset(
                LoginViewTheme.characterAsset,
                fit: BoxFit.contain,
                semanticLabel: 'Character with key',
                errorBuilder: (context, error, stackTrace) {
                  // Fallback al logo si signIn.png no existe
                  return Image.asset(
                    LoginViewTheme.fallbackCharacterAsset,
                    fit: BoxFit.contain,
                    semanticLabel: 'Dinner Lock Logo',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: LoginViewTheme.characterHeight,
                        decoration: BoxDecoration(
                          color: LoginViewTheme.fieldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 100,
                          color: LoginViewTheme.placeholderColor,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Sección del título
  Widget _buildTitleSection() {
    return FadeTransition(
      opacity: _titleFadeAnimation,
      child: const Text(
        'Welcome Back!',
        style: LoginViewTheme.titleStyle,
        textAlign: TextAlign.center,
        semanticsLabel: 'Welcome back title',
      ),
    );
  }

  // Sección del formulario
  Widget _buildFormSection() {
    return FadeTransition(
      opacity: _fieldsFadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 32),
        width: MediaQuery.of(context).size.width * LoginViewTheme.fieldWidth,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Mensaje de error
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LoginViewTheme.fieldSpacing),
              ],
              
              // Campo de email
              SizedBox(
                height: LoginViewTheme.fieldHeight,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: _validateEmail,
                  style: LoginViewTheme.fieldStyle,
                  decoration: LoginViewTheme.buildInputDecoration(
                    hintText: 'Enter your Email address',
                    prefixIcon: Icons.email_outlined,
                  ),

                ),
              ),
              
              const SizedBox(height: 16), // Aumentado el espaciado entre campos
              
              // Campo de contraseña
              SizedBox(
                height: LoginViewTheme.fieldHeight,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  validator: _validatePassword,
                  style: LoginViewTheme.fieldStyle,
                  decoration: LoginViewTheme.buildInputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: LoginViewTheme.placeholderColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                ),
              ),
              
              const SizedBox(height: 28), // Aumentado el espaciado antes del botón
              
              // Botón Sign In con animación
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: SizedBox(
                      width: double.infinity,
                      height: LoginViewTheme.fieldHeight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLoginWithAnimation,
                        style: LoginViewTheme.buildPrimaryButtonStyle(),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    LoginViewTheme.buttonTextColor,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: LoginViewTheme.buttonStyle,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sección de texto de ayuda
  Widget _buildHelpTextSection() {
    return Container(
      margin: const EdgeInsets.only(top: LoginViewTheme.helpTextTopMargin),
      child: FadeTransition(
        opacity: _fieldsFadeAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: LoginViewTheme.helpTextStyle,
            ),
            GestureDetector(
              onTap: _goToRegister,
              child: const Text(
                'Sign Up',
                style: LoginViewTheme.linkStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método de login con animación del botón
  Future<void> _handleLoginWithAnimation() async {
    // Prevenir múltiples ejecuciones
    if (_isLoading) return;
    
    try {
      // Animar el botón
      await _buttonAnimationController.forward();
      await _buttonAnimationController.reverse();
      
      // Ejecutar el login
      await _handleLogin();
    } catch (e) {
      // Manejar errores de animación
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado. Inténtalo de nuevo.';
        });
      }
    }
  }

  // Navegar a registro
  void _goToRegister() {
    context.go('/register');
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    // Limpiar mensaje de error anterior
    setState(() {
      _errorMessage = null;
    });

    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Mostrar loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Crear request de login
      final loginRequest = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Intentar hacer login
      final result = await _authService.loginWithEmailAndPassword(loginRequest);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.isAuthenticated) {
          // Login exitoso
          _showSuccessMessage('¡Bienvenido, ${result.usuario!.formattedName}!');
          
          // Navegar después de un breve delay para mostrar el mensaje
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              // Redirigir según el rol del usuario
              final usuario = result.usuario!;
              
              if (usuario.rolUsuario.toUpperCase() == 'ADMINISTRADOR' || 
                  usuario.rolUsuario.toUpperCase() == 'ADMIN') {
                // Usuario administrador -> Panel de administración
                context.go('/admin');
              } else {
                // Usuario cliente u otro rol -> Menú principal
                context.go('/menu');
              }
            }
          });
        } else if (result.hasError) {
          // Mostrar error
          setState(() {
            _errorMessage = result.errorMessage;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado. Inténtalo de nuevo.';
        });
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }


}