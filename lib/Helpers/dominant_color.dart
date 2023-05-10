//

import 'package:sangeet/Helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';

Future<List<Color>> getColors({
  required ImageProvider imageProvider,
}) async {
  PaletteGenerator paletteGenerator;
  paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
  final Color dominantColor =
      paletteGenerator.dominantColor?.color ?? Colors.black;
  final Color darkMutedColor =
      paletteGenerator.darkMutedColor?.color ?? Colors.black;
  final Color lightMutedColor =
      paletteGenerator.lightMutedColor?.color ?? dominantColor;
  if (dominantColor.computeLuminance() < darkMutedColor.computeLuminance()) {
    // checks if the luminance of the darkMuted color is > than the luminance of the dominant
    GetIt.I<MyTheme>().playGradientColor = [
      darkMutedColor,
      dominantColor,
    ];
    return [
      darkMutedColor,
      dominantColor,
    ];
  } else if (dominantColor == darkMutedColor) {
    // if the two colors are the same, it will replace dominantColor by lightMutedColor
    GetIt.I<MyTheme>().playGradientColor = [
      lightMutedColor,
      darkMutedColor,
    ];
    return [
      lightMutedColor,
      darkMutedColor,
    ];
  } else {
    GetIt.I<MyTheme>().playGradientColor = [
      dominantColor,
      darkMutedColor,
    ];
    return [
      dominantColor,
      darkMutedColor,
    ];
  }
}
