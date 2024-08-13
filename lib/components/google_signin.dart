import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';





class GoogleSignInButton extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _handleGoogleSignIn(context);
      },
      child: Text('Login with Google'),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthResponse response = await Supabase.instance.client.auth.signInWithOAuth(
        Provider.google,
        accessToken: googleAuth.idToken,
      );

      if (response.error == null) {
        // Google login successful
        print('User logged in with Google successfully');
      } else {
        // Handle login error
        print('Google login error: ${response.error!.message}');
      }
    } catch (error) {
      print('Google login error: $error');
    }
  }
}
