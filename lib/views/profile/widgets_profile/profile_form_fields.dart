import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campos del formulario de edición de perfil
class ProfileFormFields extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController emailController;
  final TextEditingController telefonoController;
  final TextEditingController rolController;
  final TextEditingController passwordController;
  final bool isEnabled;

  const ProfileFormFields({
    super.key,
    required this.nombreController,
    required this.emailController,
    required this.telefonoController,
    required this.rolController,
    required this.passwordController,
    this.isEnabled = true,
  });

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'El email es obligatorio';
    final email = value.trim();
    final valid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    if (!valid) return 'Email inválido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nombre
        TextFormField(
          controller: nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre *',
            hintText: 'Ingrese su nombre completo',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          enabled: isEnabled,
          validator: (v) => _validateRequired(v, 'El nombre'),
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email *',
            hintText: 'Ingrese su correo electrónico',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          enabled: isEnabled,
          validator: _validateEmail,
        ),
        const SizedBox(height: 16),

        // Teléfono
        TextFormField(
          controller: telefonoController,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            hintText: 'Ingrese su teléfono',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          enabled: isEnabled,
          validator: (v) => null, // opcional
        ),
        const SizedBox(height: 16),

        // Rol (si aplica)
        TextFormField(
          controller: rolController,
          decoration: const InputDecoration(
            labelText: 'Rol',
            hintText: 'Ej. ADMIN, MANAGER, USER',
            prefixIcon: Icon(Icons.shield),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
          enabled: isEnabled,
          validator: (v) => null,
        ),
        const SizedBox(height: 16),

        // Contraseña
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña *',
            hintText: 'Ingrese su contraseña',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          enabled: isEnabled,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'La contraseña es obligatoria';
            }
            if (v.length < 6) {
              return 'Debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }
}
