# Guardian SMS App MVP

Aplicación Flutter lista para la primera etapa del proyecto Guardian SMS.

## ¿Qué hace esta versión?

1. Permite pegar un SMS manualmente.
2. Tokeniza datos personales dentro del celular.
3. Muestra el mensaje limpio.
4. Analiza el mensaje en modo local usando reglas básicas.
5. Está preparada para conectarse luego a un servidor IA FastAPI en `/predict`.

## Pasos para usar

1. Crea un proyecto Flutter vacío:

```bash
flutter create guardian_sms_app
cd guardian_sms_app
```

2. Copia el contenido de esta carpeta encima del proyecto creado.

3. Instala dependencias:

```bash
flutter pub get
```

4. Ejecuta:

```bash
flutter run
```

## Cuando tengas el servidor

Edita este archivo:

```text
lib/services/api_service.dart
```

En emulador Android usa:

```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

En celular físico usa la IP de tu computadora:

```dart
static const String baseUrl = 'http://192.168.1.X:8000';
```

## Estructura

```text
lib/
├── main.dart
├── models/
│   └── analysis_result.dart
├── screens/
│   └── home_screen.dart
├── services/
│   ├── api_service.dart
│   ├── local_detector_service.dart
│   └── tokenizer_service.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── message_card.dart
    ├── privacy_card.dart
    └── status_card.dart
```
