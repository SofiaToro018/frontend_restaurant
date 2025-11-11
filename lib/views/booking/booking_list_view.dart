import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/base_view.dart';
import '../../themes/category_theme/category_list_view_theme.dart';
import '../../auth/services/auth_service.dart';
import 'booking_create_view.dart';


class BookingListView extends StatefulWidget {
  const BookingListView({super.key});

  @override
  State<BookingListView> createState() => _BookingListViewState();
}

class _BookingListViewState extends State<BookingListView> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _futureBookings;

  void _goToCreate() {
    Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BookingCreateView(),
      ),
    ).then((created) {
      if (created == true) {
        final usuario = AuthService().currentUsuario;
        if (usuario != null) {
          setState(() {
            _futureBookings = _bookingService.getBookingsByUser(usuario.id);
          });
        }
      }
    });
  }
  @override
  void initState() {
    super.initState();
    final usuario = AuthService().currentUsuario;
    if (usuario != null) {
      _futureBookings = _bookingService.getBookingsByUser(usuario.id);
    } else {
      // Si no hay usuario logueado, retorna lista vacía
      _futureBookings = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CategoryListViewTheme.backgroundColor,
        child: BaseView(
          title: 'Mis Reservas',
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _goToCreate,
            icon: const Icon(Icons.add),
            label: const Text('reservar'),
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            tooltip: 'Crear nueva reserva',
          ),
          body: FutureBuilder<List<Booking>>(
          future: _futureBookings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bookings = snapshot.data!;
              final usuario = AuthService().currentUsuario;
              if (usuario == null) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: CategoryListViewTheme.emptyCategoryDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: CategoryListViewTheme.emptyCategoryIconSize,
                          color: CategoryListViewTheme.emptyCategoryIconColor,
                        ),
                        SizedBox(height: CategoryListViewTheme.emptyCategorySpacing),
                        Text(
                          'Debes iniciar sesión para ver tus reservas',
                          style: CategoryListViewTheme.emptyCategoryTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (bookings.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: CategoryListViewTheme.emptyCategoryDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_seat,
                          size: CategoryListViewTheme.emptyCategoryIconSize,
                          color: CategoryListViewTheme.emptyCategoryIconColor,
                        ),
                        SizedBox(height: CategoryListViewTheme.emptyCategorySpacing),
                        Text(
                          'No tienes reservas aún',
                          style: CategoryListViewTheme.emptyCategoryTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: CategoryListViewTheme.listViewPadding,
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/booking/${booking.id}');
                    },
                    child: Container(
                      margin: CategoryListViewTheme.cardMargin,
                      decoration: CategoryListViewTheme.buildCardDecoration(),
                      child: Padding(
                        padding: CategoryListViewTheme.cardPadding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Estado visual
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.estReserva),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(booking.estReserva),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getStatusIcon(booking.estReserva),
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MESA ${booking.mesaId} · Reserva #${booking.id}',
                                    style: CategoryListViewTheme.cardTitleStyle,
                                  ),
                                  SizedBox(height: CategoryListViewTheme.cardInternalSpacing),
                                  Container(
                                    padding: CategoryListViewTheme.cardUnavailablePadding,
                                    margin: CategoryListViewTheme.cardUnavailableMargin,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking.estReserva),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      booking.statusDescription,
                                      style: CategoryListViewTheme.cardUnavailableTextStyle.copyWith(
                                        color: _getStatusColor(booking.estReserva),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    booking.formattedDateTime,
                                    style: CategoryListViewTheme.cardDescriptionStyle.copyWith(
                                      color: CategoryListViewTheme.highlightColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    _getTimeIndicator(booking),
                                    style: CategoryListViewTheme.cardDescriptionStyle.copyWith(
                                      color: CategoryListViewTheme.secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Icon(
                                Icons.chevron_right,
                                color: CategoryListViewTheme.inactiveIconColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: CategoryListViewTheme.emptyCategoryDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: CategoryListViewTheme.emptyCategoryIconSize,
                        color: CategoryListViewTheme.errorIconColor,
                      ),
                      SizedBox(height: CategoryListViewTheme.emptyCategorySpacing),
                      Text(
                        'Error al cargar reservas',
                        style: CategoryListViewTheme.errorTitleStyle,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: CategoryListViewTheme.errorDescriptionStyle,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CategoryListViewTheme.accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVA':
        return CategoryListViewTheme.accentColor;
      case 'COMPLETADA':
        return CategoryListViewTheme.highlightColor;
      case 'CANCELADA':
        return Colors.red[400]!;
      case 'PENDIENTE':
        return Colors.orange[600]!;
      default:
        return CategoryListViewTheme.inactiveIconColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVA':
        return Icons.event_available;
      case 'COMPLETADA':
        return Icons.check_circle_outline;
      case 'CANCELADA':
        return Icons.cancel;
      case 'PENDIENTE':
        return Icons.schedule;
      default:
        return Icons.event_seat;
    }
  }


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
