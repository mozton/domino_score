# dominos_score

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# domino_score

## Partida en vivo

Cada partida iniciada dentro de un grupo recibe un **código de 6 caracteres** que
se muestra en la barra superior de la pantalla de juego (se toca para copiarlo).
El marcador se publica en Firestore en `liveGames/{code}` en cada ronda, y
cualquier usuario con sesión iniciada puede seguirla con ese código desde
**Ver partida en vivo** (icono de antena) sin pertenecer al grupo.

- Pantalla: `lib/features/games/presentation/pages/live_game_page.dart` (se
  refresca sola cada 5 s porque Firestore REST no tiene tiempo real).
- Reglas de Firestore necesarias: [`docs/firestore_rules.md`](docs/firestore_rules.md).
- Pruebas: `flutter test test/games`.

/📱 Width: 393 px
/📱 Height: 852 px
