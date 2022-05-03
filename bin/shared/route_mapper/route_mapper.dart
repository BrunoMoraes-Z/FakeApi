import 'package:alfred/alfred.dart';

import '../../routes/gen/route.dart';

routeMapper(Alfred server) {
  GenService(server: server).route();
}
