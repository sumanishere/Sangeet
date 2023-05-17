import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Collage extends StatelessWidget {
  final bool showGrid;
  final List imageList;
  final String placeholderImage;
  final double borderRadius;
  const Collage({
    super.key,
    this.borderRadius = 7.0,
    required this.showGrid,
    required this.imageList,
    required this.placeholderImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox.square(
        dimension: 50,
        child: showGrid
            ? GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: imageList.length < 4 ? 1 : 2,
                children: imageList
                    .map(
                      (image) => CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (context, _, __) => Image(
                          fit: BoxFit.cover,
                          image: AssetImage(placeholderImage),
                        ),
                        imageUrl: image['image']
                            .toString()
                            .replaceAll('http:', 'https:'),
                        placeholder: (context, _) => Image(
                          fit: BoxFit.cover,
                          image: AssetImage(placeholderImage),
                        ),
                      ),
                    )
                    .toList(),
              )
            : CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
                imageUrl: imageList[0]['image']
                    .toString()
                    .replaceAll('http:', 'https:'),
                placeholder: (context, _) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
              ),
      ),
    );
  }
}

class OfflineCollage extends StatelessWidget {
  final List imageList;
  final String placeholderImage;
  final bool showGrid;
  const OfflineCollage({
    super.key,
    required this.showGrid,
    required this.imageList,
    required this.placeholderImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          7.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox.square(
        dimension: 50,
        child: showGrid
            ? GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: imageList.length < 4 ? 1 : 2,
                children: imageList.map((image) {
                  return image == null
                      ? Image(
                          fit: BoxFit.cover,
                          image: AssetImage(placeholderImage),
                        )
                      : Image(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(
                              image['image'].toString(),
                            ),
                          ),
                          errorBuilder: (context, _, __) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage(placeholderImage),
                          ),
                        );
                }).toList(),
              )
            : imageList[0] == null
                ? Image(
                    fit: BoxFit.cover,
                    image: AssetImage(placeholderImage),
                  )
                : Image(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(
                        imageList[0]['image'].toString(),
                      ),
                    ),
                    errorBuilder: (context, _, __) => Image(
                      fit: BoxFit.cover,
                      image: AssetImage(placeholderImage),
                    ),
                  ),
      ),
    );
  }
}
