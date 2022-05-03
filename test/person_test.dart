import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../bin/server.dart';
import 'helpers/utilities.dart';

void main() {
  late HttpServer server;
  late String baseUrl;

  // To Split Tests in Console
  setUp(() => print('\n--------------------------------------------------'));
  setUpAll(() async {
    server = await startServer();
    baseUrl = 'http://localhost:${server.port}/api/v1';
  });

  tearDownAll(() async => await server.close());

  test('Validate Default Person response with custom amount', () async {
    var response = await http.post('$baseUrl/gen/person'.toUri());
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    var item = body[0];

    var keys = ['name', 'cpf', 'rg', 'born', 'email', 'mother', 'father'];

    expect(item.keys, containsAll(keys));
    expect(item.keys.length, keys.length);
    for (var element in item.keys) {
      expect(item[element].toString().trim(), isNotEmpty);
    }
  });
}
