import 'dart:async';

import 'package:deeplinks_app/ui/cart_screen.dart';
import 'package:deeplinks_app/ui/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import '../domain/models/routes.dart';
import '../ui/item_list_screen.dart';
import 'navigation_state.dart';

/// NavigatorState – модель, которая определяет состояние навигации, мы ее создаем сами
/// ChangeNotifier – помогает оповещать об изменениях подписчиков, заодно реализует необходимые методы для RouterDelegate: addListener, removerListener
/// PopNavigatorRouterDelegateMixin – помогает управлять возвращением назад, в том числе системным, заодно реализуеи необходимые методы
class MyRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  String? _selectedItemId;
  bool? _isCart;

  @override
  NavigationState get currentConfiguration {
    if (_isCart == true) {
      return NavigationState.cart();
    }

    if (_selectedItemId != null) {
      return NavigationState.item(_selectedItemId);
    }

    return NavigationState.root();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('ItemListScreen'),
          child: ItemListScreen(
            _showCart,
            _showItemDetails,
          ),
        ),
        if (_selectedItemId != null)
          MaterialPage(
            key: ValueKey(_selectedItemId!),
            child: ItemDetailsScreen(
              itemId: _selectedItemId!,
            ),
          ),
        if (_isCart == true)
          const MaterialPage(
            key: ValueKey(Routes.cart),
            child: CartScreen(),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_isCart == true) {
          _isCart = false;
        }

        if (_selectedItemId != null) {
          _selectedItemId = null;
        }

        notifyListeners();
        return true;
      },
    );
  }

  StreamSubscription<String?>? _linkStreamSubscription;

  Future<void> initLinkStream() async {
    await initPlatformState();

    _linkStreamSubscription = linkStream.listen((String? link) {
      _handleLink(link);
    });
  }

  Future<void> initPlatformState() async {
    try {
      await Future.wait<void>([
        getInitialLink(),
        initLinkStream(),
      ]);
      // ignore: empty_catches
    } on PlatformException {}
  }

  @override
  void dispose() {
    _linkStreamSubscription?.cancel(); // Cancel the link stream subscription
    super.dispose();
  }

  Future<void> parseRoute() async {
    final initialLink = await getInitialLink();
    _handleLink(initialLink);

    linkStream.listen((String? link) {
      _handleLink(link);
    });
  }

  void _handleLink(String? link) {
    if (link != null) {
      // Parse the deep link and extract the necessary information
      final uri = Uri.parse(link);
      if (uri.pathSegments.isEmpty) {
        // Handle the root deep link
        _selectedItemId = null;
        _isCart = false;
      } else if (uri.pathSegments.first == Routes.item) {
        final itemId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        _selectedItemId = itemId;
        _isCart = false;
      } else if (uri.pathSegments.first == Routes.cart) {
        _selectedItemId = null;
        _isCart = true;
      }
    } else {
      _selectedItemId = null;
      _isCart = false;
    }

    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    if (configuration.isDetailsScreen) {
      _selectedItemId = configuration.selectedItemId;
    } else if (configuration.isCart) {
      _isCart = true;
    } else {
      _selectedItemId = null;
      _isCart = false;
    }

    notifyListeners();
  }

  void _showItemDetails(String item) {
    _selectedItemId = item;
    notifyListeners();
  }

  void _showCart() {
    _isCart = true;
    notifyListeners();
  }
}
