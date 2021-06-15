import 'package:flutter/material.dart';
import 'package:fluttermin/app_route_parser.dart';
import 'package:fluttermin/app_router_delegate.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/models/app_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppModel(),
      child: Fluttermin(),
    ),
  );
}

class Fluttermin extends StatefulWidget {
  @override
  _FlutterminState createState() => _FlutterminState();
}

class _FlutterminState extends State<Fluttermin> {
  AppRouterDelegate _routerDelegate = AppRouterDelegate();
  AppRouteParser? _routeParser;

  @override
  void initState() {
    super.initState();
    _routeParser = AppRouteParser(
      Provider.of<AppModel>(context, listen: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fluttermin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeParser!,
    );
  }
}
