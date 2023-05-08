import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/album_list_view.dart';
import 'package:pipe/screens/artist_list_view.dart';
import 'package:pipe/utlities/server_shared_prefs.dart';
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
    super.build(context);
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  'Pipe',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                floating: true,
                pinned: true,
                snap: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.sync),
                      onPressed: () async {
                        await removeActiveServer();
                        context.goNamed('serverList');
                      }),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorWeight: 2,
                      isScrollable: true,
                      tabs: <Tab>[
                        Tab(
                          icon: Icon(Icons.album),
                        ),
                        Tab(
                          icon: Icon(Icons.people),
                        ),
                      ], // <-- total of 2 tabs
                    ),
                  ),
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
              ArtistListView(
                server: widget.server,
              ),
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
