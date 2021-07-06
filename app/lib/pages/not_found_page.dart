import 'package:flutter/material.dart';
import 'package:fluttermin/pages/a_page.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return APage(
      key: key,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Page Not Found',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Requested URL does not point to a valid page.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
