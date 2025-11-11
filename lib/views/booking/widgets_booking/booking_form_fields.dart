import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campos del formulario de reserva
class BookingFormFields extends StatelessWidget {
	final TextEditingController nombreController;
	final TextEditingController fechaController;
	final TextEditingController horaController;
	final TextEditingController personasController;
	final TextEditingController mesaController;
	final TextEditingController comentarioController;
	final bool isEnabled;

	const BookingFormFields({
		super.key,
		required this.nombreController,
		required this.fechaController,
		required this.horaController,
		required this.personasController,
		required this.mesaController,
		required this.comentarioController,
		this.isEnabled = true,
	});

	String? _validateRequired(String? value, String fieldName) {
		if (value == null || value.trim().isEmpty) {
			return '$fieldName es obligatorio';
		}
		return null;
	}

	String? _validatePersonas(String? value) {
		if (value == null || value.trim().isEmpty) return 'Número de personas es obligatorio';
		final n = int.tryParse(value);
		if (n == null || n < 1) return 'Debe ser un número válido (>0)';
		return null;
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				// Nombre cliente
				TextFormField(
					controller: nombreController,
					decoration: const InputDecoration(
						labelText: 'Nombre *',
						hintText: 'Nombre del cliente',
						prefixIcon: Icon(Icons.person),
						border: OutlineInputBorder(),
					),
					textCapitalization: TextCapitalization.words,
					enabled: isEnabled,
					validator: (v) => _validateRequired(v, 'El nombre'),
				),
				const SizedBox(height: 16),

				// Fecha
				TextFormField(
					controller: fechaController,
					decoration: const InputDecoration(
						labelText: 'Fecha *',
						hintText: 'DD/MM/AAAA',
						prefixIcon: Icon(Icons.calendar_today),
						border: OutlineInputBorder(),
					),
					keyboardType: TextInputType.datetime,
					enabled: isEnabled,
					validator: (v) => _validateRequired(v, 'La fecha'),
				),
				const SizedBox(height: 16),

				// Hora
				TextFormField(
					controller: horaController,
					decoration: const InputDecoration(
						labelText: 'Hora *',
						hintText: 'HH:MM',
						prefixIcon: Icon(Icons.access_time),
						border: OutlineInputBorder(),
					),
					keyboardType: TextInputType.datetime,
					enabled: isEnabled,
					validator: (v) => _validateRequired(v, 'La hora'),
				),
				const SizedBox(height: 16),

				// Número de personas
				TextFormField(
					controller: personasController,
					decoration: const InputDecoration(
						labelText: 'Personas *',
						hintText: 'Número de personas',
						prefixIcon: Icon(Icons.group),
						border: OutlineInputBorder(),
					),
					keyboardType: TextInputType.number,
					inputFormatters: [FilteringTextInputFormatter.digitsOnly],
					enabled: isEnabled,
					validator: _validatePersonas,
				),
				const SizedBox(height: 16),

				// Mesa
				TextFormField(
					controller: mesaController,
					decoration: const InputDecoration(
						labelText: 'Mesa',
						hintText: 'Número o código de mesa',
						prefixIcon: Icon(Icons.event_seat),
						border: OutlineInputBorder(),
					),
					enabled: isEnabled,
					validator: (v) => null,
				),
				const SizedBox(height: 16),

				// Comentario
				TextFormField(
					controller: comentarioController,
					decoration: const InputDecoration(
						labelText: 'Comentario',
						hintText: 'Comentario adicional',
						prefixIcon: Icon(Icons.comment),
						border: OutlineInputBorder(),
					),
					maxLines: 2,
					enabled: isEnabled,
					validator: (v) => null,
				),
			],
		);
	}
}
