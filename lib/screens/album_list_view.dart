import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:pipe/utlities/cover_art_url.dart';
import 'package:pipe/models/album_list.dart';
import 'package:pipe/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:pipe/routes/models/album_details_route_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumListView extends StatefulWidget {
  const AlbumListView({
    Key? key,
    required this.server,
    required this.audioPlayer,
    required this.pc,
  }) : super(key: key);
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView>
    with AutomaticKeepAliveClientMixin<AlbumListView> {
  final List<AlbumMetaData> albumList = [];
  int offset = 0;
  int size = 30;
  bool listIsOver = false;

  Future<AlbumList> getAlbumList({required int offset}) async {
    final queryParameters = {
      'u': widget.server.username,
      'p': widget.server.password,
      'v': widget.server.version,
      'c': widget.server.appName,
      'f': widget.server.responseFormat,
      'type': 'newest',
      'size': size.toString(),
      'offset': offset.toString()
    };
    final uri =
        Uri.http(widget.server.host, '/rest/getAlbumList', queryParameters);
    final res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    return albumListFromJson(utf8.decode(res.bodyBytes));
  }

  void appendAlbums() {
    if (listIsOver) {
      return;
    }
    getAlbumList(offset: offset).then((res) {
      Iterable<AlbumMetaData> albums = res.subsonicResponse!.albumList!.album!;
      if (albums.isEmpty) {
        listIsOver = true;
      } else {
        albumList.addAll(albums);
        offset = offset + size;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    appendAlbums();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          cacheExtent: 1000,
          itemCount: albumList.length + 1,
          itemBuilder: (_, idx) {
            if (idx == (albumList.length - 1)) {
              appendAlbums();
            }
            if (idx == albumList.length) {
              if (listIsOver) {
                return Container();
              }
              return const Center(child: CircularProgressIndicator());
            } else {
              AlbumMetaData album = albumList[idx];
              return AlbumListTile(
                  album: album,
                  server: widget.server,
                  audioPlayer: widget.audioPlayer,
                  pc: widget.pc);
            }
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({
    Key? key,
    required this.album,
    required this.server,
    required this.audioPlayer,
    required this.pc,
  }) : super(key: key);

  final AlbumMetaData album;
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final MediaItem? mediaItem = snapshot.data?.currentSource?.tag;
          final String albumId = mediaItem?.extras?["albumId"] ?? '';
          final bool isPlaying = album.id == albumId;
          return ListTile(
            splashColor: Colors.transparent,
            onTap: () {
              context.pushNamed("albumDetails",
                  extra: AlbumDetailsRouteData(server, audioPlayer, pc, album));
            },
            selected: isPlaying,
            leading: CachedNetworkImage(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                imageUrl: getAlbumCoverUrl(album.coverArt!, 100, server)),
            title: Text(
              album.title!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              album.artist!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.more_horiz),
          );
        });
  }
}
