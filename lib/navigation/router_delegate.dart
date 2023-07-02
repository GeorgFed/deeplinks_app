import 'package:deeplinks_app/ui/cart_screen.dart';
import 'package:deeplinks_app/ui/item_details_screen.dart';
import 'package:deeplinks_app/ui/item_list_screen.dart';
import 'package:deeplinks_app/ui/unknown_screen.dart';
import 'package:flutter/material.dart';

import 'navigation_state.dart';

class MyRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  NavigationState? state;

  @override
  NavigationState get currentConfiguration {
    return state ?? NavigationState.root();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: ItemListScreen(
            onItemTap: _showItemDetails,
            onTapCart: _showCart,
          ),
        ),
        if (state?.isCart == true)
          const MaterialPage(
            child: CartScreen(),
          ),
        if (state?.isDetailsScreen == true)
          MaterialPage(
            child: ItemDetailsScreen(
              itemId: state?.selectedItemId,
            ),
          ),
        if (state?.isUnknown == true)
          const MaterialPage(
            child: UnknownScreen(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        state = NavigationState.root();

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    state = configuration;
    notifyListeners();
  }

  void _showItemDetails(String itemId) {
    state = NavigationState.item(itemId);
    notifyListeners();
  }

  void _showCart() {
    state = NavigationState.cart();
    notifyListeners();
  }
}
