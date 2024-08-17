  import 'dart:convert';
  import 'package:image_picker/image_picker.dart';
  import 'package:riverpod_annotation/riverpod_annotation.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
  import 'package:tauker_mobile/main.dart';
  import 'package:tauker_mobile/models/profile.dart';

  part 'profile_provider.g.dart';

  @riverpod
  class CurrentProfileIdNotifier extends _$CurrentProfileIdNotifier {
    @override
    String? build() {
      return null; // Initial state can be null
    }

    void changeCurrentProfileId(String? userId) {
      state = userId;
    }
  }

  @riverpod
  class ProfileNotifier extends _$ProfileNotifier {
    @override
    Future<Profile> build() async {
      final profileId = ref.watch(currentProfileIdNotifierProvider);
      // var profileId = supabase.auth.currentSession?.user.id;
      // Handle the case where profileId is null
      if (profileId == null) {
        throw Exception('Profile ID is null');
      }

      print('Running build for provider with profileId: $profileId');
      throw Exception("kdnjsn");
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', profileId)
          .single();

      return Profile.fromJson(data);
    }

    Future<void> editAvatar(XFile imageFile) async {
      final profileId = ref.read(currentProfileIdNotifierProvider);
      // Handle the case where profileId is null
      if (profileId == null) {
        throw Exception('Profile ID is null');
      }

      try {
        final bytes = await imageFile.readAsBytes();
        final fileExt = imageFile.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;

        await supabase.storage.from('avatars').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: imageFile.mimeType),
        );

        final imageUrlResponse = await supabase.storage
            .from('avatars')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

        await supabase.from('profiles').upsert({
          'id': profileId,
          'avatar_url': imageUrlResponse,
        });

        final previousState = await future;
        Profile newProfileState = previousState.copyWith(avatar_url: imageUrlResponse);
        state = AsyncData(newProfileState);
      } catch (error) {
        print('Error uploading avatar: $error');
        rethrow; // Consider handling this error in the UI
      }
    }
  }
