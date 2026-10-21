// Pruebas de caja blanca: lib/utils/validators.dart
// Cada test recorre una rama distinta del código (cobertura de decisiones).
// Ejecutar: flutter test test/caja_blanca/validators_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto10ids1/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('CB-V-01 valor nulo -> pide el correo', () {
      expect(Validators.email(null), 'Ingresa tu correo electrónico');
    });

    test('CB-V-02 cadena vacía -> pide el correo', () {
      expect(Validators.email(''), 'Ingresa tu correo electrónico');
    });

    test('CB-V-03 solo espacios -> pide el correo (usa trim)', () {
      expect(Validators.email('   '), 'Ingresa tu correo electrónico');
    });

    test('CB-V-04 sin arroba -> formato no válido', () {
      expect(Validators.email('usuario.com'), 'Formato de correo no válido');
    });

    test('CB-V-05 sin dominio -> formato no válido', () {
      expect(Validators.email('ana@'), 'Formato de correo no válido');
    });

    test('CB-V-06 dominio sin punto -> formato no válido', () {
      expect(Validators.email('ana@mail'), 'Formato de correo no válido');
    });

    test('CB-V-07 correo válido -> null', () {
      expect(Validators.email('ana@mail.com'), isNull);
    });

    test('CB-V-08 correo válido con subdominios y guion -> null', () {
      expect(Validators.email('ana.lopez-1@uttec.edu.mx'), isNull);
    });

    test('CB-V-09 correo válido con espacios alrededor -> null', () {
      expect(Validators.email('  ana@mail.com  '), isNull);
    });
  });

  group('Validators.password', () {
    test('CB-V-10 nulo -> pide la contraseña', () {
      expect(Validators.password(null), 'Ingresa tu contraseña');
    });

    test('CB-V-11 vacía -> pide la contraseña', () {
      expect(Validators.password(''), 'Ingresa tu contraseña');
    });

    test('CB-V-12 5 caracteres (límite inferior) -> muy corta', () {
      expect(Validators.password('12345'), 'Debe tener al menos 6 caracteres');
    });

    test('CB-V-13 6 caracteres (límite) -> válida', () {
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.requiredField', () {
    test('CB-V-14 nulo -> obligatorio', () {
      expect(Validators.requiredField(null, fieldName: 'nombre'),
          'Este nombre es obligatorio');
    });

    test('CB-V-15 solo espacios -> obligatorio', () {
      expect(Validators.requiredField('   ', fieldName: 'nombre'),
          'Este nombre es obligatorio');
    });

    test('CB-V-16 con texto -> null', () {
      expect(Validators.requiredField('Ana', fieldName: 'nombre'), isNull);
    });

    test('CB-V-17 sin fieldName usa "campo"', () {
      expect(Validators.requiredField(''), 'Este campo es obligatorio');
    });
  });

  group('Validators.confirmPassword', () {
    test('CB-V-18 nulo -> pide confirmar', () {
      expect(Validators.confirmPassword(null, 'Prueba123'),
          'Confirma tu contraseña');
    });

    test('CB-V-19 vacío -> pide confirmar', () {
      expect(Validators.confirmPassword('', 'Prueba123'),
          'Confirma tu contraseña');
    });

    test('CB-V-20 distinta -> no coinciden', () {
      expect(Validators.confirmPassword('Prueba124', 'Prueba123'),
          'Las contraseñas no coinciden');
    });

    test('CB-V-21 igual -> null', () {
      expect(Validators.confirmPassword('Prueba123', 'Prueba123'), isNull);
    });
  });

  group('Checklist de contraseña', () {
    test('CB-V-22 hasMinLength en el límite de 6', () {
      expect(Validators.hasMinLength('12345'), isFalse);
      expect(Validators.hasMinLength('123456'), isTrue);
    });

    test('CB-V-23 hasNumber', () {
      expect(Validators.hasNumber('abcdef'), isFalse);
      expect(Validators.hasNumber('abcde1'), isTrue);
    });

    test('CB-V-24 hasUpper', () {
      expect(Validators.hasUpper('abcdef'), isFalse);
      expect(Validators.hasUpper('Abcdef'), isTrue);
    });
  });
}
