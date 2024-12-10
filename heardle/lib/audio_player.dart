import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);  // Load the audio file from assets
      await _audioPlayer.play();  // Play the audio
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();  // Stop the audio playback
  }

  void dispose() {
    _audioPlayer.dispose();  // Dispose the audio player when it's no longer needed
  }
}
