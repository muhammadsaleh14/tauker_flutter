import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@unfreezed
class Profile with _$Profile {
  factory Profile({
    required String username,
    String? avatarUrl,
    String? introAudioUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}