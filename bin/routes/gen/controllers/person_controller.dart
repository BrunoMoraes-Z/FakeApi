import 'package:faker_dart/faker_dart.dart';
import 'package:intl/intl.dart';

import 'document_controller.dart';
import 'name_controller.dart';

class PersonController {
  final Faker faker;
  final NameController nameController;
  final DocumentController documentController;

  PersonController(this.faker, this.nameController, this.documentController);

  person({bool parents = false}) {
    var cpf = documentController.cpf();
    var body = {
      'name': nameController.name(),
      'cpf': cpf,
      'rg': documentController.rg(),
      'born': DateFormat('dd/MM/yyyy').format(
        faker.date.past(DateTime.now(), rangeInYears: 100),
      ),
      'email': '$cpf@gmail.com',
    };

    if (parents) {
      return body
        ..addAll({
          'mother': nameController.femaleName(),
          'father': nameController.maleName(),
        });
    } else {
      return body;
    }
  }
}
