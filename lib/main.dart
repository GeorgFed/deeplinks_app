import 'package:deeplinks_app/navigation/route_information_parser.dart';
import 'package:deeplinks_app/navigation/router_delegate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routerInformationParser = MyRouteInformationParser();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Онлайн магазин',
        routerDelegate: _routerDelegate,
        routeInformationParser: _routerInformationParser,
      );
}
