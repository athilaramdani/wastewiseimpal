import 'package:supabase_flutter/supabase_flutter.dart';

class SClient {
  static SupabaseClient get I => Supabase.instance.client;
}
