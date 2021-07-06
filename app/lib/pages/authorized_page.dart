import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/pages/a_page.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:vrouter/vrouter.dart';

/// A page for authorized content, it wraps [APage] with [AppModel]'s isAuthorized
/// check and in case of false re-directs to /login.
class AuthorizedPage extends StatelessWidget {
  final Widget body;
  final Widget title;

  const AuthorizedPage(
      {required this.body, this.title = const Text('Fluttermin'), Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppModel>(context, listen: false).isAuthorized) {
      return APage(
        key: key,
        body: body,
        title: title,
      );
    } else {
      VRouter.of(context).pushReplacement('/login');
      return Container();
    }
  }
}
