import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/base_view.dart';

class BookingListView extends StatefulWidget {
  const BookingListView({super.key});

  @override
  State<BookingListView> createState() => _BookingListViewState();
}

class _BookingListViewState extends State<BookingListView> {
  //* Se crea una instancia de la clase BookingService
  final BookingService _bookingService = BookingService();
  //* Se declara una variable de tipo Future que contendrá la lista de Reservas
  late Future<List<Booking>> _futureBookings;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getBookingsByUser de la clase BookingService
    // Obtener reservas del usuario por defecto del .env
    final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
    _futureBookings = _bookingService.getBookingsByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Mis Reservas',
      //! Se crea un FutureBuilder que se encargará de construir la lista de Reservas
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<Booking>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de Reservas
            final bookings = snapshot.data!;
            
            if (bookings.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tienes reservas aún',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  //* gestureDetector se utiliza para detectar gestos del usuario
                  //* en este caso se utiliza para navegar a la vista de detalle de la Reserva
                  child: GestureDetector(
                    onTap: () {
                      context.push('/booking/${booking.id}');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Icono del estado de la reserva
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.estReserva),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                _getStatusIcon(booking.estReserva),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Mesa y número de reserva
                                  Text(
                                    'MESA ${booking.mesaId} - Reserva #${booking.id}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Estado de la reserva
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking.estReserva).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      booking.statusDescription,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getStatusColor(booking.estReserva),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Fecha de la reserva
                                  Text(
                                    booking.formattedDateTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Indicador de tiempo
                                  Text(
                                    _getTimeIndicator(booking),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar reservas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final userId = int.parse(dotenv.env['DEFAULT_USER_ID'] ?? '1');
                        _futureBookings = _bookingService.getBookingsByUser(userId);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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

  // Método para obtener el indicador de tiempo
  String _getTimeIndicator(Booking booking) {
    if (booking.isToday) {
      return 'Hoy';
    } else if (booking.isFuture) {
      final daysDiff = booking.fechReserva.difference(DateTime.now()).inDays;
      if (daysDiff == 1) {
        return 'Mañana';
      } else {
        return 'En $daysDiff días';
      }
    } else {
      final daysDiff = DateTime.now().difference(booking.fechReserva).inDays;
      return 'Hace $daysDiff días';
    }
  }
}
