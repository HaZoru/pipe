import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/progress_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    Key? key,
    required this.audioPlayer,
    required this.durationState,
    required this.pc,
    required this.title,
    required this.album,
    this.arturl,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final Stream<DurationState> durationState;
  final PanelController pc;
  final String title;
  final String album;
  final String? arturl;

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                return Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 8, 0),
                        child: CachedNetworkImage(
                          imageUrl: arturl ?? '',
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const Center(
                              child: Icon(Icons.audio_file),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const Center(
                              child: Icon(Icons.audio_file),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            pc.open();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                album,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          StreamBuilder<PlayerState>(
                            stream: audioPlayer.playerStateStream,
                            builder: (_, snapshot) {
                              final playerState = snapshot.data;
                              return PlayPauseButton(
                                audioPlayer: audioPlayer,
                                playerState: playerState,
                              );
                            },
                          ),
                          StreamBuilder<SequenceState?>(
                            stream: audioPlayer.sequenceStateStream,
                            builder: (_, __) {
                              return NextButton(audioPlayer: audioPlayer);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            AudioProgressBar(
              audioPlayer,
              durationState,
              noSeek: true,
            ),
          ],
        ),
      ),
    );
  }
}
