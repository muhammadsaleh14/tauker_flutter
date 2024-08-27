import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/components/buttons/myButton_comp.dart';
import 'package:tauker_mobile/components/myTextField_comp.dart';
import 'package:tauker_mobile/components/squareTile_comp.dart';
import 'package:tauker_mobile/main.dart';
import 'package:tauker_mobile/pages/profile_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  // text editing controllers
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        }
      },
      onError: (error) {
        print('error from onError ${error.toString()}');

        if (error is AuthException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unexpected error'),
                backgroundColor: Colors.red,
              ),
            );
            if (kDebugMode) {
              print(error.toString());
            }
          }
        }
      },
    );
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _signingIn = true;

  Future<void> signUpNewUser() async {
    try {
      print('$_emailController.text  $_passwordController.text' );
      final AuthResponse res = await supabase.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          emailRedirectTo:  kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
          data: {
            'username': _usernameController
          });
    } catch (error) {
      if (mounted) {
        print('printing error if any: ${error.toString()}');
        _handleAuthError(context, error);
      }
    }
  }

  Future<void> signInWithEmail() async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
          email: _emailController.text, password: _passwordController.text);
    } catch (error) {
      if (mounted) {
        _handleAuthError(context, error);
      }
    }
  }

  void _handleAuthError(BuildContext context, Object error) {
    if (error is AuthException) {
      if (mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } else {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
        if (kDebugMode) {
          print(error.toString());
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            // logo
            const Icon(
              Icons.lock,
              size: 100,
            ),

            const SizedBox(height: 50),

            // welcome back, you've been missed!
            Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // Email textfield
            MyTextFieldComp(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextFieldComp(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // username text field if signing up
            Visibility(
              visible: !_signingIn,
              child: MyTextFieldComp(
                controller: _usernameController,
                hintText: 'Enter new username',
                obscureText: false,
              ),
            ),

            const SizedBox(height: 10),
            // forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // sign in button
            MyButtonComp(
                onTap: _signingIn ? signInWithEmail : signUpNewUser,
                text: _signingIn ? 'Sign in' : 'Sign up'),

            const SizedBox(height: 50),

            // or continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // google + apple sign in buttons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google button
                SquareTileComp(imagePath: 'lib/images/google.png'),

                SizedBox(width: 25),

                // apple button
                SquareTileComp(imagePath: 'lib/images/apple.png')
              ],
            ),

            const SizedBox(height: 10),

            // not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _signingIn ? 'Not a member?' : 'Already a member',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _signingIn = !_signingIn;
                    });
                  },
                  child: Text(
                    _signingIn ? 'Register now' : 'Sign in',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
