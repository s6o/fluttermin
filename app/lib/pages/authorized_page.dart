import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/pages/a_page.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:vrouter/vrouter.dart';

/// A page for authorized content, it wraps [APage] with [AppModel]'s isAuthorized
/// check and in case of false re-directs to /login.
class AuthorizedPage extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const AuthorizedPage({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppModel>(context, listen: false).isAuthorized) {
      return APage(
        key: key,
        builder: builder,
      );
    } else {
      VRouter.of(context).pushReplacement('/login');
      return Container();
    }
  }
}
