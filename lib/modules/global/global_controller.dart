import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalController {
  static final cliente = Supabase.instance.client;
}
