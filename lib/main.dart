import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/screens/HomeScreen.dart';
import 'package:tauker_mobile/screens/auth_ui.dart';
import 'package:tauker_mobile/screens/user_signin.dart';
import 'package:tauker_mobile/screens/user_signup.dart';

void main() async {
  await Supabase.initialize(
    );
  runApp(MyApp());
}
final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase Auth',
      initialRoute: '/login',
      routes: {
        '/login': (context) => UserSignup(),
        '/homeScreen': (context) => const HomeScreen(),
      },
      // home: AuthStateHandler(),
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.session != null) {
          return const HomeScreen(); // The screen after successful sign-in
        } else {
          return UserSignup(); // The unified authentication screen
        }
      },
    );
  }
}
