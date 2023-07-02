import 'package:deeplinks_app/navigation/route_information_parser.dart';
import 'package:flutter/material.dart';

import 'navigation/router_delegate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routeInformationParser = MyRouteInformationParser();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Онлайн магазин',
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      );
}
