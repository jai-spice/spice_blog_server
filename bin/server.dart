import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

late final PostgreSQLConnection connection;

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/blogs', _getBlogsHandler)
  ..get('/echo/<message>', _echoHandler)
  ..get('/checkConnection', _checkConnectionHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World! sdfadf\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Response _getBlogsHandler(Request request) {
  return Response.ok('All the Blogs\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  connection = PostgreSQLConnection("0.0.0.0", 5432, 'postgres',
      username: 'postgres', password: 'postgrespw');

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

Future<Response> _checkConnectionHandler(Request request) async {
  try {
    await connection.open();
    return Response.ok(connection.host);
  } catch (e) {
    return Response.ok('$e');
  }
}
