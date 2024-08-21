  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/components/audioPlayer_comp.dart';
  import 'package:tauker_mobile/components/avatar_comp.dart';
  import 'package:tauker_mobile/main.dart';
  import 'package:tauker_mobile/pages/login_page2.dart';
  import 'package:tauker_mobile/providers/profile_provider.dart';

  class ProfilePage extends ConsumerStatefulWidget {
    const ProfilePage({super.key});


    @override
    ConsumerState<ProfilePage> createState() => _AccountPageState();
  }

  class _AccountPageState extends ConsumerState<ProfilePage> {

    //Followers subscriptions following text style
    static const TextStyle _labelsTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    /// Called once a user id is received within `onAuthenticated()`


    @override
    void initState() {
      super.initState();
      // _getProfile();
      final userId = supabase.auth.currentSession?.user.id;
      if (userId != null) {
        // Change the current profile ID using the provider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(currentProfileIdNotifierProvider.notifier).changeCurrentProfileId(userId);
        });
      }
    }

    @override
    Widget build(BuildContext context) {


      final profileState = ref.watch(profileNotifierProvider);
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body:
        profileState.when(
            data: (profile){
              print("avatar url value in profile page ${profile.avatar_url}");

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
                  const AvatarComp(),
                  const SizedBox(height: 18),
                  Center(
                      child: Text(profile.username,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2))

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
                  ),
                  const SizedBox(height: 18),
                  AudioplayerComp(audioUrl: null),
                  const SizedBox(height: 18),
                  TextButton(onPressed: _signOut, child: const Text('Sign Out')),
                ],
              );
        },
            error: (error,stack){
              return Center(
                child: Text('Error occured $error')
              );
        },
            loading: (){
              return const Center(child:Text('Loading'));
        })
      );
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
            MaterialPageRoute(builder: (_) => const LoginPage2()),
          );
        }
      }
    }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget

  }
