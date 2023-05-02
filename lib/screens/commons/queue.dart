import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key, required this.audioPlayer}) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
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
    );
  }
}
