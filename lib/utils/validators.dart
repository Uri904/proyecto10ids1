/// Reglas de validación reutilizadas en Login y Registro.
class Validators {
  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Formato de correo no válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'Debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? requiredField(String? value, {String fieldName = 'campo'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Este $fieldName es obligatorio';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != original) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Devuelve una descripción del requisito faltante para mostrar
  /// como ayuda en vivo (checklist) bajo el campo de contraseña.
  static bool hasMinLength(String value) => value.length >= 6;
  static bool hasNumber(String value) => RegExp(r'[0-9]').hasMatch(value);
  static bool hasUpper(String value) => RegExp(r'[A-Z]').hasMatch(value);
}
