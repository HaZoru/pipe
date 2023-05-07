import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    Key? key,
    required this.audioPlayer,
    required this.context,
    required this.isEnabled,
    this.size,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final BuildContext context;
  final bool isEnabled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isEnabled
          ? Icon(
              Icons.shuffle,
              size: size,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(
              Icons.shuffle,
              size: size,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await audioPlayer.shuffle();
        }
        await audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    Key? key,
    required this.audioPlayer,
    required this.context,
    required this.loopMode,
    this.size,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final BuildContext context;
  final LoopMode loopMode;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icon(
        Icons.repeat,
        size: size,
      ),
      Icon(Icons.repeat,
          size: size, color: Theme.of(context).colorScheme.primary),
      Icon(Icons.repeat_one,
          size: size, color: Theme.of(context).colorScheme.primary),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key? key,
    required this.audioPlayer,
    this.size,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.skip_previous,
        size: size,
      ),
      onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.audioPlayer,
    this.size,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.skip_next,
        size: size,
      ),
      onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key? key,
    required this.audioPlayer,
    required this.playerState,
    this.withRoundContainer = false,
    this.size,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final PlayerState? playerState;
  final bool withRoundContainer;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return withRoundContainer
        ? Container(
            padding: const EdgeInsets.all(8),
            child: determineIcon(),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(40))),
          )
        : determineIcon();
  }

  StatelessWidget determineIcon() {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: EdgeInsets.all(8.0),
        height: size,
        width: size,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (audioPlayer.playing != true) {
      return IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: size,
        ),
        onPressed: audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: Icon(
          Icons.pause,
          size: size,
        ),
        onPressed: audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.replay,
          size: size,
        ),
        onPressed: () => audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices!.first),
      );
    }
  }
}
