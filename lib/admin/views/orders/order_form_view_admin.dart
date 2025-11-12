import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/order.dart';

class OrderFormViewAdmin extends StatefulWidget {
  final Order? order;
  final Function(
    int? reservaId,
    int usuarioId,
    String estado,
    double precioTotal,
  ) onSave;
  final bool isLoading;

  const OrderFormViewAdmin({
    super.key,
    this.order,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<OrderFormViewAdmin> createState() => _OrderFormViewAdminState();
}

class _OrderFormViewAdminState extends State<OrderFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _reservaIdController = TextEditingController();
  final _usuarioIdController = TextEditingController();
  final _precioTotalController = TextEditingController();
  
  String _selectedEstado = 'PENDIENTE';
  
  final List<String> _estados = [
    'PENDIENTE',
    'EN_PREPARACION',
    'COMPLETADO',
    'CANCELADO',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _reservaIdController.text = widget.order!.reservaId?.toString() ?? '';
      _usuarioIdController.text = widget.order!.usuarioId.toString();
      _precioTotalController.text = widget.order!.preTotPedido.toString();
      _selectedEstado = widget.order!.estPedido;
    }
  }

  @override
  void dispose() {
    _reservaIdController.dispose();
    _usuarioIdController.dispose();
    _precioTotalController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final reservaId = _reservaIdController.text.isNotEmpty 
          ? int.tryParse(_reservaIdController.text) 
          : null;
      final usuarioId = int.parse(_usuarioIdController.text);
      final precioTotal = double.parse(_precioTotalController.text);

      widget.onSave(
        reservaId,
        usuarioId,
        _selectedEstado,
        precioTotal,
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
                      const Icon(Icons.receipt_long, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.order == null ? 'Nuevo Pedido' : 'Editar Pedido #${widget.order!.id}',
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
                    widget.order == null 
                        ? 'Completa la información del pedido'
                        : 'Modifica la información del pedido',
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
                    // ID de Reserva (Opcional)
                    const Text(
                      'ID de Reserva (Opcional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _reservaIdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ingresa el ID de la reserva',
                        prefixIcon: const Icon(Icons.event_seat),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ID de Usuario (Obligatorio)
                    const Text(
                      'ID de Usuario *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usuarioIdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ingresa el ID del usuario',
                        prefixIcon: const Icon(Icons.person),
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
                          return 'El ID de usuario es obligatorio';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Ingresa un ID válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Estado del Pedido
                    const Text(
                      'Estado del Pedido *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEstado,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                      items: _estados.map((String estado) {
                        String displayName;
                        switch (estado) {
                          case 'PENDIENTE':
                            displayName = 'Pendiente';
                            break;
                          case 'EN_PREPARACION':
                            displayName = 'En Preparación';
                            break;
                          case 'COMPLETADO':
                            displayName = 'Completado';
                            break;
                          case 'CANCELADO':
                            displayName = 'Cancelado';
                            break;
                          default:
                            displayName = estado;
                        }
                        
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(displayName),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedEstado = newValue;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona un estado';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Precio Total
                    const Text(
                      'Precio Total *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _precioTotalController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ingresa el precio total',
                        prefixIcon: const Icon(Icons.attach_money),
                        prefixText: '\$ ',
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
                          return 'El precio total es obligatorio';
                        }
                        final precio = double.tryParse(value);
                        if (precio == null) {
                          return 'Ingresa un precio válido';
                        }
                        if (precio <= 0) {
                          return 'El precio debe ser mayor a 0';
                        }
                        return null;
                      },
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
                                    widget.order == null ? 'Crear Pedido' : 'Actualizar Pedido',
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