import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/models/server.dart';
import 'package:pipe/routes/models/album_details_route_data.dart';
import 'package:pipe/screens/album_details_view.dart';
import 'package:pipe/screens/home_page.dart';
import 'package:pipe/screens/base.dart';
import 'package:pipe/screens/server_list.dart';
import 'package:pipe/screens/server_login.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:rxdart/rxdart.dart';

class AppRouter {
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> durationState;
  late PanelController _pc;
  late GoRouter router;
  AppRouter() {
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

    router = GoRouter(
      redirect: (context, state) {},
      initialLocation: '/serverlist',
      routes: [
        GoRoute(
            name:
                'login', // Optional, add name to your routes. Allows you navigate by name instead of path
            path: '/login',
            builder: (context, state) {
              //  login Page
              return ServerLogin();
            }),
        GoRoute(
            name:
                'serverList', // Optional, add name to your routes. Allows you navigate by name instead of path
            path: '/serverList',
            builder: (context, state) {
              //  serverList page
              return ServerList();
            }),
        ShellRoute(
          routes: [
            GoRoute(
                name:
                    'home', // Optional, add name to your routes. Allows you navigate by name instead of path
                path: '/',
                builder: (context, state) {
                  Server server = state.extra as Server;
                  //  serverList page
                  return Home(
                    audioPlayer: _audioPlayer,
                    pc: _pc,
                    server: server,
                  );
                }),
            GoRoute(
                name:
                    'albumDetails', // Optional, add name to your routes. Allows you navigate by name instead of path
                path: '/albumDetails',
                builder: (context, state) {
                  AlbumDetailsRouteData albumDetailsRouteData =
                      state.extra as AlbumDetailsRouteData;
                  //  serverList page
                  return AlbumDetailsView(
                    audioplayer: _audioPlayer,
                    pc: _pc,
                    server: albumDetailsRouteData.server,
                    albumMetaData: albumDetailsRouteData.albumMetaData,
                  );
                }),
          ],
          builder: (context, state, child) {
            return Base(
                audioPlayer: _audioPlayer,
                durationState: durationState,
                pc: _pc,
                child: child);
          },
        )
      ],
    );
  }
}
