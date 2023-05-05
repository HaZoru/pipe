import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:pipe/utlities/cover_art_url.dart';
import 'package:pipe/models/album_list.dart';
import 'package:pipe/models/album_info.dart';
import 'package:pipe/models/audio_metadata.dart';
import 'package:pipe/models/server.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumDetailsView extends StatelessWidget {
  const AlbumDetailsView(
      {Key? key,
      required this.server,
      required this.audioplayer,
      required this.pc,
      required this.albumMetaData})
      : super(key: key);
  final Server server;
  final AlbumMetaData albumMetaData;
  final AudioPlayer audioplayer;
  final PanelController pc;

  @override
  Widget build(BuildContext context) {
    String albumCover = getAlbumCoverUrl(albumMetaData.coverArt!, 500, server);
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 250,
                width: 250,
                imageUrl: albumCover,
                placeholder: (context, url) {
                  return Container(
                    child: const Center(
                      child: Icon(Icons.music_note),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Album',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).indicatorColor),
                  ),
                  Text(
                    albumMetaData.name!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    albumMetaData.artist!,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    "${albumMetaData.year!} • ${albumMetaData.songCount!} Songs",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[800],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  Text(
                    'Songs',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            AlbumTrackList(
              albumCover: albumCover,
              audioplayer: audioplayer,
              pc: pc,
              albumId: albumMetaData.id!,
              server: server,
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumTrackList extends StatelessWidget {
  const AlbumTrackList({
    Key? key,
    required this.albumCover,
    required this.audioplayer,
    required this.pc,
    required this.server,
    required this.albumId,
  }) : super(key: key);

  final String albumCover;
  final AudioPlayer audioplayer;
  final PanelController pc;
  final Server server;
  final String albumId;
  Future<AlbumInfo> getAlbum() async {
    final queryParameters = {
      'u': server.username,
      'p': server.password,
      'v': server.version,
      'c': server.appName,
      'f': server.responseFormat,
      'id': albumId,
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
    return FutureBuilder<AlbumInfo>(
        future: getAlbum(),
        builder: ((context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Song> songs = snapshot.data!.subsonicResponse!.album!.song!;
            List<AudioSource> queue = [];
            for (Song song in songs) {
              queue.add(AudioSource.uri(getSongStream(song.id!),
                  tag: MediaItem(
                      title: song.title!,
                      artist: song.artist,
                      album: song.album,
                      artUri: Uri.parse(albumCover),
                      id: song.id!)));
            }
            return Column(
              children: [
                for (Song song in snapshot.data!.subsonicResponse!.album!.song!)
                  SongTile(
                      audioplayer: audioplayer,
                      queue: queue,
                      songs: songs,
                      song: song,
                      pc: pc),
                SizedBox(
                  height: 100,
                )
              ],
            );
          }
        }));
  }
}

class SongTile extends StatelessWidget {
  SongTile({
    Key? key,
    required this.audioplayer,
    required this.queue,
    required this.songs,
    required this.song,
    required this.pc,
  }) : super(key: key);

  final AudioPlayer audioplayer;
  final List<AudioSource> queue;
  final List<Song> songs;
  final Song song;
  final PanelController pc;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    int seconds = song.duration!;
    Map timeStamp = {
      'min': (seconds / 60).floor().toString(),
      'sec': (seconds % 60).toString().padLeft(2, '0')
    };
    return StreamBuilder<SequenceState?>(
        stream: audioplayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final List sequence = state?.sequence ?? [];
          final int? current = state?.currentIndex;

          if (current != null) {
            isPlaying = sequence[current].tag.id == song.id ? true : false;
          }
          return ListTile(
            onTap: () {
              audioplayer.stop();
              audioplayer
                  .setAudioSource(ConcatenatingAudioSource(children: queue));
              audioplayer.seek(Duration.zero, index: songs.indexOf(song));
              audioplayer.play();
              pc.show();
            },
            leading: Container(
              height: 45,
              width: 45,
              color: Colors.grey[800],
              child: Center(
                child: Text(
                  song.track!.toString(),
                  style: isPlaying
                      ? TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary)
                      : TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                ),
              ),
            ),
            trailing: Icon(Icons.more_horiz),
            title: Text(
              song.title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isPlaying
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white),
            ),
            subtitle: Text("${timeStamp['min']}:${timeStamp['sec']}"),
          );
        });
  }
}
