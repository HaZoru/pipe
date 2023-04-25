import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/audio_metadata.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/screens/album_details_view.dart';
import 'package:pipe/screens/album_list_view.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/queue.dart';
import 'package:pipe/screens/commons/progress_bar.dart';
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
                        print(state.params['albumCover']);
                        return AlbumDetailsView(
                          pc: _pc,
                          server: server,
                          albumCover: state.queryParams['albumCover']!,
                          audioplayer: _audioPlayer,
                          id: state.queryParams['albumId']!,
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

class HomePage extends StatelessWidget {
  const HomePage({
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 10 / 100,
          surfaceTintColor: Colors.teal,
          leadingWidth: 1000,
          leading: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Pipe',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          )),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SlidingUpPanel(
        controller: _pc,
        collapsed:
            MiniPlayer(audioPlayer: _audioPlayer, durationState: durationState),
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: MediaQuery.of(context).size.height * 10 / 100,
        panel: Center(
          child: NowPlaying(_audioPlayer, durationState),
        ),
        body: child,
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    Key? key,
    required AudioPlayer audioPlayer,
    required this.durationState,
  })  : _audioPlayer = audioPlayer,
        super(key: key);

  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationState;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      surfaceTintColor: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final sequence = state?.sequence ?? [];
                final current = state?.currentIndex;
                return Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (current != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 8, 0),
                          child: Image(
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(sequence[current].tag.artwork)),
                        ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (current != null)
                              Text(
                                sequence[current].tag.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (current != null)
                              Text(
                                sequence[current].tag.album,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          StreamBuilder<PlayerState>(
                            stream: _audioPlayer.playerStateStream,
                            builder: (_, snapshot) {
                              final playerState = snapshot.data;
                              return PlayPauseButton(
                                audioPlayer: _audioPlayer,
                                playerState: playerState,
                              );
                            },
                          ),
                          StreamBuilder<SequenceState?>(
                            stream: _audioPlayer.sequenceStateStream,
                            builder: (_, __) {
                              return NextButton(audioPlayer: _audioPlayer);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            AudioProgressBar(
              _audioPlayer,
              durationState,
              noSeek: true,
            ),
          ],
        ),
      ),
    );
  }
}
