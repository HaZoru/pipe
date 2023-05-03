import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key, required this.audioPlayer, required this.sc})
      : super(key: key);

  final AudioPlayer audioPlayer;
  final ScrollController sc;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: ListView(
        padding: EdgeInsets.all(0),
        controller: sc,
        children: [
          StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final sequence = state?.sequence ?? [];
              return Column(
                children: [
                  for (var i = 0; i < sequence.length; i++)
                    ListTile(
                      selected: i == state?.currentIndex,
                      leading: Image.network(sequence[i].tag.artwork),
                      title: Text(sequence[i].tag.title),
                      onTap: () {
                        audioPlayer.seek(Duration.zero, index: i);
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
