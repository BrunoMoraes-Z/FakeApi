import 'package:faker_dart/faker_dart.dart';

class NameController {
  final Faker faker;

  NameController(this.faker);

  name() {
    return '${faker.name.firstName()} ${faker.name.lastName()}';
  }

  femaleName() {
    return '${faker.name.firstName(gender: Gender.female)} ${faker.name.lastName(gender: Gender.female)}';
  }

  maleName() {
    return '${faker.name.firstName(gender: Gender.male)} ${faker.name.lastName(gender: Gender.male)}';
  }

  companyName() {
    return faker.company.companyName();
  }
}
