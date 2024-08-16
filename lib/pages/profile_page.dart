import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/components/avatar.dart';
import 'package:tauker_mobile/main.dart';
import 'package:tauker_mobile/pages/login_page.dart';
import 'package:tauker_mobile/providers/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<ProfilePage> {
  String _username = '';
  String? _avatarUrl;
  var _loading = true;

  //Followers subscriptions following text style
  static const TextStyle _labelsTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  /// Called once a user id is received within `onAuthenticated()`


  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {

    final profileState = ref.watch(profileNotifierProvider('12'));
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileState.when(
          data: (profile){
            ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                Avatar(
                  imageUrl: _avatarUrl,
                ),
                const SizedBox(height: 18),
                Center(
                    child: Text(_username,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2))

                ) ,
                const SizedBox(height: 18),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    // Followers Column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Followers',
                            style: _labelsTextStyle,
                          ),
                          SizedBox(height: 8), // Spacing between text and number
                          Text(
                            '1,234',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Subscriptions Column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Subscriptions',
                            style: _labelsTextStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '567',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Following Column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Following',
                            style: _labelsTextStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '789',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                // Display the username as a simple label
                ,
                const SizedBox(height: 18),
                TextButton(onPressed: _signOut, child: const Text('Sign Out')),
              ],
            );
      },
          error: (error,stack){

      },
          loading: (){

      })
    );
  }

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
      await supabase.from('profiles').select().eq('id', userId).single();
      _username = (data['username'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

/// Called when image has been uploaded to Supabase storage from within Avatar widget

}
