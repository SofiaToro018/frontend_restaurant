import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/parking.dart';
import '../../../services/parking_service.dart';
import '../../widgets/base_view_admin.dart';
import 'parking_form_view_admin.dart';

class ParkingCreateViewAdmin extends StatefulWidget {
  const ParkingCreateViewAdmin({super.key});

  @override
  State<ParkingCreateViewAdmin> createState() => _ParkingCreateViewAdminState();
}

class _ParkingCreateViewAdminState extends State<ParkingCreateViewAdmin> {
  final ParkingService _parkingService = ParkingService();
  bool _isLoading = false;

  Future<void> _handleCreate(
    String codigo,
    bool disponible,
    int restauranteId,
  ) async {
    setState(() => _isLoading = true);

    try {
      // Crear el objeto Parking para el nuevo parqueadero
      final newParking = Parking(
        id: 0, // El ID será asignado por el servidor
        codParqueadero: codigo,
        estParqueadero: disponible,
        restauranteId: restauranteId,
      );

      final createdParking = await _parkingService.createParkingSpace(newParking);

      if (createdParking.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parqueadero creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se creó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear parqueadero: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewAdmin(
      title: 'Crear Parqueadero',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: ParkingFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}