import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../postgresql.dart';

class Auth {
  static Future<Response> loginHandler(Request request) async {
    final data = await request.readAsString();
    final params = json.decode(data);
    final res = await PostgreSQL.instance.exec(
        'SELECT * FROM public."Users" WHERE email=\'${params['email']}\' AND password=\'${params['password']}\'');
    if (res.isNotEmpty) {
      return Response.ok(jsonEncode(res.first.toColumnMap()));
    } else {
      return Response.notFound("User not found");
    }
  }
}
