import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pipe/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerLogin extends StatefulWidget {
  const ServerLogin({Key? key}) : super(key: key);

  @override
  State<ServerLogin> createState() => _ServerLoginState();
}

class _ServerLoginState extends State<ServerLogin> {
  final _formKey = GlobalKey<FormState>();
  String serverName = '';
  String host = '';
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          child: Column(
        children: [
          Text('Host'),
          TextFormField(onChanged: (value) {
            serverName = value;
          }),
          TextFormField(onChanged: (value) {
            host = value;
          }),
          Text('Authentication'),
          TextFormField(onChanged: (value) {
            username = value;
          }),
          TextFormField(onChanged: (value) {
            password = value;
          }),
          ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final List<String> serverList =
                    prefs.getStringList('serverList') ?? [];
                Server newServer = Server(
                    serverName: serverName,
                    host: host,
                    username: username,
                    password: password);
                List<String> newServerList =
                    serverList + [jsonEncode(newServer.toJson())];
                print(newServerList);
                await prefs.setStringList('serverList', newServerList);
              },
              child: Text('Submit')),
        ],
      )),
    );
  }
}
