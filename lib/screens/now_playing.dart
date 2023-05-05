import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/progress_bar.dart';
import 'package:pipe/screens/commons/queue.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying(this._audioPlayer, this.durationState,
      {Key? key, required this.pc})
      : super(key: key);
  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationState;
  final PanelController pc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        flexibleSpace: SafeArea(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      pc.close();
                    },
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Now Playing',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      StreamBuilder<SequenceState?>(
                          stream: _audioPlayer.sequenceStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final List sequence = state?.sequence ?? [];
                            final int? current = state?.currentIndex;
                            return Text(
                              current != null
                                  ? sequence[current].tag.album
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ]),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<SequenceState?>(
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
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (current != null)
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image(
                              image: NetworkImage(
                                  sequence[current].tag.artUri.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else
                      const Flexible(
                        child: Center(
                          child: Icon(Icons.audio_file),
                        ),
                      ),
                    SongDetails(
                        songTitle: songTitle,
                        artist: artist,
                        albumTitle: albumTitle),
                    AudioProgressBar(
                      _audioPlayer,
                      durationState,
                      noSeek: false,
                    ),
                    PlayerButtonsRow(audioPlayer: _audioPlayer),
                  ],
                ),
              );
            },
          ),
          DraggableScrollableSheet(
            minChildSize: 70 / MediaQuery.of(context).size.height,
            initialChildSize: 70 / MediaQuery.of(context).size.height,
            snap: true,
            builder: (context, scrollController) {
              return Material(
                elevation: 4,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Queue(audioPlayer: _audioPlayer),
                ),
              );
            },
          )
        ],
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
      mainAxisSize: MainAxisSize.max,
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
