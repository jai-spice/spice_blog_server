import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../postgresql.dart';

class Blogs {
  static Future<Response> fetchAllBlogs(Request request) async {
    final res = await PostgreSQL.instance.exec('SELECT * from public."Blogs"');
    if (res.isNotEmpty) {
      return Response.ok(jsonEncode(res.map((e) {
        final columnMap = e.toColumnMap();
        columnMap['updatedAt'] =
            (columnMap['updatedAt'] as DateTime).toIso8601String();
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
          'INSERT INTO public."Blogs" VALUES(\'${params['title']}\',\'${params['content']}\',\'${params['imageUrl']}\',\'${params['author']}\')');
      return Response.ok("");
    } catch (_) {
      return Response.badRequest();
    }
  }
}
