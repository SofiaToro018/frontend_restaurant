/// Modelo para representar un Item del Menú en el detalle del pedido
class OrderItemMenu {
  final int id;
  final String nomItem;
  final double precItem;
  final String descItem;
  final bool estItem;
  final String imgItemMenu;

  // Constructor con atributos requeridos
  OrderItemMenu({
    required this.id,
    required this.nomItem,
    required this.precItem,
    required this.descItem,
    required this.estItem,
    required this.imgItemMenu,
  });

  // Factory para convertir JSON en instancia de OrderItemMenu
  factory OrderItemMenu.fromJson(Map<String, dynamic> json) {
    return OrderItemMenu(
      id: json['id'],
      nomItem: json['nomItem'],
      precItem: (json['precItem'] as num).toDouble(),
      descItem: json['descItem'] ?? '',
      estItem: json['estItem'] ?? true,
      imgItemMenu: json['imgItemMenu'] ?? '',
    );
  }

  // Método para convertir la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomItem': nomItem,
      'precItem': precItem,
      'descItem': descItem,
      'estItem': estItem,
      'imgItemMenu': imgItemMenu,
    };
  }
}

/// Modelo para representar el detalle de un pedido
class OrderDetail {
  final int id;
  final int pedidoId;
  final int itemMenuId;
  final int cantItem;
  final double precUnitario;
  final double subtotal;
  final OrderItemMenu itemsMenu;

  // Constructor con atributos requeridos
  OrderDetail({
    required this.id,
    required this.pedidoId,
    required this.itemMenuId,
    required this.cantItem,
    required this.precUnitario,
    required this.subtotal,
    required this.itemsMenu,
  });

  // Factory para convertir JSON en instancia de OrderDetail
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      pedidoId: json['pedidoId'],
      itemMenuId: json['itemMenuId'],
      cantItem: json['cantItem'],
      precUnitario: (json['precUnitario'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      itemsMenu: OrderItemMenu.fromJson(json['itemsMenu']),
    );
  }

  // Método para convertir la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'itemMenuId': itemMenuId,
      'cantItem': cantItem,
      'precUnitario': precUnitario,
      'subtotal': subtotal,
      'itemsMenu': itemsMenu.toJson(),
    };
  }
}

/// Modelo para representar un pedido (Order) con sus detalles
class Order {
  final int id;
  final int? reservaId;
  final int usuarioId;
  final String estPedido;
  final double preTotPedido;
  final List<OrderDetail> detallesPedido;

  // Constructor con atributos requeridos
  // esto se hace para que al crear una instancia de Order, estos atributos sean obligatorios
  // se usa en el fromJson que es un método que convierte un JSON en una instancia de Order
  Order({
    required this.id,
    this.reservaId,
    required this.usuarioId,
    required this.estPedido,
    required this.preTotPedido,
    required this.detallesPedido,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este método se usa para convertir un JSON en una instancia de Order
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      reservaId: json['reservaId'],
      usuarioId: json['usuarioId'],
      estPedido: json['estPedido'],
      preTotPedido: (json['preTotPedido'] as num).toDouble(),
      // En detallesPedido se guarda la lista de detalles del pedido.
      // Se usa List<OrderDetail>.from para convertir la lista de detalles del JSON en una lista de OrderDetail en Dart
      detallesPedido: List<OrderDetail>.from(
        json['detallesPedido']?.map((detail) => OrderDetail.fromJson(detail)) ?? []
      ),
    );
  }

  // Método para convertir la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservaId': reservaId,
      'usuarioId': usuarioId,
      'estPedido': estPedido,
      'preTotPedido': preTotPedido,
      'detallesPedido': detallesPedido.map((detail) => detail.toJson()).toList(),
    };
  }

  // Métodos de utilidad para facilitar el uso del modelo

  /// Obtiene el número total de items en el pedido
  int get totalItems {
    return detallesPedido.fold(0, (sum, detail) => sum + detail.cantItem);
  }

  /// Verifica si el pedido está pendiente
  bool get isPending {
    return estPedido.toUpperCase() == 'PENDIENTE';
  }

  /// Verifica si el pedido está completado
  bool get isCompleted {
    return estPedido.toUpperCase() == 'COMPLETADO';
  }

  /// Verifica si el pedido está en preparación
  bool get isInProgress {
    return estPedido.toUpperCase() == 'EN_PREPARACION';
  }

  /// Obtiene el color del estado del pedido para la UI
  String get statusColor {
    switch (estPedido.toUpperCase()) {
      case 'PENDIENTE':
        return 'orange';
      case 'EN_PREPARACION':
        return 'blue';
      case 'COMPLETADO':
        return 'green';
      case 'CANCELADO':
        return 'red';
      default:
        return 'grey';
    }
  }

  /// Obtiene una descripción amigable del estado
  String get statusDescription {
    switch (estPedido.toUpperCase()) {
      case 'PENDIENTE':
        return 'Pendiente';
      case 'EN_PREPARACION':
        return 'En Preparación';
      case 'COMPLETADO':
        return 'Completado';
      case 'CANCELADO':
        return 'Cancelado';
      default:
        return estPedido;
    }
  }
}