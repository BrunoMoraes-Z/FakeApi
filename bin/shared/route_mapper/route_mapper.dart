import 'package:alfred/alfred.dart';

import '../../routes/gen/route.dart';
import '../../routes/swagger/route.dart';

routeMapper(Alfred server) {
  GenService(server: server).route();
  SwaggerService(server: server).route();
}
