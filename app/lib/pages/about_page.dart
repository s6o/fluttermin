import 'package:flutter/material.dart';
import 'package:fluttermin/pages/authorized_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthorizedPage(
      key: key,
      body: Container(
        child: Text('About'),
      ),
    );
  }
}
