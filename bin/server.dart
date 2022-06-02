import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

import 'shared/constants/constants.dart';
import 'shared/route_mapper/route_mapper.dart';

// start Commando with HotReload
//
// dart --enable-vm-service bin/server.dart
void main() async {
  if (Platform.environment['SWAGGER_URL'] == null) {
    withHotreload(() async => startServer());
  } else {
    await startServer();
  }
}

Future<HttpServer> startServer() async {
  final app = Alfred(
    onNotFound: (req, res) {
      res.statusCode = 400;
      return {'message': 'Route not found'};
    },
  );

  // Disable CORS
  app.all('*', cors());

  // Log all Requests
  app.printRoutes();

  // Map all Routes
  routeMapper(app);

  // Create a Server
  var server = await app.listen(
    serverPort,
    InternetAddress.anyIPv4,
  );
  server.autoCompress = true;

  print('Listen at http://${server.address.host}:${server.port} 🚀');
  return server;
}
