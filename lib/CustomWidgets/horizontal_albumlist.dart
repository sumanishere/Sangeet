//

import 'package:Sangeet/CustomWidgets/like_button.dart';
import 'package:Sangeet/CustomWidgets/on_hover.dart';
import 'package:Sangeet/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:Sangeet/Helpers/image_resolution_modifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HorizontalAlbumsList extends StatelessWidget {
  final List songsList;
  final Function(int) onTap;
  const HorizontalAlbumsList({
    super.key,
    required this.songsList,
    required this.onTap,
  });

  String formatString(String? text) {
    return text == null
        ? ''
        : text
            .replaceAll('&amp;', '&')
            .replaceAll('&#039;', "'")
            .replaceAll('&quot;', '"')
            .trim();
  }

  String getSubTitle(Map item) {
    final type = item['type'];
    if (type == 'charts') {
      return '';
    } else if (type == 'playlist' || type == 'radio_station') {
      return formatString(item['subtitle']?.toString());
    } else if (type == 'song') {
      return formatString(item['artist']?.toString());
    } else {
      if (item['subtitle'] != null) {
        return formatString(item['subtitle']?.toString());
      }
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      if (artists != null) {
        return formatString(artists?.join(', ')?.toString());
      }
      if (item['artist'] != null) {
        return formatString(item['artist']?.toString());
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.height / 2.5;
    if (boxSize > 250) boxSize = 250;
    return SizedBox(
      height: boxSize + 15,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: songsList.length,
        itemBuilder: (context, index) {
          final Map item = songsList[index] as Map;
          final subTitle = getSubTitle(item);
          return GestureDetector(
            onLongPress: () {
              Feedback.forLongPress(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          item['type'] == 'radio_station' ? 1000.0 : 15.0,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (context, _, __) => const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/cover.jpg'),
                        ),
                        imageUrl: getImageUrl(item['image'].toString()),
                        placeholder: (context, url) => Image(
                          fit: BoxFit.cover,
                          image: (item['type'] == 'playlist' ||
                                  item['type'] == 'album')
                              ? const AssetImage(
                                  'assets/album.png',
                                )
                              : item['type'] == 'artist'
                                  ? const AssetImage(
                                      'assets/artist.png',
                                    )
                                  : const AssetImage(
                                      'assets/cover.jpg',
                                    ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            onTap: () {
              onTap(index);
            },
            child: SizedBox(
              width: boxSize - 30,
              child: HoverBox(
                child: Card(
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      item['type'] == 'radio_station' ||
                              item['type'] == 'artist'
                          ? 1000.0
                          : 10.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (context, _, __) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/cover.jpg'),
                    ),
                    imageUrl: getImageUrl(item['image'].toString()),
                    placeholder: (context, url) => Image(
                      fit: BoxFit.cover,
                      image: (item['type'] == 'playlist' ||
                              item['type'] == 'album')
                          ? const AssetImage(
                              'assets/album.png',
                            )
                          : item['type'] == 'artist'
                              ? const AssetImage(
                                  'assets/artist.png',
                                )
                              : const AssetImage(
                                  'assets/cover.jpg',
                                ),
                    ),
                  ),
                ),
                builder: (BuildContext context, bool isHover, Widget? child) {
                  return Card(
                    color: isHover ? null : Colors.transparent,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox.square(
                              dimension: isHover ? boxSize - 25 : boxSize - 30,
                              child: child,
                            ),
                            if (isHover &&
                                (item['type'] == 'song' ||
                                    item['type'] == 'radio_station' ||
                                    item['duration'] != null))
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.all(
                                    4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(
                                      item['type'] == 'radio_station'
                                          ? 1000.0
                                          : 10.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(1000.0),
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 50.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (isHover &&
                                (item['type'] == 'song' ||
                                    item['duration'] != null))
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LikeButton(
                                      mediaItem: null,
                                      data: item,
                                    ),
                                    SongTileTrailingMenu(
                                      data: item,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatString(item['title']?.toString()),
                                textAlign: TextAlign.center,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (subTitle.isNotEmpty)
                                Text(
                                  subTitle,
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
