import 'package:supabase/supabase.dart';

class SupaBase {
  final SupabaseClient client = SupabaseClient(
    'https://ffdupvjhneqtjvftkmfz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmZHVwdmpobmVxdGp2ZnRrbWZ6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4NDQxNTQ2OCwiZXhwIjoxOTk5OTkxNDY4fQ.Y9Mmhk92c7Cn-zqeY9cHpj_KfJ9sfbDOBYLIoFb97b0',
  );

  Future<Map> getUpdate() async {
    final response =
        await client.from('Update').select().order('LatestVersion');
    final List result = response.data as List;
    return result.isEmpty
        ? {}
        : {
            'LatestVersion': response.data[0]['LatestVersion'],
            'LatestUrl': response.data[0]['LatestUrl'],
            'arm64-v8a': response.data[0]['arm64-v8a'],
            'armeabi-v7a': response.data[0]['armeabi-v7a'],
            'universal': response.data[0]['universal'],
          };
  }

  Future<void> updateUserDetails(
    String? userId,
    String key,
    dynamic value,
  ) async {
    // final response = await client.from('Users').update({key: value},
    //     returning: ReturningOption.minimal).match({'id': userId}).execute();
    // print(response.toJson());
  }

  Future<void> createUser(Map data) async {
    await client.from('Users').insert(data);
  }
}
