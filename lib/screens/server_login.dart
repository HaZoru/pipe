import 'package:flutter/material.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/utlities/server_shared_prefs.dart';
import 'package:pipe/utlities/unique_id_gen.dart';

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
              onPressed: () => addNewServer(Server(
                  id: idGenerator(),
                  serverName: serverName,
                  host: host,
                  username: username,
                  password: password)),
              child: Text('Submit')),
        ],
      )),
    );
  }
}
