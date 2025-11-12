import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../models/register.dart';
import '../services/auth_service.dart';
import '../../themes/auth_theme/login_view_theme.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole _selectedRole = UserRole.cliente;

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          physics: const ClampingScrollPhysics(), // Mejor comportamiento scroll
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom - 
                         (MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                _buildBackButton(),
                
                // Small spacing
                const SizedBox(height: 16),
                
                // Title Section
                _buildTitleSection(),
                
                // Small spacing between title and character
                const SizedBox(height: 16),
                
                // Character Section with Animation
                _buildCharacterSection(),
                
                // Medium spacing after character
                const SizedBox(height: 24),
                
                // Form Section
                _buildFormSection(),
                
                // Help Text Section
                _buildHelpTextSection(),
                
                // Bottom spacing (responsive)
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 40,
                ),
              ],
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
              height: 210, // Imagen más grande
              child: Image.asset(
                LoginViewTheme.registerCharacterAsset,
                fit: BoxFit.contain,
                semanticLabel: 'Character signing up',
                errorBuilder: (context, error, stackTrace) {
                  // Fallback al logo si signUp.png no existe
                  return Image.asset(
                    LoginViewTheme.fallbackCharacterAsset,
                    fit: BoxFit.contain,
                    semanticLabel: 'Dinner Lock Logo',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: LoginViewTheme.fieldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          size: 80,
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
        'Create Account',
        style: LoginViewTheme.titleStyle,
        textAlign: TextAlign.center,
        semanticsLabel: 'Create account title',
      ),
    );
  }

  // Sección del formulario
  Widget _buildFormSection() {
    return FadeTransition(
      opacity: _fieldsFadeAnimation,
      child: SizedBox(
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
                const SizedBox(height: 12),
              ],
              
              // Campo de nombre completo
              SizedBox(
                height: LoginViewTheme.fieldHeight,
                child: TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  validator: _validateName,
                  style: LoginViewTheme.fieldStyle,
                  decoration: LoginViewTheme.buildInputDecoration(
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
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
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Campo de teléfono
              SizedBox(
                height: LoginViewTheme.fieldHeight,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !_isLoading,
                  validator: _validatePhone,
                  style: LoginViewTheme.fieldStyle,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: LoginViewTheme.buildInputDecoration(
                    hintText: 'Phone Number (10 digits)',
                    prefixIcon: Icons.phone_outlined,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Selector de rol
              Container(
                height: LoginViewTheme.fieldHeight,
                decoration: LoginViewTheme.buildFieldDecoration(),
                child: DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  style: LoginViewTheme.fieldStyle,
                  decoration: const InputDecoration(
                    hintText: 'Select Role',
                    prefixIcon: Icon(
                      Icons.admin_panel_settings_outlined,
                      color: LoginViewTheme.placeholderColor,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(
                        role == UserRole.cliente ? 'Cliente' : 'Administrador',
                        style: LoginViewTheme.fieldStyle,
                      ),
                    );
                  }).toList(),
                  onChanged: _isLoading ? null : (UserRole? newRole) {
                    setState(() {
                      _selectedRole = newRole ?? UserRole.cliente;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 12),
              
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
                    hintText: 'Password',
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
              
              const SizedBox(height: 12),
              
              // Campo de confirmar contraseña
              SizedBox(
                height: LoginViewTheme.fieldHeight,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  enabled: !_isLoading,
                  validator: _validateConfirmPassword,
                  style: LoginViewTheme.fieldStyle,
                  decoration: LoginViewTheme.buildInputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: LoginViewTheme.placeholderColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botón Create Account con animación
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: SizedBox(
                      width: double.infinity,
                      height: LoginViewTheme.fieldHeight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegisterWithAnimation,
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
                                'Create Account',
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
      margin: const EdgeInsets.only(top: 16),
      child: FadeTransition(
        opacity: _fieldsFadeAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
              style: LoginViewTheme.helpTextStyle,
            ),
            GestureDetector(
              onTap: () {
                context.go('/login');
              },
              child: const Text(
                'Sign In',
                style: LoginViewTheme.linkStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método de registro con animación del botón
  Future<void> _handleRegisterWithAnimation() async {
    // Prevenir múltiples ejecuciones
    if (_isLoading) return;
    
    try {
      // Animar el botón
      await _buttonAnimationController.forward();
      await _buttonAnimationController.reverse();
      
      // Ejecutar el registro
      await _handleRegister();
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

  // Validaciones
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    if (value.length != 10) {
      return 'El teléfono debe tener exactamente 10 dígitos';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'El teléfono solo debe contener números';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Debe contener al menos una mayúscula y un número';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _handleRegister() async {
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
      // Crear request de registro
      final registerRequest = RegisterRequest(
        nomUsuario: _nameController.text.trim(),
        emailUsuario: _emailController.text.trim(),
        rolUsuario: _selectedRole.value,
        telUsuario: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      // Intentar hacer registro
      final result = await _authService.registerUser(registerRequest);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.isSuccess) {
          // Registro exitoso, mostrar mensaje y navegar al login
          _showSuccessMessage(result.message ?? '¡Registro exitoso!');
          
          // Navegar después de 3 segundos
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              context.go('/login');
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
        duration: const Duration(seconds: 3),
      ),
    );
  }
}