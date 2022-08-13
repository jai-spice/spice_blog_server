import 'package:shelf_router/shelf_router.dart';

import 'auth/auth.dart';
import 'blogs/blogs.dart';

final router = Router()
  ..post('/login', Auth.loginHandler)
  ..post('/addBlog', Blogs.addBlog)
  ..get('/fetchAllBlogs', Blogs.fetchAllBlogs);
