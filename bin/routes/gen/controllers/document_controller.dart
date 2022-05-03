import 'dart:math';

import 'package:brazillian/brazillian.dart';
import 'package:faker_dart/faker_dart.dart';

class DocumentController {
  final Faker faker;
  late Brazillian brazillian = Brazillian();

  DocumentController(this.faker);

  cpf({bool formatted = false}) {
    return brazillian.cpf.generate(formatted: formatted);
  }

  cnpj({bool formatted = false}) {
    return brazillian.cnpj.generate(formatted: formatted);
  }

  rg() {
    final random = Random();

    var digits = List.generate(8, (_) => random.nextInt(9)).toList();
    
    int checksum() {
      var item = 0;
      for (int i = 2; i < 10; i++) {
        item += i * digits[i - 2];
      }
      return item;
    }

    var lastDigit = 11 - (checksum() % 11);

    if (lastDigit == 10) digits.add(9999);
    if (lastDigit == 11) digits.add(0);
    if (lastDigit < 10) digits.add(lastDigit);

    var _rg = digits.join('');
    if (_rg.length > 10) {
      _rg = rg();
    }

    return _rg;
  }
}
