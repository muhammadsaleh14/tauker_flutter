class Profile {
  String username;
  String? avatarUrl;
  String? introAudioUrl;

  Profile({
    required this.username,
    this.avatarUrl,
    this.introAudioUrl,
  });
}