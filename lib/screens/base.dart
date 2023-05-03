import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pipe/models/duration_state.dart';
import 'package:pipe/screens/commons/miniplayer.dart';
import 'package:pipe/screens/commons/queue.dart';
import 'package:pipe/screens/now_playing.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Base extends StatefulWidget {
  Base({
    Key? key,
    required this.child,
    required this.audioPlayer,
    required this.durationState,
    required this.pc,
  }) : super(key: key);

  final Widget child;
  final AudioPlayer audioPlayer;
  final Stream<DurationState> durationState;
  final PanelController pc;

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  bool panelOpened = false;
  double opacity = 0;
  late PanelController queuePc;
  bool queueHidden = true;
  bool draggable = true;

  @override
  void initState() {
    // TODO: implement initState
    queuePc = PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          isDraggable: true,
          isPanelVisible: false,
          onPanelSlide: (position) {
            setState(() {
              opacity = position;
            });
          },
          controller: widget.pc,
          collapsed: MiniPlayer(
            audioPlayer: widget.audioPlayer,
            durationState: widget.durationState,
            pc: widget.pc,
          ),
          maxHeight: MediaQuery.of(context).size.height,
          minHeight: 80,
          panel: Scaffold(
            body: AnimatedOpacity(
              opacity: opacity,
              duration: Duration.zero,
              child: NowPlaying(
                widget.audioPlayer,
                widget.durationState,
                pc: widget.pc,
              ),
            ),
          ),
          body: widget.child),
    );
  }
}
