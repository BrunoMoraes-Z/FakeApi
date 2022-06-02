import 'dart:convert';

import 'package:alfred/alfred.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:faker_dart/src/utils/locale_utils.dart';

import '../../shared/constants/constants.dart';
import '../../shared/route_mapper/route.dart';
import 'controllers/company_controller.dart';
import 'controllers/document_controller.dart';
import 'controllers/name_controller.dart';
import 'controllers/person_controller.dart';
import 'package:http/http.dart' as http;

class GenService extends Route {
  GenService({required Alfred server}) : super(server: server, path: 'gen');

  route() {
    final fake = Faker.instance;
    fake.setLocale(FakerLocaleType.pt_BR);

    final nameController = NameController(fake);
    final documentController = DocumentController(fake);
    final personController = PersonController(
      fake,
      nameController,
      documentController,
    );
    final companyController = CompanyController(
      fake,
      nameController,
      documentController,
    );

    server.get($('/'), (req, res) async {
      var response = await http.post(
        Uri.parse('http://127.0.0.1:$serverPort/api/v1/gen'),
      );
      return json.decode(response.body)[0];
    });

    server.post($('/'), (req, res) async {
      final body = fromJson(await req.body);
      var numbers = body.containsKey('amount') ? body['amount'] : 1;
      if (numbers > 1000) numbers = 1000;
      if (numbers < 1) numbers = 1;
      final itens = body.containsKey('fields') ? body['fields'] as List : [];

      var result = [];

      for (int i = 0; i < numbers; i++) {
        if (itens.isEmpty) {
          result.add(personController.person(parents: true));
        } else {
          var item = {};

          if (itens.contains('name')) {
            item['name'] = nameController.name();
          }

          if (itens.contains('female_name')) {
            item['name'] = nameController.femaleName();
          }

          if (itens.contains('male_name')) {
            item['name'] = nameController.maleName();
          }

          if (itens.contains('email')) {
            item['email'] = '${documentController.cpf()}@gmail.com';
          }

          if (itens.contains('cpf')) {
            item['cpf'] = documentController.cpf();
          }

          if (itens.contains('rg')) {
            item['rg'] = documentController.rg();
          }

          if (itens.contains('cnpj')) {
            item['cnpj'] = documentController.cnpj();
          }

          result.add(item);
        }
      }

      return result;
    });

    server.post($('/person'), (req, res) async {
      final body = fromJson(await req.body);
      var numbers = body.containsKey('amount') ? body['amount'] : 1;
      if (numbers > 1000) numbers = 1000;
      if (numbers < 1) numbers = 1;

      var result = [];

      for (int i = 0; i < numbers; i++) {
        result.add(personController.person(parents: true));
      }

      return result;
    });

    server.post($('/company'), (req, res) async {
      final body = fromJson(await req.body);
      var numbers = body.containsKey('amount') ? body['amount'] : 1;
      if (numbers > 1000) numbers = 1000;
      if (numbers < 1) numbers = 1;

      var result = [];

      for (int i = 0; i < numbers; i++) {
        result.add(companyController.company());
      }

      return result;
    });
  }
}
