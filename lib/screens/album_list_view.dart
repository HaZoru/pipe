import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/common_func/cover_art_url.dart';
import 'package:pipe/models/album_list.dart';
import 'package:pipe/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:pipe/routes/models/album_details_route_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumListView extends StatefulWidget {
  AlbumListView({
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
    return Scrollbar(
      interactive: true,
      thickness: 10,
      radius: Radius.circular(40),
      child: ListView.builder(
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
              return Center(child: CircularProgressIndicator());
            } else {
              AlbumMetaData album = albumList[idx];
              return ListTile(
                splashColor: Colors.transparent,
                onTap: () {
                  context.pushNamed("albumDetails",
                      extra: AlbumDetailsRouteData(
                          widget.server, widget.audioPlayer, widget.pc, album));
                },
                leading: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    imageUrl:
                        getAlbumCoverUrl(album.coverArt!, 100, widget.server)),
                title: Text(
                  album.title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  album.artist!,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.more_horiz),
              );
            }
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
