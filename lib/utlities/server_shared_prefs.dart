import 'dart:convert';
import 'package:pipe/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

void addNewServer(Server newServer) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> serverList = prefs.getStringList('serverList') ?? [];
  List<String> newServerList = serverList + [jsonEncode(newServer.toJson())];
  await prefs.setStringList('serverList', newServerList);
}

void removeServer(Server server) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> serverList = prefs.getStringList('serverList') ?? [];
  serverList.remove(jsonEncode(server.toJson()));
  await prefs.setStringList('serverList', serverList);

  // remove server if it is also active
  getActiveServer().then((activeServer) {
    if (activeServer == server) {
      prefs.remove('activeServer');
    }
  });
}

Future<List<Server>> getServerlist() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> _serverList = prefs.getStringList('serverList') ?? [];
  final List<Server> serverList = [];
  for (String _server in _serverList) {
    Server server = Server.fromJson(jsonDecode(_server));
    serverList.add(server);
  }
  return serverList;
}

setActiveServer(Server server) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('activeServer', jsonEncode(server.toJson()));
}

removeActiveServer() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('activeServer');
}

getActiveServer({bool asJson = false}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? _activeServer = prefs.getString('activeServer');
  if (_activeServer == null) {
    return null;
  } else {
    return asJson ? _activeServer : Server.fromJson(jsonDecode(_activeServer));
  }
}
