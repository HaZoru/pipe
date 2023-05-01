import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/album_list_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  const Home(
      {Key? key,
      required this.server,
      required this.audioPlayer,
      required this.pc})
      : super(key: key);
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                title: Text(
                  'Pipe',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                floating: true,
                pinned: true,
                snap: true,
                bottom: TabBar(
                  tabs: <Tab>[
                    Tab(text: "Album"),
                    Tab(text: "Artist"),
                  ], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              AlbumListView(
                  server: widget.server,
                  audioPlayer: widget.audioPlayer,
                  pc: widget.pc),
              Placeholder(),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
