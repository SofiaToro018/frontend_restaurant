import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/table.dart' as table_model;

class TableFormViewAdmin extends StatefulWidget {
  final table_model.Table? table;
  final Function(
    String codMesa,
    int numSillas,
    bool estMesa,
  ) onSave;
  final bool isLoading;

  const TableFormViewAdmin({
    super.key,
    this.table,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<TableFormViewAdmin> createState() => _TableFormViewAdminState();
}

class _TableFormViewAdminState extends State<TableFormViewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _codMesaController = TextEditingController();
  final _numSillasController = TextEditingController();
  
  bool _estMesa = true;

  @override
  void initState() {
    super.initState();
    if (widget.table != null) {
      _codMesaController.text = widget.table!.codMesa;
      _numSillasController.text = widget.table!.numSillas.toString();
      _estMesa = widget.table!.estMesa;
    }
  }

  @override
  void dispose() {
    _codMesaController.dispose();
    _numSillasController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final codMesa = _codMesaController.text.trim();
      final numSillas = int.parse(_numSillasController.text);

      widget.onSave(
        codMesa,
        numSillas,
        _estMesa,
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
                      const Icon(Icons.table_restaurant, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.table == null ? 'Nueva Mesa' : 'Editar Mesa #${widget.table!.id}',
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
                    widget.table == null 
                        ? 'Completa la información de la mesa'
                        : 'Modifica la información de la mesa',
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
                    // Código de Mesa (Obligatorio)
                    const Text(
                      'Código de Mesa *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _codMesaController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el código de la mesa (ej: MESA-001)',
                        prefixIcon: const Icon(Icons.table_restaurant),
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
                          return 'El código de mesa es obligatorio';
                        }
                        if (value.trim().length < 2) {
                          return 'El código debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Número de Sillas (Obligatorio)
                    const Text(
                      'Número de Sillas *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _numSillasController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ingresa la capacidad de personas',
                        prefixIcon: const Icon(Icons.chair),
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
                          return 'El número de sillas es obligatorio';
                        }
                        final numSillas = int.tryParse(value);
                        if (numSillas == null) {
                          return 'Ingresa un número válido';
                        }
                        if (numSillas <= 0) {
                          return 'Debe ser un número positivo';
                        }
                        if (numSillas > 20) {
                          return 'Máximo 20 sillas por mesa';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Estado de la Mesa
                    const Text(
                      'Estado de la Mesa *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _estMesa ? Icons.check_circle : Icons.block,
                            color: _estMesa ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _estMesa ? 'Disponible' : 'Ocupada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _estMesa ? Colors.green : Colors.red,
                                  ),
                                ),
                                Text(
                                  _estMesa 
                                    ? 'La mesa está disponible para reservas'
                                    : 'La mesa está ocupada',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _estMesa,
                            onChanged: (bool value) {
                              setState(() {
                                _estMesa = value;
                              });
                            },
                            activeTrackColor: const Color(0xFF2E7D32),
                            activeThumbColor: Colors.white,
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
                                    widget.table == null ? 'Crear Mesa' : 'Actualizar Mesa',
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