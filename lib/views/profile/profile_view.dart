import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../themes/profile_theme/profile_view_theme.dart';
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
              padding: ProfileViewTheme.mainPadding,
              child: Column(
                children: [
                  // Card principal con información del perfil
                  _buildProfileCard(profile),
                  
                  SizedBox(height: ProfileViewTheme.cardSpacing),
                  
                  // Card con información de contacto
                  _buildContactCard(profile),
                  
                  SizedBox(height: ProfileViewTheme.cardSpacing),
                  
                  // Card con información del rol y estado
                  _buildRoleStatusCard(profile),
                  
                  SizedBox(height: ProfileViewTheme.cardSpacing),
                  
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
      elevation: ProfileViewTheme.profileCardElevation,
      shape: ProfileViewTheme.profileCardShape,
      child: Container(
        decoration: ProfileViewTheme.profileCardDecoration,
        child: Padding(
          padding: ProfileViewTheme.profileCardPadding,
          child: Column(
            children: [
              // Avatar circular con iniciales
              Container(
                width: ProfileViewTheme.avatarSize,
                height: ProfileViewTheme.avatarSize,
                decoration: ProfileViewTheme.avatarDecoration(_getRoleColor(profile.rolUsuario)),
                child: Center(
                  child: Text(
                    profile.initials,
                    style: ProfileViewTheme.avatarTextStyle,
                  ),
                ),
              ),
              
              SizedBox(height: ProfileViewTheme.nameSpacing),
              
              // Nombre del usuario
              Text(
                profile.formattedName,
                style: ProfileViewTheme.nameStyle,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: ProfileViewTheme.emailSpacing),
              
              // Email del usuario
              Text(
                profile.emailUsuario,
                style: ProfileViewTheme.emailStyle,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: ProfileViewTheme.statusSpacing),
              
              // Estado del usuario
              Container(
                padding: ProfileViewTheme.statusPadding,
                decoration: ProfileViewTheme.statusDecoration(_getStatusColor(profile.estUsuario)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(profile.estUsuario),
                      color: _getStatusColor(profile.estUsuario),
                      size: ProfileViewTheme.statusIconSize,
                    ),
                    SizedBox(width: ProfileViewTheme.statusIconSpacing),
                    Text(
                      profile.statusDescription.toUpperCase(),
                      style: ProfileViewTheme.statusTextStyle.copyWith(
                        color: _getStatusColor(profile.estUsuario),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card con información de contacto
  Widget _buildContactCard(Profile profile) {
    return Card(
      elevation: ProfileViewTheme.contactCardElevation,
      shape: ProfileViewTheme.contactCardShape,
      child: Container(
        decoration: ProfileViewTheme.contactCardDecoration,
        child: Padding(
          padding: ProfileViewTheme.contactCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.contact_mail,
                    color: ProfileViewTheme.contactHeaderColor,
                    size: ProfileViewTheme.contactHeaderIconSize,
                  ),
                  SizedBox(width: ProfileViewTheme.contactHeaderSpacing),
                  Text(
                    'INFORMACIÓN DE CONTACTO',
                    style: ProfileViewTheme.contactHeaderStyle,
                  ),
                ],
              ),
              
              SizedBox(height: ProfileViewTheme.contactSectionSpacing),
              
              // Email
              _buildInfoRow(
                Icons.email,
                'Email',
                profile.emailUsuario,
                ProfileViewTheme.emailColor,
              ),
              
              SizedBox(height: ProfileViewTheme.contactInfoSpacing),
              
              // Teléfono
              _buildInfoRow(
                Icons.phone,
                'Teléfono',
                profile.formattedPhone,
                profile.hasPhone ? ProfileViewTheme.phoneColor : ProfileViewTheme.phoneDisabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card con información de rol y estado
  Widget _buildRoleStatusCard(Profile profile) {
    return Card(
      elevation: ProfileViewTheme.roleCardElevation,
      shape: ProfileViewTheme.roleCardShape,
      child: Container(
        decoration: ProfileViewTheme.roleCardDecoration,
        child: Padding(
          padding: ProfileViewTheme.roleCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: ProfileViewTheme.roleHeaderColor,
                    size: ProfileViewTheme.roleHeaderIconSize,
                  ),
                  SizedBox(width: ProfileViewTheme.roleHeaderSpacing),
                  Text(
                    'ROL Y PERMISOS',
                    style: ProfileViewTheme.roleHeaderStyle,
                  ),
                ],
              ),
              
              SizedBox(height: ProfileViewTheme.roleSectionSpacing),
              
              // Rol
              _buildInfoRow(
                _getRoleIcon(profile.rolUsuario),
                'Rol',
                profile.roleDescription,
                _getRoleColor(profile.rolUsuario),
              ),
              
              SizedBox(height: ProfileViewTheme.roleInfoSpacing),
              
              // Permisos
              _buildPermissionsSection(profile),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar filas de información
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: ProfileViewTheme.infoRowPadding,
      decoration: ProfileViewTheme.infoRowDecoration(color),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: ProfileViewTheme.infoRowIconSize,
          ),
          SizedBox(width: ProfileViewTheme.infoRowIconSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ProfileViewTheme.infoRowLabelStyle,
                ),
                SizedBox(height: ProfileViewTheme.infoRowLabelSpacing),
                Text(
                  value,
                  style: ProfileViewTheme.infoRowValueStyle.copyWith(
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
          style: ProfileViewTheme.permissionLabelStyle,
        ),
        SizedBox(height: ProfileViewTheme.permissionSpacing),
        Wrap(
          spacing: ProfileViewTheme.permissionSpacing,
          runSpacing: ProfileViewTheme.permissionSpacing,
          children: permissions.map((permission) {
            return Container(
              padding: ProfileViewTheme.permissionChipPadding,
              decoration: ProfileViewTheme.permissionChipDecoration,
              child: Text(
                permission,
                style: ProfileViewTheme.permissionChipTextStyle,
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
                SnackBar(
                  content: const Text('Edición de perfil próximamente'),
                  backgroundColor: ProfileViewTheme.primaryOrangeShade600,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: Text('Editar Perfil', style: ProfileViewTheme.primaryButtonTextStyle),
            style: ProfileViewTheme.primaryButtonStyle,
          ),
        ),
        
        SizedBox(height: ProfileViewTheme.buttonSpacing),
        
        // Botón para cambiar contraseña
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cambio de contraseña próximamente'),
                  backgroundColor: ProfileViewTheme.primaryOrangeShade600,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.lock),
            label: Text('Cambiar Contraseña', style: ProfileViewTheme.secondaryButtonTextStyle),
            style: ProfileViewTheme.secondaryButtonStyle,
          ),
        ),
      ],
    );
  }

  // Vista de error
  Widget _buildErrorView(Object? error) {
    return Center(
      child: Padding(
        padding: ProfileViewTheme.errorPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ProfileViewTheme.errorIconSize,
              color: ProfileViewTheme.errorIconColor,
            ),
            SizedBox(height: ProfileViewTheme.errorSpacing),
            Text(
              'Error al cargar el perfil',
              style: ProfileViewTheme.errorTitleStyle,
            ),
            SizedBox(height: ProfileViewTheme.errorDescriptionSpacing),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: ProfileViewTheme.errorDescriptionStyle,
            ),
            SizedBox(height: ProfileViewTheme.errorButtonSpacing),
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
                backgroundColor: ProfileViewTheme.primaryButtonColor,
                foregroundColor: ProfileViewTheme.primaryButtonTextColor,
                padding: ProfileViewTheme.errorButtonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ProfileViewTheme.buttonBorderRadius),
                ),
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
        return ProfileViewTheme.adminRoleColor;
      case 'MANAGER':
        return ProfileViewTheme.managerRoleColor;
      case 'WAITER':
        return ProfileViewTheme.waiterRoleColor;
      case 'CHEF':
        return ProfileViewTheme.chefRoleColor;
      case 'CUSTOMER':
      case 'USER':
        return ProfileViewTheme.customerRoleColor;
      default:
        return ProfileViewTheme.defaultRoleColor;
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
        return ProfileViewTheme.activeStatusColor;
      case 'INACTIVO':
        return ProfileViewTheme.inactiveStatusColor;
      case 'SUSPENDIDO':
        return ProfileViewTheme.suspendedStatusColor;
      case 'BLOQUEADO':
        return ProfileViewTheme.blockedStatusColor;
      default:
        return ProfileViewTheme.defaultStatusColor;
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
