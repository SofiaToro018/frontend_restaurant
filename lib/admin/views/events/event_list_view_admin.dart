import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/event.dart';
import '../../../services/event_service.dart';
import '../../widgets/base_view_admin.dart';

class EventListViewAdmin extends StatefulWidget {
  const EventListViewAdmin({super.key});

  @override
  State<EventListViewAdmin> createState() => _EventListViewAdminState();
}

class _EventListViewAdminState extends State<EventListViewAdmin> {
  final EventService _eventService = EventService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _futureEvents = _eventService.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseViewAdmin(
      title: 'Gestión de Eventos',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: FutureBuilder<List<Event>>(
          future: _futureEvents,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar eventos',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadEvents,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data ?? [];

            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_outlined,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'No hay eventos',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea tu primer evento presionando el botón +',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(context, event, theme);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/admin/events/create');
          if (result == true) {
            _loadEvents();
          }
        },
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Método helper para obtener color de fondo de la categoría
  Color _getCategoryBackgroundColor(String category) {
    switch (category) {
      case 'Celebración':
        return const Color(0xFFFFF3E0); // Orange[50]
      case 'Corporativo':
        return const Color(0xFFE3F2FD); // Blue[50]
      case 'Matrimonio':
        return const Color(0xFFFCE4EC); // Pink[50]
      case 'Conferencia':
        return const Color(0xFFE8F5E8); // Green[50]
      case 'Reunión':
        return const Color(0xFFF3E5F5); // Purple[50]
      case 'Fiesta':
        return const Color(0xFFFFEBEE); // Red[50]
      default:
        return const Color(0xFFF5F5F5); // Grey[100]
    }
  }

  Widget _buildEventCard(BuildContext context, Event event, ThemeData theme) {
    // Obtener color de la categoría
    Color categoryColor;
    switch (event.eventCategory) {
      case 'Celebración':
        categoryColor = Colors.orange;
        break;
      case 'Corporativo':
        categoryColor = Colors.blue;
        break;
      case 'Matrimonio':
        categoryColor = Colors.pink;
        break;
      case 'Conferencia':
        categoryColor = Colors.green;
        break;
      case 'Reunión':
        categoryColor = Colors.purple;
        break;
      case 'Fiesta':
        categoryColor = Colors.red;
        break;
      default:
        categoryColor = Colors.grey;
    }

    // Obtener icono según el tipo de evento
    IconData eventIcon;
    switch (event.suggestedIcon) {
      case 'cake':
        eventIcon = Icons.cake;
        break;
      case 'favorite':
        eventIcon = Icons.favorite;
        break;
      case 'business':
        eventIcon = Icons.business;
        break;
      case 'mic':
        eventIcon = Icons.mic;
        break;
      case 'groups':
        eventIcon = Icons.groups;
        break;
      case 'celebration':
        eventIcon = Icons.celebration;
        break;
      default:
        eventIcon = Icons.event;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () async {
          final result = await context.push('/admin/events/edit/${event.id}');
          if (result == true) {
            _loadEvents();
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del evento
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.eventTypeCapitalized,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCategoryBackgroundColor(event.eventCategory),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.eventCategory,
                      style: TextStyle(
                        fontSize: 12,
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Información del evento
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.restaurant_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Restaurante ID: ${event.restaurantId}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.category_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Tipo: ${event.tipEvento}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.friendlyDescription,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Icono del evento
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryBackgroundColor(event.eventCategory),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          eventIcon,
                          color: categoryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Evento #${event.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final result = await context.push('/admin/events/edit/${event.id}');
                        if (result == true) {
                          _loadEvents();
                        }
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, event);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Event event) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que deseas eliminar el evento "${event.eventTypeCapitalized}"?\n\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      try {
        await _eventService.deleteEvent(event.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Evento eliminado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _loadEvents();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}