import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/player.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  void main() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
  }

  Widget build(BuildContext context) {
    main();
    return Player();
  }
}

// GoRouter configuration

class RouteData {
  final AudioPlayer audioPlayer;
  final Server server;
  final PanelController pc;

  RouteData(this.audioPlayer, this.server, this.pc);
}
