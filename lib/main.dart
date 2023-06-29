import 'package:deeplinks_app/ui/cart_screen.dart';
import 'package:deeplinks_app/ui/item_details_screen.dart';
import 'package:deeplinks_app/ui/item_list_screen.dart';
import 'package:deeplinks_app/ui/unknown_screen.dart';
import 'package:flutter/material.dart';

import 'domain/models/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Онлайн магазин',
      initialRoute: Routes.root,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.root:
            return MaterialPageRoute(builder: (_) => ItemListScreen());
          case Routes.item:
            return MaterialPageRoute(
                builder: (_) =>
                    ItemDetailsScreen(itemId: settings.arguments as String));
          case Routes.cart:
            return MaterialPageRoute(builder: (_) => const CartScreen());
          case Routes.unknown:
            MaterialPageRoute(builder: (_) => UnknownScreen(settings.name));
        }

        return null;
      },
    );
  }
}
