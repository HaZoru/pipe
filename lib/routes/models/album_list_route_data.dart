import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/albumList.dart';
import 'package:pipe/models/server.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumListRouteData {
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;

  AlbumListRouteData(this.server, this.audioPlayer, this.pc);
}
