class Server {
  const Server({
    required this.host,
    required this.username,
    required this.password,
  });
  final String host;
  final String username;
  final String password;
  final String version = '1.16.1';
  final String appName = 'test';
  final String responseFormat = 'json';
}
