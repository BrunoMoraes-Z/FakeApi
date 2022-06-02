import 'dart:io';

String baseDir = Directory.fromUri(Platform.script).parent.parent.path;
int serverPort = int.parse(Platform.environment['PORT'] ?? '8080');
