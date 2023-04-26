import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/albumList.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/album_details_view.dart';
import 'package:pipe/screens/album_list_view.dart';
import 'package:pipe/screens/commons/miniplayer.dart';
import 'package:pipe/screens/now_playing.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Player extends StatefulWidget {
  const Player({
    Key? key,
  }) : super(key: key);
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> durationState;
  late List<AudioSource> queue;
  late Server server;
  late PanelController _pc;
  late List screens;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    server = const Server(
        host: '192.168.1.105:4533', username: 'guest', password: 'guest');
    _audioPlayer = AudioPlayer();
    _pc = PanelController();
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        _audioPlayer.positionStream,
        _audioPlayer.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            )).asBroadcastStream();
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
                name:
                    'albumList', // Optional, add name to your routes. Allows you navigate by name instead of path
                path: '/',
                builder: (context, state) {
                  return AlbumListView(
                    audioPlayer: _audioPlayer,
                    pc: _pc,
                    server: server,
                  );
                },
                routes: [
                  GoRoute(
                      name:
                          'albumDetails', // Optional, add name to your routes. Allows you navigate by name instead of path
                      path: 'albumDetails',
                      builder: (context, state) {
                        AlbumMetaData albumMetaData =
                            state.extra as AlbumMetaData;
                        return AlbumDetailsView(
                          pc: _pc,
                          server: server,
                          albumMetaData: albumMetaData,
                          audioplayer: _audioPlayer,
                        );
                      }),
                ]),
          ],
          builder: (context, state, child) {
            return HomePage(
                pc: _pc,
                audioPlayer: _audioPlayer,
                durationState: durationState,
                child: child);
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required PanelController pc,
    required AudioPlayer audioPlayer,
    required this.durationState,
    required this.child,
  })  : _pc = pc,
        _audioPlayer = audioPlayer,
        super(key: key);

  final PanelController _pc;
  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationState;
  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool panelOpened = false;
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        onPanelSlide: (position) {
          setState(() {
            opacity = position;
          });
          // if (position < 0.6) {
          //   bool prevVal = panelOpened;
          //   panelOpened = false;
          //   if (prevVal != panelOpened) {
          //     setState(() {});
          //   }
          // } else {
          //   bool prevVal = panelOpened;
          //   panelOpened = true;
          //   if (prevVal != panelOpened) {
          //     setState(() {});
          //   }
          // }
        },
        controller: widget._pc,
        collapsed: MiniPlayer(
          audioPlayer: widget._audioPlayer,
          durationState: widget.durationState,
          pc: widget._pc,
        ),
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: MediaQuery.of(context).size.height * 10 / 100,
        // panel: panelOpened
        //     ? Center(
        //         child: NowPlaying(widget._audioPlayer, widget.durationState),
        //       )
        //     : AnimatedContainer(
        //         color: Colors.green,
        //         duration: Duration(seconds: 1),
        //       ),
        panel: Container(
          color: Colors.black,
          child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration.zero,
            child: NowPlaying(
              widget._audioPlayer,
              widget.durationState,
              pc: widget._pc,
            ),
          ),
        ),
        body: widget.child,
      ),
    );
  }
}
