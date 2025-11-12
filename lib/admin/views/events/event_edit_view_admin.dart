import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/event.dart';
import '../../../services/event_service.dart';
import '../../widgets/base_view_admin.dart';
import 'event_form_view_admin.dart';

class EventEditViewAdmin extends StatefulWidget {
  final String eventId;

  const EventEditViewAdmin({
    super.key,
    required this.eventId,
  });

  @override
  State<EventEditViewAdmin> createState() => _EventEditViewAdminState();
}

class _EventEditViewAdminState extends State<EventEditViewAdmin> {
  final EventService _eventService = EventService();
  
  bool _isLoading = false;
  Event? _event;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final eventId = int.parse(widget.eventId);
      final event = await _eventService.getEventById(eventId);
      
      setState(() {
        _event = event;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar evento: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(
    int restaurantId,
    String tipEvento,
  ) async {
    if (_event == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto Event
      final updatedEvent = Event(
        id: _event!.id,
        restaurantId: restaurantId,
        tipEvento: tipEvento,
      );

      final result = await _eventService.updateEvent(updatedEvent);

      if (result.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se actualizó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar evento: $e'),
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
      title: 'Editar Evento',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _event == null
                ? const Center(
                    child: Text('No se pudo cargar el evento'),
                  )
                : EventFormViewAdmin(
                    event: _event,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}