import 'package:flutter/material.dart';
import 'package:fluttermin/pages/a_page.dart';

class AppUsersPage extends StatelessWidget {
  const AppUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return APage(
      key: key,
      child: Container(
        child: Text('App users'),
      ),
    );
  }
}
