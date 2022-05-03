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

  test('Validate route not found', () async {
    var response = await http.get('$baseUrl/endpoint_not_found'.toUri());
    expect(response.statusCode, 400);
    expect(response.body, '{"message":"Route not found"}');
  });
}
