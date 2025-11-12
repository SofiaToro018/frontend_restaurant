import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/table.dart' as table_model;
import '../../../services/table_service.dart';
import '../../widgets/base_view_admin.dart';
import 'table_form_view_admin.dart';

class TableCreateViewAdmin extends StatefulWidget {
  const TableCreateViewAdmin({super.key});

  @override
  State<TableCreateViewAdmin> createState() => _TableCreateViewAdminState();
}

class _TableCreateViewAdminState extends State<TableCreateViewAdmin> {
  final TableService _tableService = TableService();
  bool _isLoading = false;

  Future<void> _handleCreate(
    String codMesa,
    int numSillas,
    bool estMesa,
  ) async {
    setState(() => _isLoading = true);

    try {
      // Crear el objeto Table para la nueva mesa
      final newTable = table_model.Table(
        id: 0, // El ID será asignado por el servidor
        codMesa: codMesa,
        numSillas: numSillas,
        estMesa: estMesa,
        restauranteId: 1, // Valor por defecto
      );

      final createdTable = await _tableService.createTable(newTable);

      if (createdTable.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesa creada exitosamente'),
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
            content: Text('Error al crear mesa: $e'),
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
      title: 'Crear Mesa',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: TableFormViewAdmin(
          onSave: _handleCreate,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}