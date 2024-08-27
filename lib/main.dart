import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/components/audioPlayer_comp.dart';
import 'package:tauker_mobile/components/recordAudio_comp.dart';
import 'package:tauker_mobile/pages/signin_page.dart';
import 'package:tauker_mobile/pages/profile_page.dart';
import 'package:tauker_mobile/trash/login_page2.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );



}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      // theme: ThemeData.dark().copyWith(
      //   primaryColor: Colors.green,
      //   textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //       foregroundColor: Colors.green,
      //     ),
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       foregroundColor: Colors.white,
      //       backgroundColor: Colors.green,
      //     ),
      //   ),
      // ),
      // home: supabase.auth.currentSession == null
      //     ? const LoginPage()
      //     : const ProfilePage(),
      // home: const AudioplayerComp(audioUrl: 'www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
      home: RecordAudioComp(),
      // home: SigninPage(),
    );
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}