import 'package:postgres/postgres.dart';

class PostgreSQL {
  late final PostgreSQLConnection _connection;
  static final PostgreSQL instance = PostgreSQL._();

  PostgreSQL._() {
    _connection = PostgreSQLConnection(
      "containers-us-west-84.railway.app",
      6620,
      'railway',
      username: 'postgres',
      password: 'tFk3aauQ8NpMSeaY5Gem',
    );
  }

  String get host => _connection.host;

  Future<void> open() => _connection.open();

  Future<void> listen() async {
    await _connection.execute('LISTEN blogs_modify_event');
  }

  Stream<Notification> notifications() async* {
    yield* _connection.notifications;
  }

  Future<PostgreSQLResult> query(String fmtString) =>
      _connection.query(fmtString);
}
