import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/base.dart';
import 'package:pipe/screens/server_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerList extends StatefulWidget {
  const ServerList({Key? key}) : super(key: key);

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Server>>(
          future: getServerlist(),
          builder: (context, snapshot) {
            List<Server> servers;
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              servers = snapshot.data!;
              return ListView(
                children: [
                  for (Server server in servers)
                    ListTile(
                      onTap: () {
                        context.goNamed('home', extra: server);
                      },
                      leading: Icon(Icons.computer_outlined),
                      title: Text(server.serverName),
                      subtitle: Text(server.host),
                    ),
                  IconButton(
                      onPressed: () {
                        context.pushNamed('login').then((value) => setState(
                              () {},
                            ));
                      },
                      icon: Icon(Icons.add))
                ],
              );
            }
          }),
    );
  }
}
