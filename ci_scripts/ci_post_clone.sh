#!/bin/sh

# Si algún comando falla, el script se detiene.
set -e

# Asegurarse de que estamos en la raíz del repositorio.
cd "$CI_PRIMARY_REPOSITORY_PATH"

# 1. Instalar Flutter. Se clona la versión estable.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

# 2. Verificar la instalación de Flutter.
flutter --version

# 3. Descargar los artefactos de compilación para iOS.
flutter precache --ios

# 4. Obtener las dependencias de Dart/Flutter.
flutter pub get

# 5. Instalar CocoaPods usando Homebrew (esencial para la gestión de dependencias nativas).
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

# 6. Navegar al directorio de iOS y limpiar/regenerar los pods.
# Esto soluciona el error "Unable to load contents of file list" o "Module not found".
cd ios
pod deintegrate
pod update

# 7. Generar los archivos de configuración de Flutter para Xcode.
flutter build ios --release --no-codesign

exit 0