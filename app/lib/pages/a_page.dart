import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

/// Base page with [Scaffold], [AppBar] and [Drawer] and is meant as basis for
/// every other page in the lib/pages/ directory.
class APage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Widget body;
  final Widget title;

  APage({required this.body, this.title = const Text('Fluttermin'), Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: title),
      body: body,
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
    );
  }

  List<Widget> _authorizedItems(BuildContext context, AppModel model) {
    return <Widget>[
      ListTile(
        title: Text('Logout'),
        onTap: () {
          model.unAuthorize();
          VRouter.of(context).pushReplacement('/login');
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      Divider(),
      ListTile(
        title: Text('About'),
        onTap: () {
          VRouter.of(context).push('/about');
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      ListTile(
        title: Text('Users'),
        onTap: () {
          VRouter.of(context).push('/users');
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    ];
  }
}
