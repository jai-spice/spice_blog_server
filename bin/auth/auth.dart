import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../postgresql.dart';

class Auth {
  static Future<Response> signupHandler(Request request) async {
    final data = await request.readAsString();
    final params = json.decode(data);

    try {
      await PostgreSQL.instance.exec(
          'INSERT INTO public."Users" VALUES(\'${params['email']}\',\'${params['password']}\',\'${params['firstName']}\',\'${params['lastName']}\')');
      return Response.ok("");
    } catch (_) {
      return Response.badRequest();
    }
  }

  static Future<Response> loginHandler(Request request) async {
    final data = await request.readAsString();
    final params = json.decode(data);
    final res = await PostgreSQL.instance.exec(
        'SELECT * FROM public."Users" WHERE email=\'${params['email']}\' AND password=\'${params['password']}\'');

    final columnMap = res.first.toColumnMap();
    columnMap['updatedAt'] =
        (columnMap['updatedAt'] as DateTime).toIso8601String();
    if (res.isNotEmpty) {
      return Response.ok(jsonEncode(columnMap));
    } else {
      return Response.notFound("User not found");
    }
  }
}
