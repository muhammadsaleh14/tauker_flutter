import 'package:flutter/material.dart';

class RecordAudioComp extends StatefulWidget {
  const RecordAudioComp({super.key});

  @override
  State<RecordAudioComp> createState() => _RecordAudioCompState();
}

class _RecordAudioCompState extends State<RecordAudioComp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
          onPressed: (){},
          child: const Text('Add introduction audio')))
    );
  }
}
