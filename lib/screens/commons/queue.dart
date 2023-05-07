import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key, required this.audioPlayer}) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.horizontal_rule_rounded,
                weight: 40,
              ),
              Text(
                'Queue',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
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
                    leading: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        imageUrl: sequence[i].tag.artUri.toString()),
                    title: Text(
                      sequence[i].tag.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(sequence[i].tag.album,
                        overflow: TextOverflow.ellipsis),
                    onTap: () {
                      audioPlayer.seek(Duration.zero, index: i);
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
