import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/main.dart';
import 'package:tauker_mobile/models/profile.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<Profile> build(String userId) async {
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    return Profile.fromJson(data);
  }
  Future<void> editAvatar(String userId, XFile imageFile) async {
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
      'id': userId,
      'avatar_url': imageUrlResponse,
    });

  }
}
