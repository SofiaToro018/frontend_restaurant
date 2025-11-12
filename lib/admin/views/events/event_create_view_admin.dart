import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/event.dart';
import '../../../services/event_service.dart';
import '../../widgets/base_view_admin.dart';
import 'event_form_view_admin.dart';

class EventCreateViewAdmin extends StatefulWidget {
  const EventCreateViewAdmin({super.key});

  @override
  State<EventCreateViewAdmin> createState() => _EventCreateViewAdminState();
}

class _EventCreateViewAdminState extends State<EventCreateViewAdmin> {
  final EventService _eventService = EventService();
  bool _isLoading = false;

  Future<void> _handleCreate(
    int restaurantId,
    String tipEvento,
  ) async {
    setState(() => _isLoading = true);

    try {
      // Crear el objeto Event para el nuevo evento
      final newEvent = Event(
        id: 0, // El ID será asignado por el servidor
        restaurantId: restaurantId,
        tipEvento: tipEvento,
      );

      final createdEvent = await _eventService.createEvent(newEvent);

      if (createdEvent.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se creó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear evento: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewAdmin(
      title: 'Crear Evento',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: EventFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}