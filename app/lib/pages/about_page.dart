import 'package:flutter/material.dart';
import 'package:fluttermin/pages/authorized_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthorizedPage(
      key: key,
      title: Text('About'),
      body: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Fluttermin',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Center(
                      child: Text(
                        snapshot.hasData
                            ? '${(snapshot.data as PackageInfo).version} (${(snapshot.data as PackageInfo).buildNumber})'
                            : '',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        'SPA starter for Web, Android and iOS with Flutter and PostgREST.',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
