import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

class GitHub {
  static String repo = 'Sangwan5688/BlackHole';
  static String baseUrl = 'api.github.com';
  static Map<String, String> headers = {};
  static Map<String, String> endpoints = {
    'repo': '/repos',
    'releases': '/releases',
  };
  Map releasesData = {};

  static final GitHub _singleton = GitHub._internal();
  factory GitHub() {
    return _singleton;
  }
  GitHub._internal();

  static Future<Response> getResponse() async {
    final Uri url = Uri.https(
      baseUrl,
      '${endpoints["repo"]}/$repo${endpoints["releases"]}',
    );

    return get(url, headers: headers).onError((error, stackTrace) {
      return Response(
        {
          'status': false,
          'message': error.toString(),
        }.toString(),
        404,
      );
    });
  }

  static Future<Map> fetchReleases() async {
    final res = await getResponse();
    if (res.statusCode == 200) {
      final resp = json.decode(res.body);
      if (resp is List) {
        return resp[0] as Map;
      } else if (resp is Map) {
        Logger.root.severe('Failed to fetch releases', resp['message']);
      }
    } else {
      Logger.root.severe('Failed to fetch releases', res.body);
    }
    return {};
  }

  static Future<String> getLatestVersion() async {
    Logger.root.info('Checking for update');
    final Map latestRelease = await fetchReleases();
    Logger.root.info(
      'Latest release: ${(latestRelease["tag_name"] as String?) ?? "v0.0.0"}',
    );
    return ((latestRelease['tag_name'] as String?) ?? 'v0.0.0')
        .replaceAll('v', '');
  }
}
