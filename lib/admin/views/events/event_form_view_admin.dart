import 'package:flutter/material.dart';
import '../../../models/event.dart';

class EventFormViewAdmin extends StatefulWidget {
  final Event? event;
  final Function(
    int restaurantId,
    String tipEvento,
  ) onSave;
  final bool isLoading;

  const EventFormViewAdmin({
    super.key,
    this.event,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<EventFormViewAdmin> createState() => _EventFormViewAdminState();
}

class _EventFormViewAdminState extends State<EventFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantIdController = TextEditingController();
  final _tipEventoController = TextEditingController();
  
  String _selectedEventType = 'CUMPLEANOS';
  
  final List<String> _eventTypes = [
    'CUMPLEANOS',
    'BODAS',
    'EVENTO_CORPORATIVO',
    'CONFERENCIA',
    'REUNION_NEGOCIOS',
    'FIESTA_PRIVADA',
    'CELEBRACION_FAMILIAR',
    'LANZAMIENTO_PRODUCTO',
    'NETWORKING',
    'CAPACITACION',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _restaurantIdController.text = widget.event!.restaurantId.toString();
      _tipEventoController.text = widget.event!.tipEvento;
      _selectedEventType = widget.event!.tipEvento;
    } else {
      _restaurantIdController.text = '1'; // Valor por defecto
    }
  }

  @override
  void dispose() {
    _restaurantIdController.dispose();
    _tipEventoController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final restaurantId = int.parse(_restaurantIdController.text);
      final tipEvento = _selectedEventType;

      widget.onSave(
        restaurantId,
        tipEvento,
      );
    }
  }

  String _getEventTypeDisplayName(String eventType) {
    switch (eventType) {
      case 'CUMPLEANOS':
        return 'Cumpleaños';
      case 'BODAS':
        return 'Bodas';
      case 'EVENTO_CORPORATIVO':
        return 'Evento Corporativo';
      case 'CONFERENCIA':
        return 'Conferencia';
      case 'REUNION_NEGOCIOS':
        return 'Reunión de Negocios';
      case 'FIESTA_PRIVADA':
        return 'Fiesta Privada';
      case 'CELEBRACION_FAMILIAR':
        return 'Celebración Familiar';
      case 'LANZAMIENTO_PRODUCTO':
        return 'Lanzamiento de Producto';
      case 'NETWORKING':
        return 'Networking';
      case 'CAPACITACION':
        return 'Capacitación';
      default:
        return eventType;
    }
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType) {
      case 'CUMPLEANOS':
        return Icons.cake;
      case 'BODAS':
        return Icons.favorite;
      case 'EVENTO_CORPORATIVO':
        return Icons.business;
      case 'CONFERENCIA':
        return Icons.mic;
      case 'REUNION_NEGOCIOS':
        return Icons.groups;
      case 'FIESTA_PRIVADA':
        return Icons.celebration;
      case 'CELEBRACION_FAMILIAR':
        return Icons.family_restroom;
      case 'LANZAMIENTO_PRODUCTO':
        return Icons.launch;
      case 'NETWORKING':
        return Icons.connect_without_contact;
      case 'CAPACITACION':
        return Icons.school;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.event == null ? 'Nuevo Evento' : 'Editar Evento #${widget.event!.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event == null 
                        ? 'Completa la información del evento'
                        : 'Modifica la información del evento',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xE6FFFFFF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Formulario
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID del Restaurante (Obligatorio)
                    const Text(
                      'ID del Restaurante *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _restaurantIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el ID del restaurante',
                        prefixIcon: const Icon(Icons.restaurant),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El ID del restaurante es obligatorio';
                        }
                        final restaurantId = int.tryParse(value);
                        if (restaurantId == null) {
                          return 'Ingresa un ID válido';
                        }
                        if (restaurantId <= 0) {
                          return 'El ID debe ser un número positivo';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tipo de Evento
                    const Text(
                      'Tipo de Evento *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEventType,
                      decoration: InputDecoration(
                        prefixIcon: Icon(_getEventIcon(_selectedEventType)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                      items: _eventTypes.map((String eventType) {
                        return DropdownMenuItem<String>(
                          value: eventType,
                          child: Row(
                            children: [
                              Icon(
                                _getEventIcon(eventType),
                                size: 20,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(_getEventTypeDisplayName(eventType)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedEventType = newValue;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona un tipo de evento';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Información del evento seleccionado
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getEventIcon(_selectedEventType),
                                color: const Color(0xFF2E7D32),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Vista previa del evento',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tipo: ${_getEventTypeDisplayName(_selectedEventType)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Código: $_selectedEventType',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: widget.isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Guardando...'),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.save),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.event == null ? 'Crear Evento' : 'Actualizar Evento',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}