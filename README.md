# Proyecto UTTEC - Gestión y Herramientas

![Licencia MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![F-Droid Ready](https://img.shields.io/badge/F--Droid-Ready-green?logo=f-droid)

Aplicación móvil integral desarrollada con **Flutter** para la gestión administrativa, integración de APIs REST, servicios de mensajería y utilidades de lectura óptica.

---

## 📱 Módulos y Funcionalidades

- **🔐 Autenticación y Usuarios**: Registro e inicio de sesión seguro con correo electrónico y contraseña (Firebase Auth).
- **👥 Gestión de Clientes**: Creación, actualización, listado en tiempo real y eliminación de registros de clientes (Cloud Firestore).
- **🏷️ Clasificaciones**: Administración y categorización dinámica de registros.
- **⚡ Consulta PokéAPI**: Explorador interactivo de datos y detalles de Pokémon consumiendo APIs REST HTTP.
- **📱 Directorio Telefónico y WhatsApp**: Carga de contactos del dispositivo con integración directa para enviar mensajes predeterminados a través de WhatsApp.
- **📷 Escáner de Códigos (Barcode & QR)**: Lector óptico multiformato mediante cámara del dispositivo, con soporte especializado para URLs institucionales de la Universidad Tecnológica de Tecámac (UTTEC).

---

## 🚀 Instrucciones de Compilación (F-Droid Build System)

Para compilar la aplicación utilizando el SDK de Flutter desde la línea de comandos:

### Requisitos Previos
- Flutter SDK (versión >= 3.13.2)
- Android SDK (API 34 / Java 17)

### Pasos para Compilación en Modo Release
1. Obtener las dependencias del proyecto:
   ```bash
   flutter pub get
   ```

2. Compilar el paquete APK ejecutable sin firma de depuración o para distribución:
   ```bash
   flutter build apk --release
   ```
   El archivo generado se localizará en: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 Requisitos y Metadatos para F-Droid

Este repositorio incluye todos los archivos y estructuras requeridas para su inclusión en la tienda **F-Droid**:

- **Licencia**: Licencia libre OSI [MIT License](LICENSE).
- **Metadatos Fastlane**: Disponibles en `fastlane/metadata/android/` para idiomas Español (`es-ES`) e Inglés (`en-US`).
- **Receta de Construcción**: Configuración en [.fdroid.yml](.fdroid.yml) y ficha de metadatos oficial en [metadata/com.practica.tniu.proyecto10ids1.yml](metadata/com.practica.tniu.proyecto10ids1.yml).
- **Permisos Depurados**: Permisos en `AndroidManifest.xml` ajustados al mínimo necesario (`INTERNET`, `CAMERA`, `READ_CONTACTS`).

---

## 📜 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para obtener más detalles.
