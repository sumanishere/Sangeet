//

import 'dart:io';

import 'package:Sangeet/Screens/Library/liked.dart';
import 'package:Sangeet/Screens/LocalMusic/downed_songs.dart';
import 'package:Sangeet/Screens/LocalMusic/downed_songs_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        AppBar(
          title: Text(
            AppLocalizations.of(context)!.library,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: (rotated && screenWidth < 1050)
              ? null
              : Builder(
                  builder: (BuildContext context) {
                    return Transform.rotate(
                      angle: 22 / 7 * 2,
                      child: IconButton(
                        color: Theme.of(context).iconTheme.color,
                        icon: const Icon(
                          Icons.horizontal_split_rounded,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      ),
                    );
                  },
                ),
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.nowPlaying,
          icon: Icons.queue_music_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.lastSession,
          icon: Icons.history_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/recent');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.favorites,
          icon: Icons.favorite_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LikedSongs(
                  playlistName: 'Favorite Songs',
                  showName: AppLocalizations.of(context)!.favSongs,
                ),
              ),
            );
          },
        ),
        if (!Platform.isIOS)
          LibraryTile(
            title: AppLocalizations.of(context)!.myMusic,
            icon: MdiIcons.folderMusic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (Platform.isWindows || Platform.isLinux)
                      ? const DownloadedSongsDesktop()
                      : const DownloadedSongs(
                          showPlaylists: true,
                        ),
                ),
              );
            },
          ),
        LibraryTile(
          title: AppLocalizations.of(context)!.downs,
          icon: Icons.download_done_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/downloads');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.playlists,
          icon: Icons.playlist_play_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
          },
        ),
      ],
    );
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
