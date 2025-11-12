import 'package:flutter/material.dart';
import '../../../models/booking.dart';
import '../../../auth/services/auth_service.dart';

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

	late TextEditingController _mesaController;
	late TextEditingController _usuarioController;
	late TextEditingController _estadoController;
	DateTime? _fechaReserva;

	@override
	void initState() {
		super.initState();
		_mesaController = TextEditingController(text: widget.initial?.mesaId.toString() ?? '');
		final usuario = AuthService().currentUsuario;
		_usuarioController = TextEditingController(text: usuario?.id.toString() ?? '');
		_estadoController = TextEditingController(text: widget.initial?.estReserva ?? 'ACTIVA');
		_fechaReserva = widget.initial?.fechReserva;
	}

	@override
	void dispose() {
		_mesaController.dispose();
		_usuarioController.dispose();
		_estadoController.dispose();
		super.dispose();
	}

	void _handleSubmit() {
		if (_formKey.currentState!.validate()) {
			final booking = Booking(
				id: widget.initial?.id ?? 0,
				mesaId: int.tryParse(_mesaController.text.trim()) ?? 0,
				usuarioId: int.tryParse(_usuarioController.text.trim()) ?? 0,
				estReserva: _estadoController.text.trim(),
				fechReserva: _fechaReserva ?? DateTime.now(),
			);
			widget.onSubmit(booking);
		}
	}

	@override
	Widget build(BuildContext context) {
			return Form(
				key: _formKey,
				child: ListView(
					padding: const EdgeInsets.all(16),
					children: [
						TextFormField(
							controller: _mesaController,
							decoration: const InputDecoration(
								labelText: 'Numero de la Mesa',
								icon: Icon(Icons.table_restaurant),
							),
							keyboardType: TextInputType.number,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Ingrese el ID de la mesa';
								}
								return null;
							},
						),
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
