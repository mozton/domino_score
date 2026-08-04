#!/bin/bash

set -e

echo "=========================================="
echo " Actualización controlada de plugins"
echo "=========================================="

echo ""
echo "1. Verificando Flutter..."
flutter --version

echo ""
echo "2. Creando backup del proyecto..."
BACKUP_DIR="../domino_score_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp pubspec.yaml "$BACKUP_DIR/pubspec.yaml"
cp pubspec.lock "$BACKUP_DIR/pubspec.lock"

echo "Backup creado en:"
echo "$BACKUP_DIR"

echo ""
echo "3. Actualizando dependencias seleccionadas..."
echo ""

flutter pub add camera:^0.12.0+2
flutter pub add connectivity_plus:^7.3.1
flutter pub add flutter_secure_storage:^10.3.1
flutter pub add image_picker:^1.2.3
flutter pub add in_app_purchase_storekit:^0.4.11
flutter pub add local_auth:^3.0.2
flutter pub add permission_handler:^13.0.0
flutter pub add path_provider:^2.1.6

echo ""
echo "4. Limpiando proyecto..."
flutter clean

echo ""
echo "5. Obteniendo dependencias..."
flutter pub get

echo ""
echo "6. Verificando dependencias..."
flutter pub outdated

echo ""
echo "7. Analizando código..."
flutter analyze

echo ""
echo "=========================================="
echo " Actualización finalizada"
echo "=========================================="

echo ""
echo "IMPORTANTE:"
echo "Revisa los resultados de flutter analyze."
echo ""
echo "Si no hay errores, prueba primero:"
echo "flutter run"
echo ""
echo "Después genera un build Release:"
echo "flutter build ipa --release"