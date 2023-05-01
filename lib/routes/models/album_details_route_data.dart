import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/album_list.dart';
import 'package:pipe/models/server.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumDetailsRouteData {
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;
  final AlbumMetaData albumMetaData;

  AlbumDetailsRouteData(
      this.server, this.audioPlayer, this.pc, this.albumMetaData);
}
