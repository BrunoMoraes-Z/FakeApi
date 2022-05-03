import 'dart:io';

import 'package:alfred/src/alfred.dart';

import '../../shared/constants/constants.dart';
import '../../shared/route_mapper/route.dart';

class SwaggerService extends Route {
  SwaggerService({required Alfred server})
      : super(server: server, path: 'swagger', version: -1);

  route() {
    server.get($('/sf/*'), (req, res) => Directory('$baseDir/public'));

    server.get($('/'), (req, res) async {
      res.headers.contentType = ContentType.html;
      var swaggerContent = await File(
        '$baseDir/public/index.html',
      ).readAsString();
      return swaggerContent.replaceAll(
        '{{origin}}',
        Platform.environment['SWAGGER_URL'] ?? '',
      );
    });
  }
}
