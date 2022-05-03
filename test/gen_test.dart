import 'dart:convert';
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

  test('Check body response is not empty', () async {
    var response = await http.post('$baseUrl/gen'.toUri());
    List<Json> body = toJsonListBody(response.body);

    expect(response.statusCode, 200);
    expect(body, isNotEmpty);
    expect(body.length, 1);
  });

  test('Validate Default Gen response', () async {
    var response = await http.post('$baseUrl/gen'.toUri());
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

  test('Validate Default Gen response with custom amount', () async {
    var amount = 10;
    var response = await http.post(
      '$baseUrl/gen'.toUri(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': amount,
      }),
    );
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
  });

  test('Validate expecific field - Name', () async {
    var amount = 2;
    String field = 'name';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains(field));
  });

  test('Validate expecific field - CPF', () async {
    var amount = 2;
    String field = 'cpf';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains(field));
  });

  test('Validate expecific field - RG', () async {
    var amount = 2;
    String field = 'rg';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains(field));
  });

  test('Validate expecific field - email', () async {
    var amount = 2;
    String field = 'email';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains(field));
  });

  test('Validate expecific field - CNPJ', () async {
    var amount = 2;
    String field = 'cnpj';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains(field));
  });

  test('Validate expecific field - male_name', () async {
    var amount = 2;
    String field = 'male_name';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains('name'));
  });

  test('Validate expecific field - female_name', () async {
    var amount = 2;
    String field = 'female_name';
    var response = await executeFieldRequest(baseUrl, amount, field);
    List<Json> body = toJsonListBody(response.body);

    expect(body, isNotEmpty);
    expect(body.length, amount);
    expect(body[0].keys, contains('name'));
  });
}
