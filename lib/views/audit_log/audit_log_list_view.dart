import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/audit_log.dart';
import '../../services/audit_log_service.dart';
import '../../widgets/base_view.dart';

class AuditLogListView extends StatefulWidget {
  const AuditLogListView({super.key});

  @override
  State<AuditLogListView> createState() => _AuditLogListViewState();
}

class _AuditLogListViewState extends State<AuditLogListView> {
  //* Se crea una instancia de la clase AuditLogService
  final AuditLogService _auditLogService = AuditLogService();
  //* Se declara una variable de tipo Future que contendrá la lista de Registros de Cambios
  late Future<List<AuditLog>> _futureAuditLogs;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getAuditLogsByUser de la clase AuditLogService
    // Obtener registros del usuario por defecto del .env
    final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
    _futureAuditLogs = _auditLogService.getAuditLogsByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Registro de Cambios',
      //! Se crea un FutureBuilder que se encargará de construir la lista de Registros de Cambios
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<AuditLog>>(
        future: _futureAuditLogs,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de Registros de Cambios
            final auditLogs = snapshot.data!;
            
            if (auditLogs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay registros de cambios',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: auditLogs.length,
              itemBuilder: (context, index) {
                final auditLog = auditLogs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  //* gestureDetector se utiliza para detectar gestos del usuario
                  //* en este caso se utiliza para navegar a la vista de detalle del Registro de Cambios
                  child: GestureDetector(
                    onTap: () {
                      context.push('/audit-log/${auditLog.id}');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Icono del tipo de cambio
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getChangeTypeColor(auditLog.tipCambio),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                _getChangeTypeIcon(auditLog.tipCambio),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tipo de cambio
                                  Text(
                                    auditLog.changeTypeDescription.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Regla afectada
                                  Text(
                                    auditLog.reglaAfectada,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Fecha del cambio
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        auditLog.formattedDateTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Indicador de tiempo
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTimeIndicatorColor(auditLog).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      _getTimeIndicator(auditLog),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getTimeIndicatorColor(auditLog),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar registros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
                        _futureAuditLogs = _auditLogService.getAuditLogsByUser(userId);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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

  // Método para obtener el indicador de tiempo
  String _getTimeIndicator(AuditLog auditLog) {
    if (auditLog.isToday) {
      return 'HOY';
    } else if (auditLog.isRecent) {
      final hours = DateTime.now().difference(auditLog.fechCambio).inHours;
      return 'HACE ${hours}H';
    } else if (auditLog.isThisWeek) {
      return 'ESTA SEMANA';
    } else {
      final days = DateTime.now().difference(auditLog.fechCambio).inDays;
      return 'HACE ${days}D';
    }
  }

  // Método para obtener el color del indicador de tiempo
  Color _getTimeIndicatorColor(AuditLog auditLog) {
    if (auditLog.isToday) {
      return Colors.green;
    } else if (auditLog.isRecent) {
      return Colors.orange;
    } else if (auditLog.isThisWeek) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
