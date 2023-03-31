//

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget imageCard(
  String imageUrl, {
  bool localImage = false,
  double elevation = 5,
  double radius = 15.0,
  ImageProvider? placeholderImage,
}) {
  return Card(
    elevation: elevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    clipBehavior: Clip.antiAlias,
    child: localImage
        ? Image(
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) => const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/cover.jpg'),
            ),
            image: FileImage(
              File(
                imageUrl,
              ),
            ),
          )
        : CachedNetworkImage(
            fit: BoxFit.cover,
            errorWidget: (context, _, __) => const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/cover.jpg'),
            ),
            imageUrl: imageUrl,
            placeholder: placeholderImage == null
                ? null
                : (context, url) => Image(
                      fit: BoxFit.cover,
                      image: placeholderImage,
                    ),
          ),
  );
}
