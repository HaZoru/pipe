import 'package:pipe/utlities/unique_id_gen.dart';

class Server {
  const Server({
    required this.id,
    required this.serverName,
    required this.host,
    required this.username,
    required this.password,
  });
  final String id;
  final String serverName;
  final String host;
  final String username;
  final String password;
  final String version = '1.16.1';
  final String appName = 'test';
  final String responseFormat = 'json';

  factory Server.fromJson(Map<String, dynamic> json) => Server(
        id: json["id"],
        serverName: json["serverName"],
        host: json["host"],
        username: json["username"],
        password: json["password"],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'serverName': serverName,
        'host': host,
        'username': username,
        'password': password,
      };
}
