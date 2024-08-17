// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentProfileIdNotifierHash() =>
    r'c7733773c5389825d1c0c16a93904f60328e6306';

/// See also [CurrentProfileIdNotifier].
@ProviderFor(CurrentProfileIdNotifier)
final currentProfileIdNotifierProvider =
    AutoDisposeNotifierProvider<CurrentProfileIdNotifier, String?>.internal(
  CurrentProfileIdNotifier.new,
  name: r'currentProfileIdNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileIdNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentProfileIdNotifier = AutoDisposeNotifier<String?>;
String _$profileNotifierHash() => r'00c024ebc2e22e274ea515506dd1d8ddf056543b';

/// See also [ProfileNotifier].
@ProviderFor(ProfileNotifier)
final profileNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, Profile>.internal(
  ProfileNotifier.new,
  name: r'profileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileNotifier = AutoDisposeAsyncNotifier<Profile>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
