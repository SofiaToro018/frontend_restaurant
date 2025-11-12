import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/parking.dart';

class ParkingFormViewAdmin extends StatefulWidget {
  final Parking? parking;
  final Function(
    String codigo,
    bool disponible,
    int restauranteId,
  ) onSave;
  final bool isLoading;

  const ParkingFormViewAdmin({
    super.key,
    this.parking,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<ParkingFormViewAdmin> createState() => _ParkingFormViewAdminState();
}

class _ParkingFormViewAdminState extends State<ParkingFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  
  bool _disponible = true;

  @override
  void initState() {
    super.initState();
    if (widget.parking != null) {
      _codigoController.text = widget.parking!.codParqueadero;
      _disponible = widget.parking!.estParqueadero;
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final restauranteId = int.parse(dotenv.env['DEFAULT_RESTAURANT_ID'] ?? '1');
      
      widget.onSave(
        _codigoController.text.trim(),
        _disponible,
        restauranteId,
      );
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
                      const Icon(Icons.local_parking, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.parking == null ? 'Nuevo Parqueadero' : 'Editar Parqueadero',
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
                    widget.parking == null 
                        ? 'Crea un nuevo espacio de parqueadero'
                        : 'Modifica la información del parqueadero',
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
                    // Código del Parqueadero
                    const Text(
                      'Código del Parqueadero *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _codigoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Ej: A1, B2, C3',
                        prefixIcon: const Icon(Icons.confirmation_number),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El código del parqueadero es obligatorio';
                        }
                        if (value.trim().length < 2) {
                          return 'El código debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Estado de Disponibilidad
                    const Text(
                      'Estado de Disponibilidad',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _disponible ? Icons.local_parking : Icons.block,
                            color: _disponible ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _disponible ? 'Espacio Disponible' : 'Espacio Ocupado',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _disponible ? Colors.green[700] : Colors.red[700],
                              ),
                            ),
                          ),
                          Switch(
                            value: _disponible,
                            onChanged: (value) {
                              setState(() {
                                _disponible = value;
                              });
                            },
                            activeThumbColor: const Color(0xFF2E7D32),
                            activeTrackColor: const Color(0xFFB2D8B4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Información adicional
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _disponible 
                                  ? 'Este espacio aparecerá como disponible para los clientes'
                                  : 'Este espacio aparecerá como ocupado y no estará disponible',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2E7D32),
                              ),
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
                                    widget.parking == null ? 'Crear Parqueadero' : 'Actualizar Parqueadero',
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