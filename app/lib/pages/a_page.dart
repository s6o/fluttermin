import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:provider/provider.dart';

/// Base page with [Scaffold], [AppBar] and [Drawer] and is meant as basis for
/// every other page in the lib/pages/ directory.
class APage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Widget Function(BuildContext) builder;

  APage({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Fluttermin'),
      ),
      body: builder(context),
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
                if (AppModel.isAuthorized) ..._authorizedItems(context, model),
              ],
            ),
          );
        },
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
