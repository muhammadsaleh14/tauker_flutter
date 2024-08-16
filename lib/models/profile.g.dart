// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      introAudioUrl: json['introAudioUrl'] as String?,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'introAudioUrl': instance.introAudioUrl,
    };
