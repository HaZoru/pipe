import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/utlities/server_shared_prefs.dart';

class ServerList extends StatefulWidget {
  const ServerList({Key? key}) : super(key: key);

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
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
                        context.goNamed('home',
                            params: {'server': jsonEncode(server.toJson())});
                        setActiveServer(server);
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
