import 'dart:convert';

import 'package:alfred/alfred.dart';

class Route {
  final Alfred server;
  late String endpoint;

  Route({required this.server, required String path, int? version}) {
    endpoint =
        version != null && version == -1 ? path : 'api/v${version ?? 1}/$path';
  }

  $(String path) =>
      '$endpoint/${path.startsWith("/") ? path.replaceFirst("/", "") : path}';

  Map<String, dynamic> fromJson(Object? rawBody) {
    if (rawBody == null) return {};
    return rawBody is Map ? json.decode(json.encode(rawBody)) : {};
  }
}
