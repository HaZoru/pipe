import 'dart:convert';

import 'package:flutter/widgets.dart';
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
import 'package:pipe/utlities/server_shared_prefs.dart';
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
      debugLogDiagnostics: true,
      redirect: (context, state) async {
        if (state.location == '/serverlist') {
          String? activeServer = await getActiveServer(asJson: true);
          if (activeServer != null) {
            return Uri.encodeFull("/home${activeServer}");
          }
        }
      },
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
                'serverlist', // Optional, add name to your routes. Allows you navigate by name instead of path
            path: '/serverlist',
            builder: (context, state) {
              //  serverList page
              return ServerList();
            }),
        ShellRoute(
          routes: [
            GoRoute(
                name:
                    'home', // Optional, add name to your routes. Allows you navigate by name instead of path
                path: '/home:server',
                builder: (context, state) {
                  String? _server = state.params['server'];
                  if (_server != null) {
                    return Home(
                      audioPlayer: _audioPlayer,
                      pc: _pc,
                      server: Server.fromJson(jsonDecode(_server)),
                    );
                  } else {
                    return Text('no server provided');
                  }
                  //  serverList page
                }),
            GoRoute(
                name:
                    'albumDetails', // Optional, add name to your routes. Allows you navigate by name instead of path
                path: '/album-details',
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
