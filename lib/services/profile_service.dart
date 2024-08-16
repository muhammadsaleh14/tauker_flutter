import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tauker_mobile/main.dart';
import 'package:tauker_mobile/models/profile.dart';

class ProfileService{
  Future<PostgrestMap> getProfile(String userId) async {
      final data = await supabase.from('profiles').select().eq('id', userId).single();
      return data;
  }
}