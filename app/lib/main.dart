import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/login.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttermin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Fluttermin'),
        ),
        body: Consumer<AppModel>(
          builder: (BuildContext ctx, AppModel model, Widget? _) =>
              model.isAuthorized
                  ? Container(
                      child: Text('Authorized'),
                    )
                  : LoginPage(),
        ),
        drawer: Consumer<AppModel>(
          builder: (BuildContext ctx, AppModel model, Widget? w) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Text('Fluttermin'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  if (model.isAuthorized) ..._authorizedItems(context, model),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _authorizedItems(BuildContext context, AppModel model) {
    return <Widget>[
      ListTile(
          title: Text('Logout'),
          onTap: () {
            model.unAuthorize();
            _scaffoldKey.currentState?.openEndDrawer();
          }),
      Divider(),
    ];
  }
}
