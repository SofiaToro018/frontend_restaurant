import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/booking.dart';
import '../../services/booking_service.dart';

class BookingEditView extends StatefulWidget {
	final int id;

	const BookingEditView({super.key, required this.id});

	@override
	State<BookingEditView> createState() => _BookingEditViewState();
}

class _BookingEditViewState extends State<BookingEditView> {
	final _service = BookingService();

	bool _isLoading = true;
	bool _isSubmitting = false;
	Booking? _booking;

	final _mesaCtrl = TextEditingController();
	final _estadoCtrl = TextEditingController();
	DateTime? _fechaReserva;

	final _formKey = GlobalKey<FormState>();

	@override
	void initState() {
		super.initState();
		_loadBooking();
	}

	@override
	void dispose() {
		_mesaCtrl.dispose();
		_estadoCtrl.dispose();
		super.dispose();
	}

	// ...existing code...

				Future<void> _loadBooking() async {
					try {
						final b = await _service.getBookingById(widget.id);
						if (!mounted) return;
						setState(() {
							_booking = b;
							_isLoading = false;
							_mesaCtrl.text = b.mesaId.toString();
							_estadoCtrl.text = b.estReserva;
							_fechaReserva = b.fechReserva;
						});
					} catch (e) {
						if (!mounted) return;
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text('❌ Error al cargar reserva: $e')),
						);
						context.pop();
					}
				}

				Future<void> _handleSubmit() async {
					if (!_formKey.currentState!.validate()) return;
					if (_booking == null) return;

					setState(() => _isSubmitting = true);

					final updated = Booking(
						id: _booking!.id,
						mesaId: int.tryParse(_mesaCtrl.text.trim()) ?? _booking!.mesaId,
						usuarioId: _booking!.usuarioId,
						estReserva: _estadoCtrl.text.trim(),
						fechReserva: _fechaReserva ?? _booking!.fechReserva,
					);

					try {
						await _service.updateBooking(updated);
						if (!mounted) return;
						ScaffoldMessenger.of(context).showSnackBar(
							const SnackBar(content: Text('✅ Reserva actualizada'), backgroundColor: Colors.green),
						);
						context.pop(true);
					} catch (e) {
						if (!mounted) return;
						String errorMessage = e.toString();
						if (errorMessage.startsWith('Exception: ')) errorMessage = errorMessage.substring(11);
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text('❌ $errorMessage'), backgroundColor: Colors.red),
						);
					} finally {
						if (mounted) setState(() => _isSubmitting = false);
					}
				}

				@override
				Widget build(BuildContext context) {
					return Scaffold(
						appBar: AppBar(title: const Text('Editar Reserva'), centerTitle: true),
						body: _isLoading
								? const Center(child: CircularProgressIndicator())
								: Padding(
										padding: const EdgeInsets.all(16.0),
										child: Form(
											key: _formKey,
											child: Column(
												children: [
													Expanded(
														child: SingleChildScrollView(
															child: Column(
																children: [
																	TextFormField(
																		controller: _mesaCtrl,
																		decoration: const InputDecoration(
																			labelText: 'Mesa',
																			hintText: 'Número de mesa',
																			prefixIcon: Icon(Icons.event_seat),
																			border: OutlineInputBorder(),
																		),
																		keyboardType: TextInputType.number,
																		validator: (v) {
																			if (v == null || v.trim().isEmpty) {
																				return 'La mesa es obligatoria';
																			}
																			if (int.tryParse(v) == null) {
																				return 'Debe ser un número válido';
																			}
																			return null;
																		},
																	),
																	const SizedBox(height: 16),
																	TextFormField(
																		controller: _estadoCtrl,
																		decoration: const InputDecoration(
																			labelText: 'Estado',
																			hintText: 'Ej. ACTIVA, COMPLETADA, CANCELADA, PENDIENTE',
																			prefixIcon: Icon(Icons.info),
																			border: OutlineInputBorder(),
																		),
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
																			onTap: () async {
																				final dialogContext = context;
																				final pickedDate = await showDatePicker(
																					context: dialogContext,
																					initialDate: _fechaReserva ?? DateTime.now(),
																					firstDate: DateTime(2020),
																					lastDate: DateTime(2100),
																				);
																				if (!mounted) return;
																				if (pickedDate != null) {
																					final pickedTime = await showTimePicker(
																						// ignore: use_build_context_synchronously
																						context: dialogContext,
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
																],
															),
														),
													),
													const SizedBox(height: 12),
													SizedBox(
														width: double.infinity,
														child: ElevatedButton(
															onPressed: _isSubmitting ? null : _handleSubmit,
															child: _isSubmitting ? const CircularProgressIndicator() : const Text('Guardar cambios'),
														),
													),
												],
											),
										),
									),
					);
				}
			}
