import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'auth/auth.dart';
import 'blogs/blogs.dart';
import 'postgresql.dart';

final router = Router()
  ..post('/login', Auth.loginHandler)
  ..post('/signup', Auth.signupHandler)
  ..post('/addBlog', Blogs.addBlog)
  ..post('/fetchAllBlogs', Blogs.fetchAllBlogs)
  ..get('/ws', webSocketHandler(_handler))
  ..delete('/deleteBlog', Blogs.deleteBlogHandler);

void _handler(webSocket) {
  Blogs.fetchAllBlogs().then(webSocket.sink.add);
  PostgreSQL.instance.notifications().listen((event) async {
    webSocket.sink.add(await Blogs.fetchAllBlogs());
  });
}
