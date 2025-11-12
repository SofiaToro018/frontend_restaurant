import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/parking.dart';
import '../../../services/parking_service.dart';
import '../../widgets/base_view_admin.dart';
import 'parking_form_view_admin.dart';

class ParkingEditViewAdmin extends StatefulWidget {
  final String parkingId;

  const ParkingEditViewAdmin({
    super.key,
    required this.parkingId,
  });

  @override
  State<ParkingEditViewAdmin> createState() => _ParkingEditViewAdminState();
}

class _ParkingEditViewAdminState extends State<ParkingEditViewAdmin> {
  final ParkingService _parkingService = ParkingService();
  
  bool _isLoading = false;
  Parking? _parking;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadParking();
  }

  Future<void> _loadParking() async {
    try {
      final parkingId = int.parse(widget.parkingId);
      final parking = await _parkingService.getParkingById(parkingId);
      
      setState(() {
        _parking = parking;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar parqueadero: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(
    String codigo,
    bool disponible,
    int restauranteId,
  ) async {
    if (_parking == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto Parking
      final updatedParking = Parking(
        id: _parking!.id,
        codParqueadero: codigo,
        estParqueadero: disponible,
        restauranteId: restauranteId,
      );

      final result = await _parkingService.updateParkingSpace(updatedParking);

      if (result.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parqueadero actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Retornar true para indicar que se actualizó exitosamente
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar parqueadero: $e'),
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
      title: 'Editar Parqueadero',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _parking == null
                ? const Center(
                    child: Text('No se pudo cargar el parqueadero'),
                  )
                : ParkingFormViewAdmin(
                    parking: _parking,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}