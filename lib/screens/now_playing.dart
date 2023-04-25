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
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.expand_more),
        ),
        leadingWidth: 30,
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            StreamBuilder<SequenceState?>(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final List sequence = state?.sequence ?? [];
                  final int? current = state?.currentIndex;
                  return Text(
                    current != null ? sequence[current].tag.album : '',
                    style: TextStyle(fontSize: 16),
                  );
                })
          ],
        ),
      ),
      body: StreamBuilder<SequenceState?>(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final List sequence = state?.sequence ?? [];
          final int? current = state?.currentIndex;
          final String songTitle =
              current != null ? sequence[current].tag.title : '';
          final String artist =
              current != null ? sequence[current].tag.artist : '';
          final String albumTitle =
              current != null ? sequence[current].tag.album : '';
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (current != null)
                  Flexible(
                    flex: 4,
                    child: Image(
                      image: NetworkImage(sequence[current].tag.artwork),
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Flexible(
                    flex: 4,
                    child: Center(
                      child: Icon(Icons.audio_file),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                    flex: 1,
                    child: SongDetails(
                        songTitle: songTitle,
                        artist: artist,
                        albumTitle: albumTitle)),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      AudioProgressBar(
                        _audioPlayer,
                        durationState,
                        noSeek: false,
                      ),
                      PlayerButtonsRow(audioPlayer: _audioPlayer),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SongDetails extends StatelessWidget {
  const SongDetails({
    Key? key,
    required this.songTitle,
    required this.artist,
    required this.albumTitle,
  }) : super(key: key);

  final String songTitle;
  final String artist;
  final String albumTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          songTitle,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
        Text(
          artist,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis),
        ),
        Text(
          albumTitle,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class PlayerButtonsRow extends StatelessWidget {
  const PlayerButtonsRow({
    Key? key,
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(key: key);

  final AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StreamBuilder<LoopMode>(
          stream: _audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            return RepeatButton(
              audioPlayer: _audioPlayer,
              context: context,
              loopMode: snapshot.data ?? LoopMode.off,
              size: 30,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: _audioPlayer.sequenceStateStream,
          builder: (_, __) {
            return PreviousButton(
              audioPlayer: _audioPlayer,
              size: 30,
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (_, snapshot) {
            final playerState = snapshot.data;
            return PlayPauseButton(
                withRoundContainer: true,
                size: 60,
                audioPlayer: _audioPlayer,
                playerState: playerState);
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: _audioPlayer.sequenceStateStream,
          builder: (_, __) {
            return NextButton(
              audioPlayer: _audioPlayer,
              size: 30,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: _audioPlayer.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            return ShuffleButton(
              audioPlayer: _audioPlayer,
              context: context,
              isEnabled: snapshot.data ?? false,
              size: 30,
            );
          },
        ),
      ],
    );
  }
}
