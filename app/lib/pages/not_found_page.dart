import 'package:flutter/material.dart';
import 'package:fluttermin/pages/a_page.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return APage(
      key: key,
      body: Container(
        child: Text('Not Found'),
      ),
    );
  }
}
