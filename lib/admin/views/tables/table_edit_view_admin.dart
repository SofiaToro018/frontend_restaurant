import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/table.dart' as table_model;
import '../../../services/table_service.dart';
import '../../widgets/base_view_admin.dart';
import 'table_form_view_admin.dart';

class TableEditViewAdmin extends StatefulWidget {
  final String tableId;

  const TableEditViewAdmin({
    super.key,
    required this.tableId,
  });

  @override
  State<TableEditViewAdmin> createState() => _TableEditViewAdminState();
}

class _TableEditViewAdminState extends State<TableEditViewAdmin> {
  final TableService _tableService = TableService();
  
  bool _isLoading = false;
  table_model.Table? _table;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadTable();
  }

  Future<void> _loadTable() async {
    try {
      final tableId = int.parse(widget.tableId);
      final table = await _tableService.getTableById(tableId);
      
      setState(() {
        _table = table;
        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar mesa: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    }
  }

  Future<void> _handleUpdate(
    String codMesa,
    int numSillas,
    bool estMesa,
  ) async {
    if (_table == null) return;

    setState(() => _isLoading = true);

    try {
      // Actualizar el objeto Table
      final updatedTable = table_model.Table(
        id: _table!.id,
        codMesa: codMesa,
        numSillas: numSillas,
        estMesa: estMesa,
        restauranteId: _table!.restauranteId, // Mantener el restaurante existente
      );

      final result = await _tableService.updateTable(updatedTable);

      if (result.id > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesa actualizada exitosamente'),
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
            content: Text('Error al actualizar mesa: $e'),
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
      title: 'Editar Mesa',
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : _table == null
                ? const Center(
                    child: Text('No se pudo cargar la mesa'),
                  )
                : TableFormViewAdmin(
                    table: _table,
                    onSave: _handleUpdate,
                    isLoading: _isLoading,
                  ),
      ),
    );
  }
}