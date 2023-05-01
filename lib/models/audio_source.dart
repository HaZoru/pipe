// Feed your own stream of bytes into the player
import 'package:just_audio/just_audio.dart';

class NewAudioSource extends StreamAudioSource {
  final List<int> bytes;
  NewAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
