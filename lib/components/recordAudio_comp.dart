import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:tauker_mobile/components/audioPlayer_comp.dart';
import 'package:tauker_mobile/components/widgets/sliderVertical_widget.dart';

class RecordAudioComp extends StatefulWidget {
  const RecordAudioComp({super.key});

  @override
  State<RecordAudioComp> createState() => _RecordAudioCompState();
}

class _RecordAudioCompState extends State<RecordAudioComp> {
  final GlobalKey<SliderVerticalWidgetState> amplitudeSliderKey =
      GlobalKey<SliderVerticalWidgetState>();
  final GlobalKey<SliderVerticalWidgetState> tempoSliderKey =
      GlobalKey<SliderVerticalWidgetState>();
  final GlobalKey<SliderVerticalWidgetState> pitchSliderKey =
  GlobalKey<SliderVerticalWidgetState>();

  final _recorder = AudioRecorder();

  // for displaying original audio
  bool _isDefault = true;

  //for activating button
  bool _isConfigChanged = false;
  bool _isRecording = false;
  bool _isProcessingAudio = false;
  String? _originalRecordedFilePath;
  String? _modifiedFilePath;

  void _restoreDefaults() {
    amplitudeSliderKey.currentState!.resetValue();
    tempoSliderKey.currentState!.resetValue();
    pitchSliderKey.currentState!.resetValue();


    _modifyAudio(); // this ftn alters the state of _isDefault to false, so below it is set to true
    setState(() {
      _isDefault = true;
    });
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      Directory tempDir = await getTemporaryDirectory();
      _originalRecordedFilePath = '${tempDir.path}/recorded_audio.m4a';
      if (_originalRecordedFilePath == null) {
        return;
      }
      try {
        final file = File(_originalRecordedFilePath!);
        if (await file.exists()) file.delete();
      } catch (e) {
        print('Error deleting file');
        e.toString();
      }
      await _recorder.start(const RecordConfig(),
          path: _originalRecordedFilePath!);

      setState(() {
        _isRecording = true;
      });
    } else {
      // Handle permissions error
      print("Permission not granted for recording.");
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() {
      _isRecording = false;
    });
    _modifyAudio();
  }

  Future<void> _modifyAudio() async {
    if (_originalRecordedFilePath == null) return;

    Directory tempDir = await getTemporaryDirectory();
    _modifiedFilePath = '${tempDir.path}/amplified_audio.m4a';
    try {
      final file = File(_modifiedFilePath!);
      if (await file.exists()) file.delete();
    } catch (e) {
      print('Error deleting file');
      e.toString();
    }
    print(
        'pitch value ${pitchSliderKey.currentState!.value}');

    String command = '-i "$_originalRecordedFilePath" -filter:a '
        'asetrate=44100*${pitchSliderKey.currentState!.value},'
        'aresample=44100,'
        'atempo=1/${pitchSliderKey.currentState!.value},'
        'volume=${amplitudeSliderKey.currentState!.value},'
        'atempo=${tempoSliderKey.currentState!.value} '
        '"$_modifiedFilePath"';

    setState(() {
      // _isDefault = false; Now changed before calling ftn
      _isProcessingAudio = true;
    });
    await FFmpegKit.execute(command).then((session) async {
      // Check if the command has completed successfully
      final returnCode = await session.getReturnCode();
      if (returnCode != null && returnCode.isValueSuccess()) {
        print('FFmpeg command completed successfully.');
        // Handle successful completion here (e.g., update UI, proceed with next steps)
      }
        final output = await session.getOutput();
        final failStackTrace = await session.getFailStackTrace();
      final logs = await session.getLogs();
        print('output ffmpeg $output');
        print('fail Stack Tracve $failStackTrace');
        print('logs ffmpeg ');
        logs.forEach((log){
          print(log.getMessage());
        });
      // Set state after processing is completed
    });
    setState(() {
      _isProcessingAudio = false;
      _isConfigChanged = false;
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Recorder & Amplifier"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            Text('isconfigchanged $_isConfigChanged'),
            ElevatedButton(
              onPressed: (_originalRecordedFilePath != null &&
                      _isConfigChanged == true)
                  ? () {
                      _modifyAudio();
                      setState(() {
                        _isDefault = false;
                      });
                    }
                  : null,
              child: const Text("Modify Audio"),
            ),
            ElevatedButton(
              onPressed: (_isDefault == false) ? _restoreDefaults : null,
              child: const Text("Restore defaults"),
            ),
            _isProcessingAudio
                ? Center(
                    child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.blue, size: 20))
                : (_modifiedFilePath != null && !_isRecording)
                    ? Column(
                        children: [
                          const Center(child: Text("Audio")),
                          AudioPlayerComp(audioUrl: _modifiedFilePath),
                        ],
                      )
                    : const SizedBox(height: 20),
            Row(
              children: [
                SliderVerticalWidget(
                  key: amplitudeSliderKey,
                  defaultValue: 1.0,
                  min: 0.5,
                  max: 10.0,
                  divisions: 10,
                  label: 'Amplitude',
                  onChanged: () {
                    setState(() {
                      _isConfigChanged = true;
                    });
                  },
                ),
                SliderVerticalWidget(
                  key: tempoSliderKey,
                  defaultValue: 1.0,
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  label: 'Tempo',
                  onChanged: () {
                    setState(() {
                      _isConfigChanged = true;
                    });
                  },
                ),
                SliderVerticalWidget(
                  key: pitchSliderKey,
                  defaultValue: 1.0,
                  min: 0.2,
                  max: 2,
                  divisions: 9,
                  label: 'Pitch',
                  onChanged: () {
                    setState(() {
                      _isConfigChanged = true;
                    });
                  },
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
