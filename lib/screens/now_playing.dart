import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/progress_bar.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying(this._audioPlayer, this.durationState, {Key? key})
      : super(key: key);
  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<SequenceState?>(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];
          final current = state?.currentIndex;
          return Column(
            children: [
              const Text('Now Playing'),
              const Text('All songs'),
              if (current != null)
                Image(image: NetworkImage(sequence[current].tag.artwork)),
              if (current != null) Text(sequence[current].tag.title),
              PlayerButtons(_audioPlayer),
              AudioProgressBar(
                _audioPlayer,
                durationState,
                noSeek: false,
              )
            ],
          );
        },
      ),
    );
  }
}
