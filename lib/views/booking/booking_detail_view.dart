import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../services/booking_service.dart';

class BookingDetailView extends StatefulWidget {
  final String bookingId;

  const BookingDetailView({super.key, required this.bookingId});

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
  // Se crea una instancia de la clase BookingService
  final BookingService _bookingService = BookingService();
  // Se declara una variable de tipo Future que contendrá el detalle de la Reserva
  late Future<Booking> _futureBooking;

  @override
  void initState() {
    super.initState();
    // Se llama al método getBookingById de la clase BookingService
    _futureBooking = _bookingService.getBookingById(int.parse(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva #${widget.bookingId}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      //* se usa future builder para construir widgets basados en un Future
      body: FutureBuilder<Booking>(
        future: _futureBooking,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final booking = snapshot.data!; // Se obtiene el detalle de la Reserva
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Card principal con información de la reserva
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icono grande del estado
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.estReserva),
                              borderRadius: BorderRadius.circular(50.0),
                              boxShadow: [
                                BoxShadow(
                                  color: _getStatusColor(booking.estReserva).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              _getStatusIcon(booking.estReserva),
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Número de reserva
                          Text(
                            'RESERVA #${booking.id}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Estado de la reserva
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.estReserva).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _getStatusColor(booking.estReserva),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              booking.statusDescription.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                color: _getStatusColor(booking.estReserva),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Información de la mesa
                          _buildInfoRow(
                            Icons.table_restaurant,
                            'Mesa',
                            'Mesa #${booking.mesaId}',
                            Colors.brown,
                          ),
                          const SizedBox(height: 16),

                          // Información del usuario
                          _buildInfoRow(
                            Icons.person,
                            'Usuario',
                            'Usuario #${booking.usuarioId}',
                            Colors.blue,
                          ),
                          const SizedBox(height: 16),

                          // Fecha de la reserva
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Fecha',
                            booking.formattedDate,
                            Colors.green,
                          ),
                          const SizedBox(height: 16),

                          // Hora de la reserva
                          _buildInfoRow(
                            Icons.access_time,
                            'Hora',
                            booking.formattedTime,
                            Colors.purple,
                          ),
                          const SizedBox(height: 24),

                          // Información adicional según el estado
                          _buildAdditionalInfo(booking),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Widget para construir filas de información
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar información adicional según el estado
  Widget _buildAdditionalInfo(Booking booking) {
    String message;
    Color messageColor;
    IconData messageIcon;

    if (booking.isActive) {
      message = 'Tu reserva está confirmada y activa';
      messageColor = Colors.green;
      messageIcon = Icons.check_circle_outline;
    } else if (booking.isCompleted) {
      message = 'Reserva completada exitosamente';
      messageColor = Colors.blue;
      messageIcon = Icons.celebration;
    } else if (booking.isCancelled) {
      message = 'Esta reserva ha sido cancelada';
      messageColor = Colors.red;
      messageIcon = Icons.cancel_outlined;
    } else if (booking.isPending) {
      message = 'Reserva pendiente de confirmación';
      messageColor = Colors.orange;
      messageIcon = Icons.schedule;
    } else {
      message = 'Estado de reserva desconocido';
      messageColor = Colors.grey;
      messageIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: messageColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            messageIcon,
            color: messageColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: messageColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Vista de error
  Widget _buildErrorView(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar la reserva',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _futureBooking = _bookingService.getBookingById(int.parse(widget.bookingId));
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obtener el color según el estado de la reserva
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVA':
        return Colors.green;
      case 'COMPLETADA':
        return Colors.blue;
      case 'CANCELADA':
        return Colors.red;
      case 'PENDIENTE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Método para obtener el icono según el estado de la reserva
  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVA':
        return Icons.event_available;
      case 'COMPLETADA':
        return Icons.check_circle;
      case 'CANCELADA':
        return Icons.cancel;
      case 'PENDIENTE':
        return Icons.schedule;
      default:
        return Icons.event_seat;
    }
  }
}
