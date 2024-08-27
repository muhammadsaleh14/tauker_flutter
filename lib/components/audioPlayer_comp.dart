import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:tauker_mobile/state_management/audioPlayer_manager.dart';

class AudioPlayerComp extends StatefulWidget {
  final String? audioUrl;
  const AudioPlayerComp({super.key, required this.audioUrl});

  @override
  State<AudioPlayerComp> createState() => _AudioPlayerCompState();
}

class _AudioPlayerCompState extends State<AudioPlayerComp> {
  late final AudioPlayerManager _pageManager;

  @override
  void initState() {
    super.initState();
    if(widget.audioUrl != null){
      _pageManager = AudioPlayerManager(audioUrl: widget.audioUrl!);
    }

  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioUrl == null){
      return const Center(child: Text('No Audio,add button here'));
    }
    return
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  onSeek: _pageManager.seek,
                  total: value.total,
                );
              },
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
          ],
        ),
      );
  }
}
