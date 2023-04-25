import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:flutter/material.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar(this._audioPlayer, this.durationStateStream,
      {Key? key, required this.noSeek})
      : super(key: key);
  final AudioPlayer _audioPlayer;
  final Stream<DurationState> durationStateStream;
  final bool noSeek;

  @override
  Widget build(BuildContext context) {
    if (noSeek)
      return _noSeekProgressBar();
    else
      return _progressBar();
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: durationStateStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: _audioPlayer.seek,
          // barHeight: _barHeight,
          bufferedBarColor: Color.fromRGBO(22, 50, 43, 1),
          baseBarColor: Color.fromRGBO(24, 42, 55, 1),
          progressBarColor: Colors.teal,
          thumbColor: Colors.teal,
          // thumbGlowColor: _thumbGlowColor,
          // barCapShape: _barCapShape,
          // thumbRadius: _thumbRadius,
          // thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
          // timeLabelLocation: _labelLocation,
          // timeLabelType: _labelType,
          // timeLabelTextStyle: _labelStyle,
          // timeLabelPadding: _labelPadding,
        );
      },
    );
  }

  StreamBuilder<DurationState> _noSeekProgressBar() {
    return StreamBuilder<DurationState>(
      stream: durationStateStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          barHeight: 5,
          // baseBarColor: _baseBarColor,
          // progressBarColor: _progressBarColor,
          // bufferedBarColor: _bufferedBarColor,
          // thumbColor: _thumbColor,
          thumbGlowColor: Colors.transparent,
          // barCapShape: _barCapShape,
          thumbRadius: 0,
          thumbCanPaintOutsideBar: false,
          timeLabelLocation: TimeLabelLocation.none,
          baseBarColor: Color.fromRGBO(46, 73, 93, 1),
          progressBarColor: Colors.teal,
        );
      },
    );
  }
}
