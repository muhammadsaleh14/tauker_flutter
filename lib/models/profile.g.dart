// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      username: json['username'] as String,
      avatar_url: json['avatar_url'] as String?,
      intro_audio_url: json['intro_audio_url'] as String?,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'avatar_url': instance.avatar_url,
      'intro_audio_url': instance.intro_audio_url,
    };
