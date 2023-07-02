import 'package:deeplinks_app/domain/items_repository.dart';
import 'package:deeplinks_app/domain/models/routes.dart';
import 'package:flutter/material.dart';

import 'navigation_state.dart';

/// URI <> NavigationState
class MyRouteInformationParser extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.location;
    if (location == null) {
      return NavigationState.unknown();
    }

    final uri = Uri.parse(location);

    if (uri.pathSegments.isEmpty) {
      return NavigationState.root();
    }

    if (uri.pathSegments.length == 2) {
      final itemId = uri.pathSegments[1];

      if (uri.pathSegments[0] == Routes.item &&
          ItemsRepository.items.any((item) => item.id == itemId)) {
        return NavigationState.item(itemId);
      }

      return NavigationState.unknown();
    }

    if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      if (path == Routes.cart) {
        return NavigationState.cart();
      }

      return NavigationState.root();
    }

    return NavigationState.root();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isCart) {
      return const RouteInformation(location: '/${Routes.cart}');
    }

    if (configuration.isDetailsScreen) {
      return RouteInformation(
          location: '/${Routes.item}/${configuration.selectedItemId}');
    }

    if (configuration.isUnknown) {
      return null;
    }

    return const RouteInformation(location: '/');
  }
}
