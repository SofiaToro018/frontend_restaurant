/// Utilidades para formatear valores monetarios en pesos colombianos
class CurrencyFormatter {
  /// Formatea un precio en pesos colombianos con separadores de miles
  /// 
  /// Ejemplos:
  /// - 25000 -> "$25.000"
  /// - 1500 -> "$1.500"
  /// - 150000 -> "$150.000" 
  /// - 5000000 -> "$5.000.000"
  static String formatColombianPrice(double price) {
    final priceInt = price.round();
    final priceStr = priceInt.toString();
    
    // Agregar separadores de miles
    String formattedPrice = '';
    int digitCount = 0;
    
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (digitCount > 0 && digitCount % 3 == 0) {
        formattedPrice = '.$formattedPrice';
      }
      formattedPrice = priceStr[i] + formattedPrice;
      digitCount++;
    }
    
    return '\$$formattedPrice';
  }

  /// Formatea un precio con la unidad "c/u" (cada uno)
  static String formatPricePerUnit(double price) {
    return '${formatColombianPrice(price)} c/u';
  }
}