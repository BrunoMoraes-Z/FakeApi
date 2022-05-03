import 'dart:convert';
import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;

List<Json> toJsonListBody(String rawBody) {
  return (json.decode(rawBody) as List<dynamic>).map((e) => e as Json).toList();
}

Future<http.Response> executeFieldRequest(
  String url,
  int amount,
  String field,
) async {
  var response = await http.post(
    '$url/gen'.toUri(),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'amount': amount,
      'fields': [
        field,
      ]
    }),
  );
  return response;
}

extension StringUri on String {
  Uri toUri() {
    return Uri.parse(this);
  }
}
