import 'package:flutter/material.dart';
import '../../../models/booking.dart';
import '../../../models/table.dart' as model;
import '../../../auth/services/auth_service.dart';
import '../../../services/table_service.dart';

/// Widget reutilizable para el formulario de creación de reservas
/// Recibe un callback [onSubmit] que recibe el objeto Booking
/// y un estado de carga [isSubmitting]
class BookingFormCreateFields extends StatefulWidget {
	final Booking? initial;
	final Function(Booking booking) onSubmit;
	final bool isSubmitting;

	const BookingFormCreateFields({
		super.key,
		this.initial,
		required this.onSubmit,
		this.isSubmitting = false,
	});

	@override
	State<BookingFormCreateFields> createState() => _BookingFormCreateFieldsState();
}

class _BookingFormCreateFieldsState extends State<BookingFormCreateFields> {
	final _formKey = GlobalKey<FormState>();
	final TableService _tableService = TableService();

	late TextEditingController _usuarioController;
	late TextEditingController _estadoController;
	DateTime? _fechaReserva;
	List<model.Table> _availableTables = [];
	model.Table? _selectedTable;
	bool _isLoadingTables = false;

	@override
	void initState() {
		super.initState();
		final usuario = AuthService().currentUsuario;
		_usuarioController = TextEditingController(text: usuario?.id.toString() ?? '');
		_estadoController = TextEditingController(text: widget.initial?.estReserva ?? 'ACTIVA');
		_fechaReserva = widget.initial?.fechReserva;
		_loadAvailableTables();
	}

	/// Cargar las mesas disponibles
	Future<void> _loadAvailableTables() async {
		setState(() {
			_isLoadingTables = true;
		});

		try {
			final tables = await _tableService.getAllTables();
			// Filtrar solo mesas disponibles
			final availableTables = tables.where((table) => table.isAvailable).toList();
			
			setState(() {
				_availableTables = availableTables;
				// Si estamos editando, encontrar la mesa seleccionada
				if (widget.initial != null) {
					try {
						_selectedTable = availableTables.firstWhere(
							(table) => table.id == widget.initial!.mesaId,
						);
					} catch (e) {
						// Si no se encuentra la mesa, seleccionar la primera disponible
						if (availableTables.isNotEmpty) {
							_selectedTable = availableTables.first;
						}
					}
				} else if (availableTables.isNotEmpty) {
					// Para nuevas reservas, seleccionar la primera mesa disponible
					_selectedTable = availableTables.first;
				}
			});
		} catch (e) {
			print('Error cargando mesas: $e');
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(
						content: Text('Error al cargar mesas: ${e.toString()}'),
						backgroundColor: Colors.red,
					),
				);
			}
		} finally {
			setState(() {
				_isLoadingTables = false;
			});
		}
	}

	@override
	void dispose() {
		_usuarioController.dispose();
		_estadoController.dispose();
		super.dispose();
	}

	void _handleSubmit() {
		if (_formKey.currentState!.validate()) {
			if (_selectedTable == null) {
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(
						content: Text('Por favor selecciona una mesa'),
						backgroundColor: Colors.red,
					),
				);
				return;
			}

			final booking = Booking(
				id: widget.initial?.id ?? 0,
				mesaId: _selectedTable!.id,
				usuarioId: int.tryParse(_usuarioController.text.trim()) ?? 0,
				estReserva: _estadoController.text.trim(),
				fechReserva: _fechaReserva ?? DateTime.now(),
			);
			widget.onSubmit(booking);
		}
	}

	/// Widget selector de mesa
	Widget _buildTableSelector() {
		if (_isLoadingTables) {
			return Container(
				padding: const EdgeInsets.all(16),
				decoration: BoxDecoration(
					color: Colors.grey.shade50,
					borderRadius: BorderRadius.circular(12),
					border: Border.all(color: Colors.grey.shade300),
				),
				child: const Row(
					children: [
						SizedBox(
							width: 20,
							height: 20,
							child: CircularProgressIndicator(strokeWidth: 2),
						),
						SizedBox(width: 12),
						Text('Cargando mesas disponibles...'),
					],
				),
			);
		}

		if (_availableTables.isEmpty) {
			return Container(
				padding: const EdgeInsets.all(16),
				decoration: BoxDecoration(
					color: Colors.orange.shade50,
					borderRadius: BorderRadius.circular(12),
					border: Border.all(color: Colors.orange.shade200),
				),
				child: Column(
					children: [
						Row(
							children: [
								Icon(
									Icons.warning_amber,
									color: Colors.orange.shade600,
									size: 20,
								),
								const SizedBox(width: 8),
								Expanded(
									child: Text(
										'No hay mesas disponibles',
										style: TextStyle(
											color: Colors.orange.shade700,
											fontWeight: FontWeight.w600,
										),
									),
								),
							],
						),
						const SizedBox(height: 8),
						Text(
							'Todas las mesas están ocupadas en este momento',
							style: TextStyle(
								color: Colors.orange.shade600,
								fontSize: 12,
							),
						),
					],
				),
			);
		}

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Row(
					children: [
						const Icon(Icons.table_restaurant, color: Colors.grey),
						const SizedBox(width: 12),
						Text(
							'Seleccionar Mesa',
							style: TextStyle(
								color: Colors.grey.shade700,
								fontWeight: FontWeight.w500,
								fontSize: 16,
							),
						),
					],
				),
				const SizedBox(height: 12),
				DropdownButtonFormField<model.Table>(
					initialValue: _selectedTable,
					decoration: InputDecoration(
						contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
						border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: BorderSide(color: Colors.grey.shade300),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: BorderSide(color: Colors.grey.shade300),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF2E7D32)),
						),
						fillColor: Colors.white,
						filled: true,
					),
					items: _availableTables.map((table) {
						return DropdownMenuItem<model.Table>(
							value: table,
							child: Text(
								'${table.codMesa} - ${table.capacityText}',
								style: const TextStyle(fontSize: 14),
								overflow: TextOverflow.ellipsis,
							),
						);
					}).toList(),
					onChanged: widget.isSubmitting ? null : (model.Table? newTable) {
						setState(() {
							_selectedTable = newTable;
						});
					},
					validator: (value) {
						if (value == null) {
							return 'Por favor selecciona una mesa';
						}
						return null;
					},
					hint: const Text('Selecciona una mesa'),
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
			return Form(
				key: _formKey,
				child: ListView(
					padding: const EdgeInsets.all(16),
					children: [
						_buildTableSelector(),
					const SizedBox(height: 16),
					TextFormField(
						controller: _estadoController,
						decoration: const InputDecoration(
							labelText: 'Estado',
							hintText: 'ACTIVA, COMPLETADA, CANCELADA, PENDIENTE',
							prefixIcon: Icon(Icons.info),
							border: OutlineInputBorder(),
						),
						enabled: !widget.isSubmitting,
						validator: (v) {
							if (v == null || v.trim().isEmpty) {
								return 'El estado es obligatorio';
							}
							return null;
						},
					),
					const SizedBox(height: 16),
					ListTile(
						leading: const Icon(Icons.calendar_today),
						title: Text(_fechaReserva != null
								? '${_fechaReserva!.day}/${_fechaReserva!.month}/${_fechaReserva!.year} ${_fechaReserva!.hour.toString().padLeft(2, '0')}:${_fechaReserva!.minute.toString().padLeft(2, '0')}'
								: 'Selecciona fecha y hora'),
						onTap: widget.isSubmitting
								? null
								: () async {
										final pickedDate = await showDatePicker(
											context: context,
											initialDate: _fechaReserva ?? DateTime.now(),
											firstDate: DateTime(2020),
											lastDate: DateTime(2100),
										);
										if (!mounted) return;
										if (pickedDate != null) {
											final pickedTime = await showTimePicker(
												// ignore: use_build_context_synchronously
												context: context,
												initialTime: TimeOfDay.fromDateTime(_fechaReserva ?? DateTime.now()),
											);
											if (!mounted) return;
											if (pickedTime != null) {
												setState(() {
													_fechaReserva = DateTime(
														pickedDate.year,
														pickedDate.month,
														pickedDate.day,
														pickedTime.hour,
														pickedTime.minute,
													);
												});
											}
										}
									},
					),
					const SizedBox(height: 24),
					ElevatedButton(
						onPressed: widget.isSubmitting ? null : _handleSubmit,
						style: ElevatedButton.styleFrom(
							padding: const EdgeInsets.symmetric(vertical: 16),
							backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						child: widget.isSubmitting
								? const SizedBox(
										height: 20,
										width: 20,
										child: CircularProgressIndicator(
											strokeWidth: 2,
											valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
										),
									)
								: const Text('reservar', style: TextStyle(fontSize: 16)),
					),
					const SizedBox(height: 8),
					const Text(
						'* Campos obligatorios',
						style: TextStyle(
							fontSize: 12,
							color: Colors.grey,
							fontStyle: FontStyle.italic,
						),
						textAlign: TextAlign.center,
					),
				],
			),
		);
	}
}
