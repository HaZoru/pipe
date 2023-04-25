import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/album_info.dart';
import 'package:pipe/models/audio_metadata.dart';
import 'package:pipe/models/audio_source.dart';
import 'package:pipe/models/server.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumDetailsView extends StatelessWidget {
  const AlbumDetailsView(
      {Key? key,
      required this.server,
      required this.id,
      required this.albumCover,
      required this.audioplayer,
      required this.pc})
      : super(key: key);
  final Server server;
  final String id;
  final String albumCover;
  final AudioPlayer audioplayer;
  final PanelController pc;
  Future<AlbumInfo> getAlbum() async {
    final queryParameters = {
      'u': server.username,
      'p': server.password,
      'v': server.version,
      'c': server.appName,
      'f': server.responseFormat,
      'id': id,
    };
    final uri = Uri.http(server.host, '/rest/getAlbum', queryParameters);
    final res = await http.get(uri);
    return albumInfoFromJson(utf8.decode(res.bodyBytes));
  }

  getSongStream(String songId) {
    final queryParameters = {
      'u': server.username,
      'p': server.password,
      'v': server.version,
      'c': server.appName,
      'f': server.responseFormat,
      'id': songId,
    };
    final uri = Uri.http(server.host, '/rest/stream', queryParameters);
    // final res = await http.get(uri);
    // return res.bodyBytes;
    return uri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<AlbumInfo>(
            future: getAlbum(),
            builder: ((context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<Song> songs =
                    snapshot.data!.subsonicResponse!.album!.song!;
                List<AudioSource> queue = [];
                for (Song song in songs) {
                  queue.add(AudioSource.uri(getSongStream(song.id!),
                      tag: AudioMetadata(
                          title: song.title,
                          artist: song.artist,
                          album: song.album,
                          artwork: albumCover)));
                }
                return ListView(
                  children: [
                    Container(
                      height: 500,
                      width: 500,
                      child: CachedNetworkImage(imageUrl: albumCover),
                    ),
                    for (Song song
                        in snapshot.data!.subsonicResponse!.album!.song!)
                      ListTile(
                        onTap: () {
                          audioplayer.stop();
                          audioplayer.setAudioSource(
                              ConcatenatingAudioSource(children: queue));
                          audioplayer.seek(Duration.zero,
                              index: songs.indexOf(song));
                          audioplayer.play();
                          pc.show();
                        },
                        leading: Container(
                          color: Colors.grey,
                          child: Text(song.track!.toString()),
                        ),
                        title: Text(song.title!),
                      ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                );
              }
            })),
      ),
    );
  }
}
