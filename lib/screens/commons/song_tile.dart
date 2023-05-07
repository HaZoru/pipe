import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/album_info.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SongTile extends StatelessWidget {
  const SongTile({
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

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
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
