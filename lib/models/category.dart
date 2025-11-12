/// Modelo para representar un item del menú
class ItemMenu {
  int id;
  String nomItem;
  double precItem;
  String descItem;
  bool estItem;
  String imgItemMenu;

  // Constructor de la clase ItemMenu con los atributos requeridos
  ItemMenu({
    required this.id,
    required this.nomItem,
    required this.precItem,
    required this.descItem,
    required this.estItem,
    required this.imgItemMenu,
  });

  // Factory método que convierte un JSON en una instancia de ItemMenu
  factory ItemMenu.fromJson(Map<String, dynamic> json) {
    return ItemMenu(
      id: json['id'],
      nomItem: json['nomItem'],
      precItem: json['precItem'].toDouble(),
      descItem: json['descItem'],
      estItem: json['estItem'],
      imgItemMenu: json['imgItemMenu'],
    );
  }

  // Método para convertir una instancia de ItemMenu a JSON
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

/// Modelo para representar una categoría del menú con sus items
class Category {
  int id;
  String nombre;
  String imgCatMenu;
  List<ItemMenu> itemsMenu;

  // Constructor de la clase Category con los atributos requeridos
  Category({
    required this.id,
    required this.nombre,
    required this.imgCatMenu,
    required this.itemsMenu,
  });

  // Factory método que convierte un JSON en una instancia de Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      imgCatMenu: json['imgCatMenu'],
      // Convertimos la lista de itemsMenu del JSON en una lista de objetos ItemMenu
      itemsMenu: List<ItemMenu>.from(
        json['itemsMenu'].map((item) => ItemMenu.fromJson(item))
      ),
    );
  }

  // Método para convertir una instancia de Category a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imgCatMenu': imgCatMenu,
      'itemsMenu': itemsMenu.map((item) => item.toJson()).toList(),
    };
  }
}