import 'package:deeplinks_app/ui/cart_screen.dart';
import 'package:deeplinks_app/ui/item_details_screen.dart';
import 'package:flutter/material.dart';

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
