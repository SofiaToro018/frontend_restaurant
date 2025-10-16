import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/base_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  //* Se crea una instancia de la clase ProfileService
  final ProfileService _profileService = ProfileService();
  //* Se declara una variable de tipo Future que contendrá el perfil del usuario
  late Future<Profile> _futureProfile;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getUserById de la clase ProfileService
    // Usar el usuario por defecto del .env hasta que implementemos login
    final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
    _futureProfile = _profileService.getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Mi Perfil',
      //! Se crea un FutureBuilder que se encargará de construir la vista del perfil
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<Profile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene el perfil del usuario
            final profile = snapshot.data!;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Card principal con información del perfil
                  _buildProfileCard(profile),
                  
                  const SizedBox(height: 20),
                  
                  // Card con información de contacto
                  _buildContactCard(profile),
                  
                  const SizedBox(height: 20),
                  
                  // Card con información del rol y estado
                  _buildRoleStatusCard(profile),
                  
                  const SizedBox(height: 20),
                  
                  // Botones de acción
                  _buildActionButtons(profile),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Card principal con avatar y información básica
  Widget _buildProfileCard(Profile profile) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar circular con iniciales
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _getRoleColor(profile.rolUsuario),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: _getRoleColor(profile.rolUsuario).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Nombre del usuario
            Text(
              profile.formattedName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Email del usuario
            Text(
              profile.emailUsuario,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Estado del usuario
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(profile.estUsuario).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: _getStatusColor(profile.estUsuario),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(profile.estUsuario),
                    color: _getStatusColor(profile.estUsuario),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    profile.statusDescription.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(profile.estUsuario),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card con información de contacto
  Widget _buildContactCard(Profile profile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_mail,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'INFORMACIÓN DE CONTACTO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Email
            _buildInfoRow(
              Icons.email,
              'Email',
              profile.emailUsuario,
              Colors.blue,
            ),
            
            const SizedBox(height: 16),
            
            // Teléfono
            _buildInfoRow(
              Icons.phone,
              'Teléfono',
              profile.formattedPhone,
              profile.hasPhone ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Card con información de rol y estado
  Widget _buildRoleStatusCard(Profile profile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: Colors.purple[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'ROL Y PERMISOS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Rol
            _buildInfoRow(
              _getRoleIcon(profile.rolUsuario),
              'Rol',
              profile.roleDescription,
              _getRoleColor(profile.rolUsuario),
            ),
            
            const SizedBox(height: 16),
            
            // Permisos
            _buildPermissionsSection(profile),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar filas de información
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar permisos del usuario
  Widget _buildPermissionsSection(Profile profile) {
    final permissions = <String>[];
    
    if (profile.hasAdminPermissions) {
      permissions.add('Administración');
    }
    if (profile.canManageOrders) {
      permissions.add('Gestión de Pedidos');
    }
    if (profile.canViewReports) {
      permissions.add('Ver Reportes');
    }
    if (permissions.isEmpty) {
      permissions.add('Permisos básicos');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Permisos:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: permissions.map((permission) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.indigo.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                permission,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Botones de acción
  Widget _buildActionButtons(Profile profile) {
    return Column(
      children: [
        // Botón para editar perfil
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edición de perfil próximamente'),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Botón para cambiar contraseña
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cambio de contraseña próximamente'),
                ),
              );
            },
            icon: const Icon(Icons.lock),
            label: const Text('Cambiar Contraseña'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Vista de error
  Widget _buildErrorView(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar el perfil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
                  _futureProfile = _profileService.getUserById(userId);
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obtener el color según el rol
  Color _getRoleColor(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Colors.red;
      case 'MANAGER':
        return Colors.purple;
      case 'WAITER':
        return Colors.blue;
      case 'CHEF':
        return Colors.orange;
      case 'CUSTOMER':
      case 'USER':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el icono según el rol
  IconData _getRoleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Icons.admin_panel_settings;
      case 'MANAGER':
        return Icons.manage_accounts;
      case 'WAITER':
        return Icons.restaurant_menu;
      case 'CHEF':
        return Icons.restaurant;
      case 'CUSTOMER':
      case 'USER':
        return Icons.person;
      default:
        return Icons.account_circle;
    }
  }

  // Método para obtener el color según el estado
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVO':
        return Colors.green;
      case 'INACTIVO':
        return Colors.grey;
      case 'SUSPENDIDO':
        return Colors.orange;
      case 'BLOQUEADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el icono según el estado
  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVO':
        return Icons.check_circle;
      case 'INACTIVO':
        return Icons.pause_circle;
      case 'SUSPENDIDO':
        return Icons.warning;
      case 'BLOQUEADO':
        return Icons.block;
      default:
        return Icons.help;
    }
  }
}
