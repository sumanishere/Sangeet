//

import 'package:sangeet/Helpers/route_handler.dart';
import 'package:flutter/material.dart';

void handleSharedText(
  String sharedText,
  GlobalKey<NavigatorState> navigatorKey,
) {
  // Add a delay to allow the app to load completely before handling the route
  Future.delayed(const Duration(seconds: 1), () {
    final route = HandleRoute.handleRoute(sharedText);
    if (route != null) navigatorKey.currentState?.push(route);
  });
}
