#!/bin/sh

# Detener el script si algún comando falla
set -e

# Registrar los comandos para depuración
set -x

# Ir al directorio raíz del repositorio clonado
cd "$CI_WORKSPACE"

# Instalar CocoaPods usando Homebrew
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

# Instalar Flutter usando git
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

# Instalar los artefactos de Flutter para iOS
flutter precache --ios

# Instalar las dependencias de Flutter
flutter pub get

# Instalar las dependencias de CocoaPods
cd ios
pod install

exit 0