import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> downloadChecker() async {
  final List songs = Hive.box('downloads').values.toList();
  final List<String> keys = await compute(checkPaths, songs);
  await Hive.box('downloads').deleteAll(keys);
}

Future<List<String>> checkPaths(List songs) async {
  final List<String> res = [];
  for (final song in songs) {
    final bool value = await File(song['path'].toString()).exists();
    if (!value) res.add(song['id'].toString());
  }
  return res;
}
