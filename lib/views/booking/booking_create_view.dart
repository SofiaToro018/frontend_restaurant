import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import 'widgets_booking/booking_form_create_fields.dart';

/// Vista para crear una nueva reserva
class BookingCreateView extends StatefulWidget {
  const BookingCreateView({super.key});

  @override
  State<BookingCreateView> createState() => _BookingCreateViewState();
}

class _BookingCreateViewState extends State<BookingCreateView> {
  final _service = BookingService();
  bool _isSubmitting = false;

  Future<void> _handleSubmit(Booking booking) async {
    setState(() => _isSubmitting = true);
    try {
  await _service.createBooking(booking);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Reserva creada correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'X',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva'),
        centerTitle: true,
      ),
      body: BookingFormCreateFields(
        initial: null,
        onSubmit: _handleSubmit,
        isSubmitting: _isSubmitting,
      ),
    );
  }
}
