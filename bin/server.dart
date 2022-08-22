import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'blogs/blogs.dart';
import 'postgresql.dart';
import 'router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': '*',
  };

  Response? _options(Request request) => (request.method == 'OPTIONS')
      ? Response.ok(null, headers: corsHeaders)
      : null;
  Response _cors(Response response) => response.change(headers: corsHeaders);
  final fixCORS =
      createMiddleware(requestHandler: _options, responseHandler: _cors);

  await PostgreSQL.instance.open();

  await PostgreSQL.instance.listen();

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(fixCORS)
      .addMiddleware(logRequests())
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port, shared: true);

  print('Server listening on port ${server.port}');
}
