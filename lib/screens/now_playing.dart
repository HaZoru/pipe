import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/marquee_text.dart';
import 'package:pipe/screens/commons/player_buttons.dart';
import 'package:pipe/screens/commons/progress_bar.dart';
import 'package:pipe/screens/commons/queue.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying(
      {Key? key,
      required this.audioPlayer,
      required this.durationState,
      required this.pc,
      required this.title,
      required this.album,
      required this.artist,
      required this.arturl})
      : super(key: key);
  final AudioPlayer audioPlayer;
  final Stream<DurationState> durationState;
  final PanelController pc;
  final String title;
  final String album;
  final String artist;
  final String? arturl;

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      pc.close();
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Now Playing',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(album,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO
                    },
                  ),
                ),
              ]),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: arturl ?? '',
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
                        )),
                  ),
                ),
                SongDetails(
                    songTitle: title, artist: artist, albumTitle: album),
                SizedBox(
                  height: 10,
                ),
                AudioProgressBar(
                  audioPlayer,
                  durationState,
                  noSeek: false,
                ),
                PlayerButtonsRow(audioPlayer: audioPlayer),
              ],
            ),
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
                  child: Queue(audioPlayer: audioPlayer),
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
        MarqueeWidget(
          child: Text(
            songTitle,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        MarqueeWidget(
          child: Text(
            artist,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        MarqueeWidget(
          child: Text(
            albumTitle,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis),
          ),
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
                size: 40,
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
