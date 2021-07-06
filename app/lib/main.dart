import 'package:flutter/material.dart';
import 'package:fluttermin/pages/about_page.dart';
import 'package:fluttermin/pages/app_users_page.dart';
import 'package:fluttermin/pages/login_page.dart';
import 'package:fluttermin/pages/not_found_page.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:vrouter/vrouter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (BuildContext ctx, AppModel model, Widget? _) {
        return VRouter(
          initialUrl: model.isAuthorized ? '/about' : '/login',
          title: 'Fluttermin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: [
            VWidget(path: '/login', widget: LoginPage()),
            VWidget(path: '/about', widget: AboutPage()),
            VWidget(path: '/users', widget: AppUsersPage()),
            VWidget(path: '/404', widget: NotFoundPage()),
            VRouteRedirector(path: ':_(.+)', redirectTo: '/404')
          ],
        );
      },
    );
  }
}
