import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../auth/services/auth_service.dart';
import 'widgets_profile/profile_form_fields.dart';

class ProfileEditView extends StatefulWidget {
  final int id;

  const ProfileEditView({super.key, required this.id});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _service = ProfileService();
  final _authService = AuthService();
  final _picker = ImagePicker();

  bool _isLoading = true;
  bool _isSubmitting = false;
  Profile? _profile;

  // Form controllers
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _rolCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  File? _pickedImage;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _rolCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _service.getUserById(widget.id);
      if (!mounted) return;
      setState(() {
        _profile = p;
        _isLoading = false;
        _nombreCtrl.text = p.formattedName;
        _emailCtrl.text = p.emailUsuario;
        _telefonoCtrl.text = p.telUsuario ?? '';
        _rolCtrl.text = p.rolUsuario;
        _passwordCtrl.text = p.password ?? '';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al cargar perfil: $e')),
      );
      context.pop();
    }
  }

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (result != null) {
      setState(() {
        _pickedImage = File(result.path);
      });
    }
  }

  /// Actualiza AuthService con los datos más recientes para reflejar cambios inmediatamente
  Future<void> _updateAuthService(Profile updatedProfile) async {
    try {
      // Usar el método público updateCurrentUser() que obtiene datos del servidor
      // y actualiza la sesión local automáticamente
      final result = await _authService.updateCurrentUser();
      if (result.hasError) {
        debugPrint('Warning: Failed to update AuthService: ${result.errorMessage}');
      }
    } catch (e) {
      // No bloquear la UI si falla la actualización local
      debugPrint('Warning: Failed to update AuthService: $e');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profile == null) return;

    setState(() => _isSubmitting = true);

    final updated = _profile!.copyWith(
      nomUsuario: _nombreCtrl.text.trim(),
      emailUsuario: _emailCtrl.text.trim(),
      telUsuario: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      rolUsuario: _rolCtrl.text.trim().isEmpty ? _profile!.rolUsuario : _rolCtrl.text.trim(),
      password: _passwordCtrl.text.trim().isEmpty ? _profile!.password : _passwordCtrl.text.trim(),
    );

    try {
      final updatedProfile = await _service.updateUser(updated);
      if (!mounted) return;
      
      // Actualizar AuthService con el perfil actualizado para reflejar cambios inmediatamente
      await _updateAuthService(updatedProfile);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Perfil actualizado'), backgroundColor: Colors.green),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) errorMessage = errorMessage.substring(11);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $errorMessage'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar preview + pick button
                    if (_pickedImage != null)
                      CircleAvatar(radius: 48, backgroundImage: FileImage(_pickedImage!))
                    else if (_profile != null)
                      CircleAvatar(radius: 48, child: Text(_profile!.initials)),
                    TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.photo), label: const Text('Seleccionar foto')),

                    const SizedBox(height: 12),

                    Expanded(
                      child: SingleChildScrollView(
                        child: ProfileFormFields(
                          nombreController: _nombreCtrl,
                          emailController: _emailCtrl,
                          telefonoController: _telefonoCtrl,
                          rolController: _rolCtrl,
                          passwordController: _passwordCtrl,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        child: _isSubmitting ? const CircularProgressIndicator() : const Text('Guardar cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
