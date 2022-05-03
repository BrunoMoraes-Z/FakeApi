import 'package:faker_dart/faker_dart.dart';
import 'package:intl/intl.dart';

import 'document_controller.dart';
import 'name_controller.dart';

class CompanyController {
  final Faker faker;
  final NameController nameController;
  final DocumentController documentController;

  CompanyController(this.faker, this.nameController, this.documentController);

  company() {
    var cnpj = documentController.cnpj();
    return {
      'name': nameController.companyName(),
      'cnpj': cnpj,
      'start': DateFormat('dd/MM/yyyy').format(
        faker.date.past(DateTime.now(), rangeInYears: 100),
      ),
      'email': '$cnpj@gmail.com',
    };
  }
}
