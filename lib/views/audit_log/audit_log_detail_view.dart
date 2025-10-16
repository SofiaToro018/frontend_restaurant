import 'package:flutter/material.dart';

import '../../models/audit_log.dart';
import '../../services/audit_log_service.dart';

class AuditLogDetailView extends StatefulWidget {
  final String auditLogId;

  const AuditLogDetailView({super.key, required this.auditLogId});

  @override
  State<AuditLogDetailView> createState() => _AuditLogDetailViewState();
}

class _AuditLogDetailViewState extends State<AuditLogDetailView> {
  // Se crea una instancia de la clase AuditLogService
  final AuditLogService _auditLogService = AuditLogService();
  // Se declara una variable de tipo Future que contendrá el detalle del Registro de Cambios
  late Future<AuditLog> _futureAuditLog;

  @override
  void initState() {
    super.initState();
    // Se llama al método getAuditLogById de la clase AuditLogService
    _futureAuditLog = _auditLogService.getAuditLogById(int.parse(widget.auditLogId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro #${widget.auditLogId}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      //* se usa future builder para construir widgets basados en un Future
      body: FutureBuilder<AuditLog>(
        future: _futureAuditLog,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final auditLog = snapshot.data!; // Se obtiene el detalle del Registro de Cambios
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Card principal con información del registro
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icono grande del tipo de cambio
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _getChangeTypeColor(auditLog.tipCambio),
                              borderRadius: BorderRadius.circular(50.0),
                              boxShadow: [
                                BoxShadow(
                                  color: _getChangeTypeColor(auditLog.tipCambio).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              _getChangeTypeIcon(auditLog.tipCambio),
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tipo de cambio
                          Text(
                            auditLog.changeTypeDescription.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // ID del registro
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: _getChangeTypeColor(auditLog.tipCambio).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _getChangeTypeColor(auditLog.tipCambio),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'REGISTRO #${auditLog.id}',
                              style: TextStyle(
                                fontSize: 14,
                                color: _getChangeTypeColor(auditLog.tipCambio),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Información del usuario
                          _buildInfoRow(
                            Icons.person,
                            'Usuario',
                            'Usuario #${auditLog.usuarioId}',
                            Colors.blue,
                          ),
                          const SizedBox(height: 16),

                          // Fecha del cambio
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Fecha',
                            auditLog.formattedDate,
                            Colors.green,
                          ),
                          const SizedBox(height: 16),

                          // Hora del cambio
                          _buildInfoRow(
                            Icons.access_time,
                            'Hora',
                            auditLog.formattedTime,
                            Colors.purple,
                          ),
                          const SizedBox(height: 24),

                          // Regla afectada
                          _buildAffectedRuleSection(auditLog),
                          
                          const SizedBox(height: 24),

                          // Información adicional según el tiempo
                          _buildTimeInfo(auditLog),
                        ],
                      ),
                    ),
                  ),
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

  // Widget para construir filas de información
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
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
                    fontSize: 16,
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

  // Widget para mostrar la regla afectada
  Widget _buildAffectedRuleSection(AuditLog auditLog) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getChangeTypeColor(auditLog.tipCambio).withValues(alpha: 0.1),
            _getChangeTypeColor(auditLog.tipCambio).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _getChangeTypeColor(auditLog.tipCambio).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: _getChangeTypeColor(auditLog.tipCambio),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'REGLA AFECTADA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getChangeTypeColor(auditLog.tipCambio),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            auditLog.reglaAfectada,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar información de tiempo
  Widget _buildTimeInfo(AuditLog auditLog) {
    String message;
    Color messageColor;
    IconData messageIcon;

    if (auditLog.isToday) {
      message = 'Este cambio se realizó hoy';
      messageColor = Colors.green;
      messageIcon = Icons.today;
    } else if (auditLog.isRecent) {
      final hours = DateTime.now().difference(auditLog.fechCambio).inHours;
      message = 'Cambio reciente - hace $hours horas';
      messageColor = Colors.orange;
      messageIcon = Icons.schedule;
    } else if (auditLog.isThisWeek) {
      message = 'Cambio realizado esta semana';
      messageColor = Colors.blue;
      messageIcon = Icons.date_range;
    } else {
      final days = DateTime.now().difference(auditLog.fechCambio).inDays;
      message = 'Cambio realizado hace $days días';
      messageColor = Colors.grey;
      messageIcon = Icons.history;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: messageColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            messageIcon,
            color: messageColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: messageColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
              'Error al cargar el registro',
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
                  _futureAuditLog = _auditLogService.getAuditLogById(int.parse(widget.auditLogId));
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

  // Método para obtener el color según el tipo de cambio
  Color _getChangeTypeColor(String changeType) {
    switch (changeType.toUpperCase()) {
      case 'ACTUALIZACION_PRECIO':
        return Colors.orange;
      case 'NUEVA_CATEGORIA':
        return Colors.green;
      case 'CAMBIO_ESTADO_MESA':
        return Colors.blue;
      case 'CREACION_ITEM':
        return Colors.purple;
      case 'ELIMINACION_ITEM':
        return Colors.red;
      case 'MODIFICACION_RESERVA':
        return Colors.teal;
      case 'CAMBIO_CONFIGURACION':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el icono según el tipo de cambio
  IconData _getChangeTypeIcon(String changeType) {
    switch (changeType.toUpperCase()) {
      case 'ACTUALIZACION_PRECIO':
        return Icons.attach_money;
      case 'NUEVA_CATEGORIA':
        return Icons.add_circle;
      case 'CAMBIO_ESTADO_MESA':
        return Icons.table_restaurant;
      case 'CREACION_ITEM':
        return Icons.restaurant;
      case 'ELIMINACION_ITEM':
        return Icons.delete;
      case 'MODIFICACION_RESERVA':
        return Icons.event_note;
      case 'CAMBIO_CONFIGURACION':
        return Icons.settings;
      default:
        return Icons.history;
    }
  }
}
