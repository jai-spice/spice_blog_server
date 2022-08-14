import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../postgresql.dart';

class Blogs {
  static Future<Response> fetchAllBlogs(Request request) async {
    final res = await PostgreSQL.instance.exec('SELECT * from blogs');
    if (res.isNotEmpty) {
      return Response.ok(jsonEncode(res.map((e) {
        final columnMap = e.toColumnMap();
        columnMap['updatedat'] =
            (columnMap['updatedat'] as DateTime).toIso8601String();
        return columnMap;
      }).toList()));
    } else {
      return Response.ok("[]");
    }
  }

  static Future<Response> addBlog(Request request) async {
    final data = await request.readAsString();
    final params = json.decode(data);
    try {
      await PostgreSQL.instance.exec(
          'INSERT INTO blogs VALUES(DEFAULT,\'${params['title']}\',\'${params['content']}\',\'${params['imageUrl']}\',\'${params['email']}\')');
      return Response.ok("");
    } catch (_) {
      return Response.badRequest();
    }
  }
}
