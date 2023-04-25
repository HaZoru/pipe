import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/progress_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    Key? key,
    required AudioPlayer audioPlayer,
    required this.durationState,
    required this.pc,
  })  : _audioPlayer = audioPlayer,
        super(key: key);

  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationState;
  final PanelController pc;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      surfaceTintColor: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final sequence = state?.sequence ?? [];
                final current = state?.currentIndex;
                final String songTitle =
                    current != null ? sequence[current].tag.title : '';
                final String artist =
                    current != null ? sequence[current].tag.artist : '';
                final String albumTitle =
                    current != null ? sequence[current].tag.album : '';
                return Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (current != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 8, 0),
                          child: Image(
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(sequence[current].tag.artwork)),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.fromLTRB(3, 0, 8, 0),
                          child: SizedBox(
                              height: 45,
                              width: 45,
                              child: Center(
                                child: Icon(Icons.audio_file),
                              )),
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
                                songTitle,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                albumTitle,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          StreamBuilder<PlayerState>(
                            stream: _audioPlayer.playerStateStream,
                            builder: (_, snapshot) {
                              final playerState = snapshot.data;
                              return PlayPauseButton(
                                audioPlayer: _audioPlayer,
                                playerState: playerState,
                              );
                            },
                          ),
                          StreamBuilder<SequenceState?>(
                            stream: _audioPlayer.sequenceStateStream,
                            builder: (_, __) {
                              return NextButton(audioPlayer: _audioPlayer);
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
              _audioPlayer,
              durationState,
              noSeek: true,
            ),
          ],
        ),
      ),
    );
  }
}
