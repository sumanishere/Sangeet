import 'dart:async';
import 'dart:io';
import 'package:sangeet_music/Helpers/config.dart';
import 'package:sangeet_music/Helpers/countrycodes.dart';
import 'package:sangeet_music/Helpers/handle_native.dart';
import 'package:sangeet_music/Helpers/import_export_playlist.dart';
import 'package:sangeet_music/Helpers/logging.dart';
import 'package:sangeet_music/Helpers/route_handler.dart';
import 'package:sangeet_music/Screens/About/about.dart';
import 'package:sangeet_music/Screens/Home/home.dart';
import 'package:sangeet_music/Screens/Library/downloads.dart';
import 'package:sangeet_music/Screens/Library/nowplaying.dart';
import 'package:sangeet_music/Screens/Library/playlists.dart';
import 'package:sangeet_music/Screens/Library/recent.dart';
import 'package:sangeet_music/Screens/Login/auth.dart';
import 'package:sangeet_music/Screens/Login/pref.dart';
import 'package:sangeet_music/Screens/Player/audioplayer.dart';
import 'package:sangeet_music/Screens/Settings/setting.dart';
import 'package:sangeet_music/Services/audio_service.dart';
import 'package:sangeet_music/theme/app_theme.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('Sangeet');
  } else {
    await Hive.initFlutter();
  }
  await openHiveBox('settings');
  await openHiveBox('downloads');
  await openHiveBox('stats');
  await openHiveBox('Favorite Songs');
  await openHiveBox('cache', limit: true);
  await openHiveBox('ytlinkcache', limit: true);
  if (Platform.isAndroid) {
    setOptimalDisplayMode();
  }
  await startService();
  runApp(MyApp());
}

Future<void> setOptimalDisplayMode() async {
  await FlutterDisplayMode.setHighRefreshRate();
  final List<DisplayMode> supported = //chnaged by suman
      await FlutterDisplayMode.supported; //changed by suman
  final DisplayMode active = await FlutterDisplayMode.active; //changed by suman

  final List<DisplayMode> sameResolution = supported //changed by suman
      .where(
        //changed by suman
        (DisplayMode m) =>
            m.width == active.width &&
            m.height == active.height, //changed by suman
      ) //changed by suman
      .toList() //changed by suman
    ..sort(
      //changed by suman
      (DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate), //changed by suman
    ); //changed by suman

  final DisplayMode mostOptimalMode = //changed by suman
      sameResolution.isNotEmpty
          ? sameResolution.first
          : active; //changed by suman

  await FlutterDisplayMode.setPreferredMode(mostOptimalMode); //changed by suman
}

Future<void> startService() async {
  await initializeLogging();
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.suman.sangeet.channel.audio',
      androidNotificationChannelName: 'Sangeet',
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
      notificationColor: Colors.grey[900],
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    Logger.root.severe('Failed to open $boxName Box', error, stackTrace);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/Sangeet/$boxName.hive');
      lockFile = File('$dirPath/Sangeet/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  late StreamSubscription _intentTextStreamSubscription;
  late StreamSubscription _intentDataStreamSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _intentTextStreamSubscription.cancel();
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final String systemLangCode = Platform.localeName.substring(0, 2);
    if (ConstantCodes.languageCodes.values.contains(systemLangCode)) {
      _locale = Locale(systemLangCode);
    } else {
      final String lang =
          Hive.box('settings').get('lang', defaultValue: 'English') as String;
      _locale = Locale(ConstantCodes.languageCodes[lang] ?? 'en');
    }

    AppTheme.currentTheme.addListener(() {
      setState(() {});
    });

    _intentTextStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        Logger.root.info('Received intent on stream: $value');
        handleSharedText(value, navigatorKey);
      },
      onError: (err) {
        Logger.root.severe('ERROR in getTextStream', err);
      },
    );

    ReceiveSharingIntent.getInitialText().then(
      (String? value) {
        Logger.root.info('Received Intent initially: $value');
        if (value != null) handleSharedText(value, navigatorKey);
      },
      onError: (err) {
        Logger.root.severe('ERROR in getInitialTextStream', err);
      },
    );

    // For sharing files coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          for (final file in value) {
            if (file.path.endsWith('.json')) {
              final List playlistNames = Hive.box('settings')
                      .get('playlistNames')
                      ?.toList() as List? ??
                  ['Favorite Songs'];
              importFilePlaylist(
                null,
                playlistNames,
                path: file.path,
                pickFile: false,
              ).then(
                (value) => navigatorKey.currentState?.pushNamed('/playlists'),
              );
            }
          }
        }
      },
      onError: (err) {
        Logger.root.severe('ERROR in getDataStream', err);
      },
    );

    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        for (final file in value) {
          if (file.path.endsWith('.json')) {
            final List playlistNames =
                Hive.box('settings').get('playlistNames')?.toList() as List? ??
                    ['Favorite Songs'];
            importFilePlaylist(
              null,
              playlistNames,
              path: file.path,
              pickFile: false,
            ).then(
              (value) => navigatorKey.currentState?.pushNamed('/playlists'),
            );
          }
        }
      }
    });
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  Widget initialFuntion() {
    return Hive.box('settings').get('userId') != null
        ? HomePage()
        : AuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppTheme.themeMode == ThemeMode.dark
            ? Colors.black38
            : Colors.white,
        statusBarIconBrightness: AppTheme.themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: AppTheme.themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Sangeet',
      restorationScopeId: 'sangeet',
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.themeMode,
      theme: AppTheme.lightTheme(
        context: context,
      ),
      darkTheme: AppTheme.darkTheme(
        context: context,
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ConstantCodes.languageCodes.entries
          .map((languageCode) => Locale(languageCode.value, ''))
          .toList(),
      routes: {
        '/': (context) => initialFuntion(),
        '/pref': (context) => const PrefScreen(),
        '/setting': (context) => const SettingPage(),
        '/about': (context) => AboutScreen(),
        '/playlists': (context) => PlaylistScreen(),
        '/nowplaying': (context) => NowPlaying(),
        '/recent': (context) => RecentlyPlayed(),
        '/downloads': (context) => const Downloads(),
      },
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/player') {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => const PlayScreen(),
          );
        }
        return HandleRoute.handleRoute(settings.name);
      },
    );
  }
}
