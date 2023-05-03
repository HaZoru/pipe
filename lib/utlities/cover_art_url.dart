import 'package:pipe/models/server.dart';

String getAlbumCoverUrl(String coverId, int size, Server server) {
  final queryParameters = {
    'u': server.username,
    'p': server.password,
    'v': server.version,
    'c': server.appName,
    'f': server.responseFormat,
    'id': coverId,
    'size': size.toString()
  };
  final uri = Uri.http(server.host, '/rest/getCoverArt', queryParameters);
  return uri.toString();
}
