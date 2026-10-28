# Proyecto UTTEC - Gestión y Herramientas (v1.0.1)

![Licencia MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![F-Droid Ready](https://img.shields.io/badge/F--Droid-Ready-green?logo=f-droid)
![FOSS Stack](https://img.shields.io/badge/FOSS-Supabase%20%2B%20ZXing-orange)

Aplicación móvil integral desarrollada con **Flutter** para la gestión administrativa, integración de APIs REST, servicios de mensajería y utilidades de lectura óptica con una pila de software 100% libre (FOSS).

---

## 📱 Módulos y Funcionalidades (v1.0.1)

- **🔐 Autenticación y Usuarios**: Registro e inicio de sesión seguro con correo electrónico y contraseña utilizando **Supabase Auth** (SDK libre sin dependencias de Google Play Services).
- **👥 Gestión de Clientes**: Creación, actualización, listado en tiempo real y eliminación de registros de clientes (**Supabase Database**).
- **🏷️ Clasificaciones**: Administración y categorización dinámica de registros.
- **⚡ Consulta PokéAPI**: Explorador interactivo de datos y detalles de Pokémon consumiendo APIs REST HTTP.
- **📱 Directorio Telefónico y WhatsApp**: Carga de contactos del dispositivo con integración directa para enviar mensajes predeterminados a través de WhatsApp.
- **📷 Escáner de Códigos (Barcode & QR - ZXing Engine)**: Lector óptico multiformato mediante el motor libre **ZXing** (`qr_code_scanner_plus`), sin librerías propietarias como ML Kit.

---

## 🚀 Instrucciones de Compilación (F-Droid Build System)

Para compilar la aplicación utilizando el SDK de Flutter desde la línea de comandos:

### Requisitos Previos
- Flutter SDK (versión >= 3.13.2)
- Android SDK (API 34 / Java 17)

### Pasos para Compilación en Modo Release
1. Obtener las dependencias de código abierto del proyecto:
   ```bash
   flutter pub get
   ```

2. Compilar el paquete APK ejecutable:
   ```bash
   flutter build apk --release
   ```
   El archivo generado se localizará en: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 Requisitos y Metadatos para F-Droid

Este repositorio incluye todos los archivos y estructuras requeridas para su inclusión en la tienda **F-Droid**:

- **Versión Actual**: `1.0.1` (`versionCode: 2`).
- **Licencia**: Licencia libre OSI [MIT License](LICENSE).
- **Sin Blobs Propietarios**: Reemplazados Firebase y Google ML Kit por Supabase y ZXing.
- **Metadatos Fastlane**: Disponibles en `fastlane/metadata/android/` para idiomas Español (`es-ES`) e Inglés (`en-US`).
- **Receta de Construcción**: Configuración en [.fdroid.yml](.fdroid.yml) y ficha de metadatos oficial en [metadata/com.practica.tniu.proyecto10ids1.yml](metadata/com.practica.tniu.proyecto10ids1.yml).

---

## 📜 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para obtener más detalles.
