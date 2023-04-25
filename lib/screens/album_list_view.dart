import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/albumList.dart';
import 'package:pipe/models/album_cover.dart';
import 'package:pipe/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:pipe/screens/album_details_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumListView extends StatefulWidget {
  AlbumListView(
      {Key? key,
      required this.server,
      required this.audioPlayer,
      required this.pc})
      : super(key: key);
  final Server server;
  final AudioPlayer audioPlayer;
  final PanelController pc;

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  final List<Album> albumList = [];
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
    print(res.body);
    return albumListFromJson(utf8.decode(res.bodyBytes));
  }

  String getAlbumCoverUrl(String coverId, int size) {
    final queryParameters = {
      'u': widget.server.username,
      'p': widget.server.password,
      'v': widget.server.version,
      'c': widget.server.appName,
      'f': widget.server.responseFormat,
      'id': coverId,
      'size': size.toString()
    };
    final uri =
        Uri.http(widget.server.host, '/rest/getCoverArt', queryParameters);
    return uri.toString();
  }

  void appendAlbums() {
    if (listIsOver) {
      return;
    }
    print('getting more');
    print(listIsOver);
    getAlbumList(offset: offset).then((res) {
      Iterable<Album> albums = res.subsonicResponse!.albumList!.album!;
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
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height * 10 / 100,
            surfaceTintColor: Colors.teal,
            leadingWidth: 1000,
            leading: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Pipe',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
            )),
        body: ListView.builder(
            cacheExtent: 10000,
            itemCount: albumList.length + 1,
            itemBuilder: (_, idx) {
              print(idx);
              print(listIsOver);
              if (idx == (albumList.length - 1)) {
                appendAlbums();
              }
              if (idx == albumList.length) {
                if (listIsOver) {
                  return SizedBox(
                    height: 100,
                  );
                }
              } else {
                Album album = albumList[idx];
                return ListTile(
                  onTap: () {
                    String albumCover = getAlbumCoverUrl(album.coverArt!, 500);
                    context.goNamed("albumDetails", queryParams: {
                      'albumId': album.id!,
                      'albumCover': albumCover
                    });
                  },
                  leading: CachedNetworkImage(
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                      imageUrl: getAlbumCoverUrl(album.coverArt!, 100)),
                  title: Text(
                    album.title!,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    album.artist!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  trailing: Icon(Icons.more_horiz),
                );
              }
            }));
  }
}
