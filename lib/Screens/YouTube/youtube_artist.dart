//

import 'package:Sangeet/CustomWidgets/bouncy_sliver_scroll_view.dart';
import 'package:Sangeet/CustomWidgets/copy_clipboard.dart';
import 'package:Sangeet/CustomWidgets/gradient_containers.dart';
import 'package:Sangeet/CustomWidgets/miniplayer.dart';
import 'package:Sangeet/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:Sangeet/Services/player_service.dart';
import 'package:Sangeet/Services/youtube_services.dart';
import 'package:Sangeet/Services/yt_music.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

class YouTubeArtist extends StatefulWidget {
  final String artistId;

  const YouTubeArtist({
    super.key,
    required this.artistId,
  });

  @override
  _YouTubeArtistState createState() => _YouTubeArtistState();
}

class _YouTubeArtistState extends State<YouTubeArtist> {
  bool status = false;
  Map<String, dynamic> data = {};
  bool fetched = false;
  bool done = true;
  final ScrollController _scrollController = ScrollController();
  String artistName = '';
  String artistSubtitle = '';
  String artistImage = '';
  List<Map> searchedList = [];

  @override
  void initState() {
    if (!status) {
      status = true;
      YtMusicService().getArtistDetails(widget.artistId).then((value) {
        setState(() {
          try {
            data = value;
            searchedList = data['songs'] as List<Map>;
            artistName = value['name'] as String? ?? '';
            artistSubtitle = value['subtitle'] as String? ?? '';
            artistImage = value['images']?.last as String? ?? '';
            fetched = true;
          } catch (e) {
            Logger.root.severe('Error in fetching artist details', e);
            fetched = true;
          }
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cntxt) {
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  if (!fetched)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    BouncyImageSliverScrollView(
                      scrollController: _scrollController,
                      title: artistName,
                      imageUrl: artistImage,
                      fromYt: true,
                      sliverList: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            if (searchedList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.songs,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ...searchedList.map(
                              (Map entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                  ),
                                  child: ListTile(
                                    leading: Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: SizedBox.square(
                                        dimension: 50,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          errorWidget: (context, _, __) =>
                                              const Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/cover.jpg',
                                            ),
                                          ),
                                          imageUrl: entry['image'].toString(),
                                          placeholder: (context, url) =>
                                              const Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/cover.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      entry['title'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onLongPress: () {
                                      copyToClipboard(
                                        context: context,
                                        text: entry['title'].toString(),
                                      );
                                    },
                                    subtitle: entry['subtitle'] == ''
                                        ? null
                                        : Text(
                                            entry['subtitle'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    onTap: () async {
                                      setState(() {
                                        done = false;
                                      });
                                      final Map? response =
                                          await YouTubeServices()
                                              .formatVideoFromId(
                                        id: entry['id'].toString(),
                                        data: entry,
                                      );

                                      final Map response2 =
                                          await YtMusicService().getSongData(
                                        videoId: entry['id'].toString(),
                                      );
                                      if (response != null &&
                                          response2['image'] != null) {
                                        response['image'] =
                                            response2['image'] ??
                                                response['image'];
                                      }
                                      setState(() {
                                        done = true;
                                      });
                                      PlayerInvoke.init(
                                        songsList: [response],
                                        index: 0,
                                        isOffline: false,
                                        recommend: false,
                                      );
                                      Navigator.pushNamed(context, '/player');
                                      // for (var i = 0;
                                      //     i < searchedList.length;
                                      //     i++) {
                                      //   YouTubeServices()
                                      //       .formatVideo(
                                      //     video: searchedList[i],
                                      //     quality: Hive.box('settings')
                                      //         .get(
                                      //           'ytQuality',
                                      //           defaultValue: 'Low',
                                      //         )
                                      //         .toString(),
                                      //   )
                                      //       .then((songMap) {
                                      //     final MediaItem mediaItem =
                                      //         MediaItemConverter.mapToMediaItem(
                                      //       songMap!,
                                      //     );
                                      //     addToNowPlaying(
                                      //       context: context,
                                      //       mediaItem: mediaItem,
                                      //       showNotification: false,
                                      //     );
                                      //   });
                                      // }
                                    },
                                    trailing:
                                        YtSongTileTrailingMenu(data: entry),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!done)
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 2,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: GradientContainer(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.useHome,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                    strokeWidth: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .fetchingStream,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          MiniPlayer(),
        ],
      ),
    );
  }
}
