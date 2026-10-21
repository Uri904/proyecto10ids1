// Pruebas que describen el comportamiento CORRECTO esperado y que, con el código
// actual, deben FALLAR. Sirven como evidencia de los errores hallados en el
// análisis de caja blanca. Después de aplicar las correcciones deben pasar.
// Ejecutar: flutter test test/caja_blanca/errores_conocidos_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto10ids1/utils/validators.dart';

void main() {
  group('Errores conocidos en Validators', () {
    test('ERR-01 correo válido con dominio de más de 4 letras (.online)', () {
      expect(Validators.email('ana@mail.online'), isNull);
    });

    test('ERR-02 correo válido con "+" en la parte local', () {
      expect(Validators.email('ana+tag@mail.com'), isNull);
    });

    test('ERR-03 mensaje obligatorio con concordancia correcta', () {
      final msg = Validators.requiredField('', fieldName: 'dirección');
      expect(msg, isNot('Este dirección es obligatorio'));
    });

    test('ERR-04 contraseña solo de espacios debe rechazarse', () {
      // AuthService aplica trim(), así que "      " llegaría vacía a Firebase.
      expect(Validators.password('      '), isNotNull);
    });

    test('ERR-05 contraseña sin número ni mayúscula debe rechazarse', () {
      // La pantalla de registro muestra ambos requisitos como obligatorios.
      expect(Validators.password('abcdef'), isNotNull);
    });
  });
}
