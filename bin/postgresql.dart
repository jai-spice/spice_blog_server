import 'package:postgres/postgres.dart';

class PostgreSQL {
  late final PostgreSQLConnection _connection;
  static final PostgreSQL instance = PostgreSQL._();

  PostgreSQL._() {
    _connection = PostgreSQLConnection("0.0.0.0", 55002, 'postgres',
        username: 'postgres', password: 'postgrespw');
  }

  String get host => _connection.host;

  Future<void> open() => _connection.open();

  Future<PostgreSQLResult> exec(String fmtString) =>
      _connection.query(fmtString);
}
