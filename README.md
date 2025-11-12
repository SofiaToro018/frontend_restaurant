# 🍽️ Frontend Restaurant - Aplicación de Menú Digital

Una aplicación Flutter moderna para gestionar y visualizar el menú de un restaurante, conectada a una API REST para consumir datos de categorías e items del menú.

## 📱 Capturas de Pantalla

_Próximamente: Screenshots de la aplicación_

## ✨ Características Principales

### 🏠 Navegación Intuitiva
- **Vista principal de categorías**: Visualización de todas las categorías del menú con scroll horizontal de items
- **Detalle de categorías**: Lista completa de items por categoría específica
- **Detalle de items**: Información completa de cada producto del menú

### 🎨 Diseño Moderno
- **Interfaz Material Design**: Siguiendo las mejores prácticas de Flutter
- **Gradientes y animaciones**: Experiencia visual atractiva
- **Responsive design**: Adaptado a diferentes tamaños de pantalla
- **Estados visuales**: Indicadores claros para items disponibles/no disponibles

### 🔌 Integración con API
- **Consumo de API REST**: Datos dinámicos desde el backend
- **Manejo de estados**: Loading, error y data states
- **Configuración por ambiente**: Variables de entorno para diferentes APIs

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Flutter** `^3.9.2` - Framework de desarrollo multiplataforma
- **Dart** - Lenguaje de programación

### Dependencias Principales
- **go_router** `^16.2.1` - Navegación declarativa y type-safe
- **http** `^1.5.0` - Cliente HTTP para consumo de API
- **flutter_dotenv** `^6.0.0` - Manejo de variables de entorno

### Arquitectura
- **Patrón Service Layer**: Separación clara entre UI y lógica de negocio
- **Modelo de datos**: Clases Dart con serialización JSON
- **Navegación declarativa**: Rutas organizadas y type-safe

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                           # Punto de entrada de la aplicación
├── models/                             # Modelos de datos
│   └── category.dart                   # Category y ItemMenu models
├── services/                           # Capa de servicios
│   └── category_service.dart           # Servicio para API de categorías
├── views/                              # Vistas de la aplicación
│   └── category/
│       ├── category_list_view.dart     # Lista principal de categorías
│       ├── category_items_list_view.dart # Items de categoría específica
│       └── item_detail_view.dart       # Detalle de item individual
├── widgets/                            # Widgets reutilizables
│   ├── base_view.dart                  # Estructura base con drawer
│   └── custom_drawer.dart              # Menú lateral de navegación
├── routes/                             # Configuración de rutas
│   └── app_router.dart                 # Router principal de la app
└── themes/                             # Temas y estilos
    └── app_theme.dart                  # Tema global de la aplicación
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.9.2 o superior)
- Dart SDK
- Android Studio / VS Code con extensiones de Flutter
- Dispositivo/Emulador Android o iOS

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/SofiaToro018/frontend_restaurant.git
   cd frontend_restaurant
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar variables de entorno**
   
   Crear archivo `.env` en la raíz del proyecto:
   ```properties
   # Configuración de la API del restaurante
   API_URL=http://localhost:8080/api/v1
   
   # Configuración del restaurante por defecto
   DEFAULT_RESTAURANT_ID=1
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Configuración para Emulador Android
Si usas el emulador de Android, cambia la URL en `.env`:
```properties
API_URL=http://10.0.2.2:8080/api/v1
```

## 🔌 API Integration

### Endpoint Principal
La aplicación consume la siguiente API REST:

```
GET /api/v1/categoria-menu-service/categorias/restaurante/{id}
```

### Estructura de Respuesta JSON
```json
[
  {
    "id": 1,
    "nombre": "Entradas",
    "itemsMenu": [
      {
        "id": 1,
        "nomItem": "Ensalada César",
        "descItem": "Lechuga fresca con aderezo césar",
        "precItem": 15000.0,
        "estItem": true,
        "imgItemMenu": "https://ejemplo.com/imagen.jpg"
      }
    ]
  }
]
```

### Modelos de Datos

#### Category Model
```dart
class Category {
  final int id;
  final String nombre;
  final List<ItemMenu> itemsMenu;
}
```

#### ItemMenu Model
```dart
class ItemMenu {
  final int id;
  final String nomItem;
  final String descItem;
  final double precItem;
  final bool estItem;
  final String imgItemMenu;
}
```

## 🧭 Navegación y Rutas

### Sistema de Rutas
La aplicación utiliza `go_router` para una navegación type-safe:

| Ruta | Vista | Descripción |
|------|-------|-------------|
| `/` | Redirect → `/menu` | Redirección automática |
| `/menu` | `CategoryListView` | Vista principal de categorías |
| `/category/:id` | `CategoryItemsListView` | Items de categoría específica |
| `/item/:id` | `ItemDetailView` | Detalle de item individual |

### Flujo de Usuario
```
Inicio → CategoryListView (Lista de categorías)
          ↓
          CategoryItemsListView (Items de una categoría)
          ↓
          ItemDetailView (Detalle completo del item)
```

## 🎨 Diseño y UI/UX

### Paleta de Colores
- **Primario**: Naranja (`Colors.orange`)
- **Secundario**: Naranja profundo (`Colors.deepOrange`)
- **Acentos**: Verde para precios, Rojo para no disponibles

### Componentes Principales

#### CategoryListView
- Header de categoría con gradiente naranja
- Scroll horizontal de items por categoría
- Cards con imágenes, precios y estados

#### CategoryItemsListView
- Card principal con información de la categoría
- Lista vertical de todos los items
- Navegación a detalle de item

#### ItemDetailView
- SliverAppBar con imagen expandible
- Información completa del producto
- Botones de acción (Agregar al carrito, Favoritos)

## 🔧 Servicios y Arquitectura

### CategoryService
Maneja toda la comunicación con la API:

```dart
class CategoryService {
  Future<List<Category>> getCategoriesByRestaurant(int restaurantId);
  Future<Category> getCategoryById(int categoryId);
  Future<List<ItemMenu>> getItemsByCategory(int categoryId);
}
```

### Manejo de Estados
- **Loading**: `CircularProgressIndicator`
- **Error**: Mensaje de error con opción de reintento
- **Empty**: Mensajes informativos para datos vacíos
- **Success**: Renderizado normal de la UI

## 🧪 Testing

### Ejecutar Tests
```bash
# Tests unitarios
flutter test

# Tests de integración
flutter drive --target=test_driver/app.dart
```

### Estructura de Tests
```
test/
├── unit/
│   ├── models/
│   └── services/
├── widget/
└── integration/
```

## 📦 Build y Deploy

### Generar APK para Android
```bash
flutter build apk --release
```

### Generar Bundle para Google Play
```bash
flutter build appbundle --release
```

### Build para iOS
```bash
flutter build ios --release
```

## 🤝 Contribución

### Guía de Contribución
1. Fork del proyecto
2. Crear branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit de cambios (`git commit -m 'Add AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

### Estándares de Código
- Seguir las convenciones de Dart/Flutter
- Documentar funciones públicas
- Mantener cobertura de tests > 80%
- Usar nombres descriptivos para variables y funciones

## 🔮 Roadmap

### Próximas Características
- [ ] 🛒 Carrito de compras
- [ ] ❤️ Sistema de favoritos
- [ ] 🔍 Búsqueda de productos
- [ ] 🏷️ Filtros por categoría y precio
- [ ] 👤 Autenticación de usuarios
- [ ] 📊 Analytics y métricas
- [ ] 🌙 Modo oscuro
- [ ] 🌐 Internacionalización (i18n)

### Mejoras Técnicas
- [ ] Cache offline con SQLite
- [ ] Push notifications
- [ ] Tests automatizados (CI/CD)
- [ ] Performance monitoring
- [ ] Error reporting (Crashlytics)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Sofia Toro** - [SofiaToro018](https://github.com/SofiaToro018)

## 📞 Soporte

¿Tienes preguntas o problemas? 

- 🐛 [Reportar bugs](https://github.com/SofiaToro018/frontend_restaurant/issues)
- 💡 [Solicitar features](https://github.com/SofiaToro018/frontend_restaurant/issues)
- 📧 Email: [tu-email@ejemplo.com]

## 🙏 Agradecimientos

- Equipo de Flutter por el excelente framework
- Comunidad de desarrolladores Flutter
- [go_router](https://pub.dev/packages/go_router) por la navegación declarativa
- [Material Design](https://material.io/) por las guías de diseño

---

**¡Hecho con ❤️ y Flutter!**
